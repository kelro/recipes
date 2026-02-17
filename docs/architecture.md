# Recipes Site — Architecture & Operations Guide

**Version:** v1.1.0  
**Maintainer:** Ron Kelley  
**Repository:** https://github.com/kelro/recipes  
**Hosting:** GitHub Pages (Public)  
**Deployment Model:** Static Site  

---

## 1. Purpose

This site hosts a personal recipe collection used regularly for cooking.  
It is designed to be:

- Stable  
- Fast  
- Mobile-friendly (especially iPhone Safari)  
- Printable  
- Easy to maintain  
- Free to host  

There is **no backend, database, or build system**.  
Stability and simplicity are prioritized over complexity.

---

## 2. Hosting & Deployment Model

- Hosted on **GitHub Pages**
- Served from the `main` branch
- Public URL:  
  https://kelro.github.io/recipes/

This is a fully static site. No server-side code runs.

### Deployment Workflow

Local working directory:

```bash
/home/ron/Code/recipes
```

Deployment steps:

```bash
git add .
git commit -m "Describe change"
git push origin main
```

GitHub Pages auto-deploys after push.  
There is no build step.

Git history serves as the rollback mechanism.

---

## 3. Directory Structure

Current structure (flattened for clean URLs):

```text
recipes/
├── css/
│   ├── slate.css
│   ├── recipes.css
│   └── print.css
│
├── js/
│   ├── sidebar.js
│   └── cook-mode.js
│
├── data/
│   └── recipes.json
│
├── docs/
│   └── architecture.md
│
├── index.html
├── 404.html
├── favicon.png
├── normalize-categories.sh
└── recipe-template.html
```

All recipe pages live at repository root:

```
recipe-name.html
```

Example clean URL:

```
https://kelro.github.io/recipes/apricot-cookies.html
```

---

## 4. Data Model

Navigation and listing are generated from:

```
data/recipes.json
```

Each recipe entry includes:

- `title`
- `category`
- `path`
- Optional `tags`

This centralizes navigation metadata and avoids duplicated links.

---

## 5. Layout Philosophy (Stability Policy)

This site intentionally avoids layout patterns known to cause instability.

### Rules

- Only the browser body scrolls  
- No nested scroll containers  
- Avoid `height: 100vh` for structural layout  
- Avoid `overflow: hidden` on structural containers  
- Avoid complex positioning tricks unless tested on iOS  

### Reason

Mobile Safari and Chrome can misbehave when:

- Multiple scroll contexts exist  
- Viewport height dynamically changes  
- Scroll locking is introduced  

**Boring = stable. Stable = good.**

---

## 6. Styling System

Core styles:

```
css/slate.css
css/recipes.css
```

Print styles:

```
css/print.css
```

Design goals:

- Clean typography  
- High contrast  
- Print-friendly output  
- Minimal animation  
- Readable on small screens  

No CSS frameworks are used.

---

## 7. JavaScript Components

Lightweight, dependency-free JavaScript.

Files:

```
js/sidebar.js
js/cook-mode.js
```

Dynamic behavior includes:

- Sidebar generation from `recipes.json`
- Search filtering
- Cook Mode behavior
- GitHub API “Last Updated” badge

No frameworks.  
No external libraries.  
No build tooling.

---

## 8. Versioning Strategy

Footer example:

```
Recipes · v1.1.0
Last updated: Feb 17, 2026
```

Versioning approach:

- v1.0.x — structural changes  
- v1.1.x — UI improvements  
- v1.x.x — feature additions  

The “Last Updated” value is retrieved from:

```
https://api.github.com/repos/kelro/recipes/commits/main
```

---

## 9. Recovery Strategy

If something breaks:

```bash
git log --oneline
git revert <commit-id>
git push origin main
```

GitHub Pages will redeploy automatically.

Git history is the recovery system.

---

## 10. Branch Strategy

Typical flow:

```bash
git checkout -b feature-name
git commit -m "Add feature"
git checkout main
git merge feature-name
git push origin main
```

---

## 11. Adding a New Recipe

1. Duplicate `recipe-template.html`
2. Rename the file
3. Add entry in `data/recipes.json`
4. Test locally
5. Commit and push

---

## 12. Security Notes

- Site is public  
- No sensitive information stored  
- No authentication required  
- GitHub Pages provides HTTPS  

No secrets or tokens are stored in the repository.

---

## 13. Operational Philosophy

This site is used daily for cooking.

Guidelines:

- Avoid unnecessary complexity  
- Do not rewrite layout without reason  
- Test on iPhone Safari before pushing  
- Prefer maintainability over novelty  
- Keep it simple  

This is a practical tool first.  
A technical experiment second.

---

**End of Document**
