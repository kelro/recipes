#!/usr/bin/env bash
# ==============================================================
# lint-recipes.sh
#
# PURPOSE:
#   Lints all recipe HTML files to ensure structural and styling
#   compliance with the Prime Rib standard template.
#
# WHAT IT CHECKS:
#   • Required CSS files
#   • Required JS (sidebar)
#   • Required structural blocks
#   • Proper All Recipes link
#   • Forbidden asset references
#
# SAFE:
#   • Read-only
#   • No file modifications
#
# USAGE:
#   ./lint-recipes.sh
#
# ==============================================================

set -euo pipefail

ROOT="/home/ron/Code/recipes"
ERRORS=0
FILES=()

echo "========================================="
echo " RECIPE LINT REPORT"
echo " ROOT: $ROOT"
echo "========================================="
echo ""

# --------------------------------------------------------------
# Collect all HTML files
# --------------------------------------------------------------
mapfile -t FILES < <(
  find "$ROOT" -type f -name "*.html" \
  ! -name "index.html" \
  ! -name "404.html" \
  ! -name "how-to-add-recipes.html" \
  ! -name "recipe-template-new.html" \
  | sort
)

for file in "${FILES[@]}"; do
  echo "Checking: $file"

  # -------------------------------
  # Required CSS
  # -------------------------------
  grep -q 'css/slate.css' "$file" || {
    echo "  ❌ Missing slate.css"
    ((ERRORS++))
  }

  grep -q 'css/recipes.css' "$file" || {
    echo "  ❌ Missing recipes.css"
    ((ERRORS++))
  }

  grep -q 'css/print.css' "$file" || {
    echo "  ❌ Missing print.css"
    ((ERRORS++))
  }

  # -------------------------------
  # Required JS
  # -------------------------------
  grep -q 'js/sidebar.js' "$file" || {
    echo "  ❌ Missing sidebar.js"
    ((ERRORS++))
  }

  # -------------------------------
  # Required Layout Structure
  # -------------------------------
  grep -q '<main class="layout">' "$file" || {
    echo "  ❌ Missing main layout"
    ((ERRORS++))
  }

  grep -q '<aside class="sidebar card">' "$file" || {
    echo "  ❌ Missing sidebar block"
    ((ERRORS++))
  }

  grep -q 'id="sidebarContent"' "$file" || {
    echo "  ❌ Missing sidebarContent ID"
    ((ERRORS++))
  }

  # -------------------------------
  # Ensure All Recipes link correct
  # -------------------------------
  grep -q '<a href="./">All Recipes</a>' "$file" || {
    echo "  ⚠ All Recipes link not root-relative"
  }

  # -------------------------------
  # Forbidden old assets
  # -------------------------------
  grep -q 'assets/style.css' "$file" && {
    echo "  ❌ Found deprecated assets/style.css"
    ((ERRORS++))
  }

  grep -q 'assets/sidebar.js' "$file" && {
    echo "  ❌ Found deprecated assets/sidebar.js"
    ((ERRORS++))
  }

  echo ""
done

echo "========================================="
echo "Lint complete."
echo "Errors found: $ERRORS"
echo "========================================="

# Exit non-zero if errors (good for CI usage)
if [ "$ERRORS" -gt 0 ]; then
  exit 1
fi