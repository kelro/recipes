#!/usr/bin/env bash

set -e

echo "🔧 Normalizing recipe categories..."

# ---- CATEGORY MAP (singular → plural) ----
declare -A MAP=(
  ["Main Dish"]="Main Dishes"
  ["Dessert"]="Desserts"
  ["Side Dish"]="Side Dishes"
  ["Sauce"]="Sauces"
  ["Snack"]="Snacks"
  ["Bread"]="Breads"
  ["Beverage"]="Beverages"
)

# ---- Normalize recipes.json ----
if [ -f data/recipes.json ]; then
  echo "• Updating data/recipes.json"
  for FROM in "${!MAP[@]}"; do
    TO="${MAP[$FROM]}"
    sed -i "s/\"category\": \"${FROM}\"/\"category\": \"${TO}\"/g" data/recipes.json
  done
fi

# ---- Normalize recipe HTML files ----
echo "• Updating recipe HTML files"
for file in recipes/*.html; do
  for FROM in "${!MAP[@]}"; do
    TO="${MAP[$FROM]}"
    sed -i "s/>${FROM}</>${TO}</g" "$file"
  done
done

echo "✅ Category normalization complete."
