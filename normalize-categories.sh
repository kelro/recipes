#!/usr/bin/env bash
# ==============================================================
# normalize-categories.sh
#
# PURPOSE:
#   Normalizes category names inside recipes.json to match
#   locked plural category standards.
#
# SAFE:
#   • Creates backup before modifying
#   • Supports dry-run mode
#
# USAGE:
#   ./normalize-categories.sh         # Apply changes
#   ./normalize-categories.sh --dry   # Preview only
#
# ==============================================================

set -euo pipefail

ROOT="/home/ron/Code/recipes"
JSON_FILE="$ROOT/data/recipes.json"
DRY_RUN=false

if [[ "${1:-}" == "--dry" ]]; then
  DRY_RUN=true
  echo "Running in DRY-RUN mode (no changes will be made)"
fi

# --------------------------------------------------------------
# Locked Category List
# --------------------------------------------------------------
declare -a VALID_CATEGORIES=(
  "Appetizers"
  "Beans"
  "Beverages"
  "Breads"
  "Desserts"
  "Main Dishes"
  "Reference"
  "Sauces"
  "Sauces & Dressings"
  "Sauces & Seasonings"
  "Side Dishes"
  "Snacks"
  "Soups & Stews"
  "Vegetables"
)

echo "========================================="
echo "Category Normalization Script"
echo "Target: $JSON_FILE"
echo "========================================="
echo ""

# --------------------------------------------------------------
# Backup
# --------------------------------------------------------------
if [ "$DRY_RUN" = false ]; then
  cp "$JSON_FILE" "$JSON_FILE.bak"
  echo "Backup created: recipes.json.bak"
fi

CHANGES=0

# --------------------------------------------------------------
# Normalize singular to plural examples
# Add rules as needed
# --------------------------------------------------------------

normalize() {
  sed -e 's/"category": "Dessert"/"category": "Desserts"/g' \
      -e 's/"category": "Main Dish"/"category": "Main Dishes"/g' \
      -e 's/"category": "Soup"/"category": "Soups & Stews"/g'
}

if [ "$DRY_RUN" = true ]; then
  normalize < "$JSON_FILE"
else
  normalize < "$JSON_FILE" > "$JSON_FILE.tmp"
  mv "$JSON_FILE.tmp" "$JSON_FILE"
  echo "Normalization complete."
fi

echo ""
echo "========================================="
echo "Done."
echo "========================================="