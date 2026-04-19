# portal

Health2U marketing / landing site. Static HTML + Tailwind (via CDN), no
build step. Deployed on **Cloudflare Pages**.

## Layout

```
portal/
├── index.html          # landing page (was landing.html)
├── landing.png         # design reference image
├── i18n/
│   ├── i18n.js         # client-side loader + language switcher wiring
│   ├── en.json         # English (default)
│   ├── es.json         # Spanish
│   ├── pt.json         # Portuguese (Portugal)
│   ├── pt-BR.json      # Portuguese (Brazil)
│   └── fr.json         # French
├── _headers            # Cloudflare Pages headers (security + caching)
├── wrangler.toml       # Pages project config
├── scripts/
│   └── deploy.sh
├── .gitignore
└── README.md
```

## Internationalization

Copy is marked in HTML with `data-i18n="section.key"` (textContent) or
`data-i18n-attr="attr:section.key"` (attribute — used for `<meta content>`,
`placeholder`, etc.). Strings live in `i18n/*.json`.

Language detection order:

1. `?lang=xx` query string (e.g. `?lang=pt-BR`)
2. `localStorage['portal.lang']` (set by the switcher in the nav)
3. `navigator.languages` — mapped to the closest supported locale
4. Fallback: `en`

Supported today: `en`, `es`, `pt` (Portugal), `pt-BR` (Brazil), `fr`.

### Adding a language

1. Copy `i18n/en.json` to `i18n/<tag>.json` and translate values.
2. Add the tag to `SUPPORTED` in `i18n/i18n.js`.
3. Add a `<li><button data-lang-option="<tag>">…</button></li>` row to the
   switcher dropdown in `index.html`.

### Adding a new translatable string

1. Add the key to **every** `i18n/*.json` file (same path in all locales).
2. Add `data-i18n="section.key"` to the element in `index.html`. The element's
   existing text is kept as a fallback if the JSON fetch fails.

## Deploying

One-time:

```bash
npm i -g wrangler
wrangler login
```

Preview deploy (unique URL per deploy, safe to share for review):

```bash
./scripts/deploy.sh
```

Production deploy (promotes to `https://health2u-portal.pages.dev` and any
custom domain attached in the Cloudflare dashboard):

```bash
BRANCH=main ./scripts/deploy.sh
```

On first run, wrangler will prompt to create the Pages project
`health2u-portal`. Accept.

## Custom domain

Add a domain in the Cloudflare dashboard → Pages → `health2u-portal` →
Custom domains. Cloudflare issues the TLS cert automatically (~1 min).

## Local preview

```bash
# Any static server works. Example:
python3 -m http.server 8080
# → http://localhost:8080/
```
