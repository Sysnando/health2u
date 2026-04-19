// Minimal client-side i18n for the static portal.
//
// Language resolution order:
//   1. ?lang=xx query string
//   2. localStorage 'portal.lang'
//   3. navigator.language / navigator.languages
//   4. fallback 'en'
//
// Usage in HTML:
//   <span data-i18n="hero.subtitle"></span>            -> textContent
//   <input data-i18n-attr="placeholder:form.email">    -> attribute
//   <meta data-i18n-attr="content:meta.description">
//
// Missing keys render the key itself (visible during dev).

(function () {
  "use strict";

  var SUPPORTED = ["en", "es", "pt", "pt-BR", "fr"];
  var DEFAULT = "en";
  var STORAGE_KEY = "portal.lang";

  // Map any incoming locale to our supported set.
  function normalize(tag) {
    if (!tag) return null;
    tag = String(tag).trim();
    if (!tag) return null;

    // Exact match first (handles "pt-BR").
    for (var i = 0; i < SUPPORTED.length; i++) {
      if (SUPPORTED[i].toLowerCase() === tag.toLowerCase()) return SUPPORTED[i];
    }

    var lower = tag.toLowerCase();

    // Portuguese regions: Brazilian variants -> pt-BR, everything else pt.
    if (lower.indexOf("pt") === 0) {
      if (lower === "pt-br" || lower.indexOf("pt-br") === 0) return "pt-BR";
      return "pt";
    }

    // Primary subtag match (e.g. "en-US" -> "en", "fr-CA" -> "fr").
    var primary = lower.split("-")[0];
    for (var j = 0; j < SUPPORTED.length; j++) {
      if (SUPPORTED[j].toLowerCase() === primary) return SUPPORTED[j];
    }
    return null;
  }

  function detect() {
    var qs = new URLSearchParams(window.location.search).get("lang");
    var fromQs = normalize(qs);
    if (fromQs) return fromQs;

    try {
      var stored = normalize(localStorage.getItem(STORAGE_KEY));
      if (stored) return stored;
    } catch (_) {}

    var navLangs = (navigator.languages && navigator.languages.length)
      ? navigator.languages
      : [navigator.language];
    for (var i = 0; i < navLangs.length; i++) {
      var n = normalize(navLangs[i]);
      if (n) return n;
    }
    return DEFAULT;
  }

  function lookup(dict, dottedKey) {
    var parts = dottedKey.split(".");
    var cur = dict;
    for (var i = 0; i < parts.length; i++) {
      if (cur == null || typeof cur !== "object") return undefined;
      cur = cur[parts[i]];
    }
    return cur;
  }

  function applyTranslations(dict) {
    // textContent
    document.querySelectorAll("[data-i18n]").forEach(function (el) {
      var key = el.getAttribute("data-i18n");
      var val = lookup(dict, key);
      if (typeof val === "string") el.textContent = val;
    });

    // attribute translations: "attr:key[,attr:key]"
    document.querySelectorAll("[data-i18n-attr]").forEach(function (el) {
      var spec = el.getAttribute("data-i18n-attr");
      spec.split(",").forEach(function (pair) {
        var idx = pair.indexOf(":");
        if (idx < 0) return;
        var attr = pair.slice(0, idx).trim();
        var key = pair.slice(idx + 1).trim();
        var val = lookup(dict, key);
        if (typeof val === "string") el.setAttribute(attr, val);
      });
    });
  }

  function markActiveSwitcher(lang) {
    document.querySelectorAll("[data-lang-option]").forEach(function (el) {
      el.setAttribute(
        "aria-current",
        el.getAttribute("data-lang-option") === lang ? "true" : "false"
      );
    });
    var current = document.querySelector("[data-lang-current]");
    if (current) current.textContent = lang.toUpperCase();
  }

  async function load(lang) {
    // Cache-bust via version query so deploys pick up new strings.
    var url = "i18n/" + lang + ".json";
    var res = await fetch(url, { cache: "no-cache" });
    if (!res.ok) throw new Error("i18n fetch failed: " + lang);
    return res.json();
  }

  async function setLanguage(lang, opts) {
    opts = opts || {};
    var target = normalize(lang) || DEFAULT;
    var dict;
    try {
      dict = await load(target);
    } catch (e) {
      if (target !== DEFAULT) {
        target = DEFAULT;
        dict = await load(DEFAULT);
      } else {
        throw e;
      }
    }
    document.documentElement.setAttribute("lang", target);
    applyTranslations(dict);
    markActiveSwitcher(target);
    try {
      localStorage.setItem(STORAGE_KEY, target);
    } catch (_) {}
    if (opts.updateUrl) {
      var u = new URL(window.location.href);
      u.searchParams.set("lang", target);
      window.history.replaceState({}, "", u.toString());
    }
    window.dispatchEvent(new CustomEvent("i18n:changed", { detail: { lang: target } }));
  }

  function wireSwitcher() {
    document.addEventListener("click", function (e) {
      var opt = e.target.closest("[data-lang-option]");
      if (!opt) return;
      e.preventDefault();
      setLanguage(opt.getAttribute("data-lang-option"), { updateUrl: true });
      // Collapse dropdown if open.
      var dd = opt.closest("[data-lang-dropdown]");
      if (dd) dd.removeAttribute("data-open");
    });

    document.addEventListener("click", function (e) {
      var toggle = e.target.closest("[data-lang-toggle]");
      if (toggle) {
        var dd = toggle.closest("[data-lang-dropdown]");
        if (dd) {
          if (dd.hasAttribute("data-open")) dd.removeAttribute("data-open");
          else dd.setAttribute("data-open", "");
        }
        return;
      }
      // Click outside closes the dropdown.
      document.querySelectorAll("[data-lang-dropdown][data-open]").forEach(function (dd) {
        if (!dd.contains(e.target)) dd.removeAttribute("data-open");
      });
    });
  }

  window.portalI18n = {
    setLanguage: setLanguage,
    supported: SUPPORTED.slice(),
  };

  document.addEventListener("DOMContentLoaded", function () {
    wireSwitcher();
    setLanguage(detect()).catch(function (err) {
      console.error("[i18n] failed to initialize:", err);
    });
  });
})();
