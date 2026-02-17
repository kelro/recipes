Recipes Site — Architecture & Operations Guide

Version: v1.1.0
Maintainer: Ron Kelley
Repository: https://github.com/kelro/recipes

Hosting: GitHub Pages (public)
Deployment Model: Static Site

Purpose

This site hosts a personal recipe collection used regularly for cooking.
It is designed to be:

Stable

Fast

Mobile-friendly (especially iPhone Safari)

Printable

Easy to maintain

Free to host

There is no backend, database, or build system.

Stability and simplicity are prioritized over complexity.

Hosting & Deployment Model

The site is:

Hosted on GitHub Pages

Served from the main branch

Publicly accessible at:

https://kelro.github.io/recipes/

This is a fully static site.
No server-side code runs.

Deployment Workflow:

Local working directory:
/home/ron/Code/recipes

Deployment process:

Edit locally

Test in browser

Commit changes:

git add .
git commit -m "Describe change"
git push origin main

GitHub Pages auto-deploys

There is no build step.
Git history acts as the rollback mechanism.

Directory Structure

Current structure (flattened for clean URLs):

recipes/
├── css/
│ ├── slate.css
│ ├── recipes.css
│ └── print.css
│
├── js/
│ ├── sidebar.js
│ └── cook-mode.js
│
├── data/
│ └── recipes.json
│
├── docs/
│ └── architecture.md
│
├── index.html
├── 404.html
├── favicon.png
├── normalize-categories.sh
└── recipe-template.html

All individual recipe pages live at repository root as:

recipe-name.html

This ensures clean URLs like:

https://kelro.github.io/recipes/apricot-cookies.html

Data Model

Navigation and listing are generated from:

data/recipes.json

Each recipe entry includes:

Title

Category

Path (e.g., "apricot-cookies.html")

Optional tags

This keeps metadata centralized and avoids hardcoding links in multiple places.

Layout Philosophy (Stability Policy)

This site intentionally avoids layout patterns known to cause instability.

Rules:

Only the browser body scrolls.

No nested scroll containers.

Avoid height: 100vh for structural layout.

Avoid overflow: hidden on structural containers.

Avoid complex positioning tricks unless fully tested on iOS.

Reason:

Mobile Safari and Chrome can misbehave when:

Multiple scroll contexts exist

Viewport height changes dynamically

Scroll locking is introduced

The layout should behave like a normal webpage.

Boring = stable.
Stable = good.

Styling System

Core styles:

css/slate.css
css/recipes.css

Print styles:

css/print.css

Design goals:

Clean typography

High contrast

Print-friendly output

Minimal animation

Readable on small screens

No CSS frameworks are used.

JavaScript Components

JavaScript is lightweight and dependency-free.

Files:

js/sidebar.js
js/cook-mode.js

Dynamic behavior includes:

Sidebar generation from recipes.json

Search filtering

Cook Mode behavior

GitHub API call for “Last Updated” footer stamp

No frameworks.
No external libraries.
No build tooling.

Versioning Strategy

Version badge displayed in footer:

Recipes · v1.1.0
Last updated: Feb 17, 2026

Versioning approach:

v1.0.x — structural changes

v1.1.x — UI improvements

v1.x.x — feature additions

The “Last Updated” field is dynamically retrieved from:

https://api.github.com/repos/kelro/recipes/commits/main

This ensures the footer reflects the most recent commit date.

Recovery Strategy

If something breaks:

Inspect recent commits:

git log --oneline

Revert a commit:

git revert <commit-id>

Push:

git push origin main

GitHub Pages will redeploy automatically.

The repository history is the recovery system.

Branch Strategy

Typical flow:

Create feature branch

Test locally

Merge into main

Push to production

Example:

git checkout -b feature-name
git commit -m "Add feature"
git checkout main
git merge feature-name
git push origin main

Adding a New Recipe

Steps:

Duplicate recipe-template.html

Rename to desired recipe file name

Add entry in data/recipes.json

Test locally

Commit and push

Security Notes

Site is public

No sensitive information is stored

No authentication required

GitHub Pages provides HTTPS automatically

No secrets or tokens are stored in repository.

Operational Philosophy

This site is used daily for cooking.

Guidelines:

Do not introduce unnecessary complexity.

Do not rewrite layout without reason.

Test on iPhone Safari before pushing.

Prefer maintainability over novelty.

Keep it simple.

This is a practical tool first.
A technical experiment second.
