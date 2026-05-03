# portal

**2YH — Health in Your Hands** marketing / landing site. Static HTML + pure CSS
(Fraunces / Geist / Geist Mono), no build step. Deployed on **Cloudflare Pages**.

## Layout

```
portal/
├── index.html          # landing page
├── ios-frame.jsx       # iOS device frame React components
├── screens.jsx         # App screen React components (rendered via Babel)
├── i18n/
│   ├── i18n.js         # client-side loader + language switcher wiring
│   ├── en.json         # English (default)
│   ├── es.json         # Spanish
│   ├── pt.json         # Portuguese (Portugal)
│   ├── pt-BR.json      # Portuguese (Brazil)
│   └── fr.json         # French
├── _headers            # Cloudflare Pages headers (security + caching)
├── wrangler.toml       # Pages config — legacy health2u-portal project
├── wrangler.2yh.toml   # Pages config — 2yh-portal project
├── scripts/
│   ├── deploy.sh       # Deploy to health2u-portal (legacy)
│   └── deploy-2yh.sh   # Deploy to 2yh-portal (current)
├── .gitignore
└── README.md
```

## Deployments

There are two Cloudflare Pages projects. Both deploy the same static files
from this directory.

| Project | Script | Production URL |
|---------|--------|----------------|
| `health2u-portal` (legacy) | `./scripts/deploy.sh` | `https://health2u-portal.pages.dev` |
| `2yh-portal` (current) | `./scripts/deploy-2yh.sh` | `https://2yh-portal.pages.dev` |

### Preview deploy

```bash
./scripts/deploy-2yh.sh          # unique URL per deploy, safe to share
```

### Production deploy

```bash
BRANCH=main ./scripts/deploy-2yh.sh
```

On first run, wrangler will prompt to create the `2yh-portal` Pages project.
Accept.

### One-time setup

```bash
npm i -g wrangler
wrangler login
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
3. Add a `<button data-lang-option="<tag>">` row to the switcher dropdown
   in `index.html`.

### Adding a new translatable string

1. Add the key to **every** `i18n/*.json` file (same path in all locales).
2. Add `data-i18n="section.key"` to the element in `index.html`. The element's
   existing text is kept as a fallback if the JSON fetch fails.

## Custom domain

Add a domain in the Cloudflare dashboard → Pages → `2yh-portal` →
Custom domains. Cloudflare issues the TLS cert automatically (~1 min).

## Local preview

```bash
cd portal
python3 -m http.server 8081
# → http://localhost:8081/
```
