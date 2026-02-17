# Contributing to Recipes

Thank you for contributing to the Recipes site.

This project is a clean, static HTML recipe collection hosted on GitHub Pages.  
It is intentionally simple, stable, and dependency‑free.

---

## Project Overview

- **Repository:** https://github.com/kelro/recipes  
- **Hosting:** GitHub Pages  
- **Branch:** `main`  
- **Deployment:** Automatic on push  
- **Versioning:** Auto‑increment patch version  

The site is designed for reliability and daily use.

---

## Project Structure

```
/
├── index.html
├── 404.html
├── css/
│   ├── slate.css
│   ├── recipes.css
│   └── print.css
├── js/
│   ├── sidebar.js
│   └── cook-mode.js
├── data/
│   ├── recipes.json
│   └── version.json
├── docs/
│   └── architecture.md
└── .github/workflows/
```

All recipe HTML files live in the repository root for clean URLs.

---

## Adding a New Recipe

1. Duplicate `recipe-template.html`
2. Rename it (example: `new-recipe.html`)
3. Edit the content
4. Add an entry to `data/recipes.json`

Example entry:

```json
{
  "title": "New Recipe",
  "category": "Main Dishes",
  "path": "new-recipe.html"
}
```

5. Test locally
6. Commit and push

---

## Automatic Validation

Every push to `main` automatically:

- Validates `data/recipes.json`
- Verifies all recipe file paths exist
- Increments the patch version
- Deploys the site via GitHub Pages

If validation fails, deployment will not proceed.

---

## Versioning

Version number is stored in:

```
data/version.json
```

Patch version increments automatically on each push to `main`.

Example:

```
1.1.0 → 1.1.1
```

The version is displayed in the site footer.

---

## Design Principles

- Clean
- Printable
- Static only
- No frameworks
- Minimal JavaScript
- Mobile‑first layout
- Stability over complexity

Avoid introducing:

- Nested scroll containers
- `height: 100vh` layout locking
- Heavy dependencies
- Complex tooling

---

## Deployment Workflow

From local machine:

```bash
git add .
git commit -m "Describe change"
git push origin main
```

GitHub Actions will:

1. Validate the site
2. Bump the version
3. Redeploy automatically

---

## Stability Policy

This site is used daily for cooking.

Before pushing changes:

- Test on desktop
- Test on iPhone Safari
- Confirm navigation works
- Confirm search works
- Confirm print layout works

Prefer boring and reliable over clever and complex.

---

## Questions or Improvements

Open an issue or submit a pull request.

Keep it simple. Keep it stable.
