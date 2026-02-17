#!/bin/bash

echo "🔍 Linting recipe HTML files..."
echo ""

FAIL=0

for file in $(find . -name "*.html"); do

  # Skip index.html and non-recipe docs if desired
  if [[ "$file" == *"index.html"* ]]; then
    continue
  fi

  # 1. Block citation artifacts
  if grep -q "contentReference" "$file"; then
    echo "❌ $file: contains contentReference artifact"
    FAIL=1
  fi

  # 2. Require sidebar
  if ! grep -q 'class="sidebar' "$file"; then
    echo "❌ $file: missing sidebar markup"
    FAIL=1
  fi

  # 3. Require Ingredients section
  if ! grep -q "Ingredients</div>" "$file"; then
    echo "❌ $file: missing Ingredients section"
    FAIL=1
  fi

  # 4. Require Procedure section
  if ! grep -q "Procedure</div>" "$file"; then
    echo "❌ $file: missing Procedure section"
    FAIL=1
  fi

  # 5. Require Author in footer
  if ! grep -q "Author:" "$file"; then
    echo "❌ $file: missing Author in footer"
    FAIL=1
  fi

  # 6. Require Source in footer
  if ! grep -q "Source:" "$file"; then
    echo "❌ $file: missing Source in footer"
    FAIL=1
  fi

  # 7. Require print.css
  if ! grep -q "print.css" "$file"; then
    echo "❌ $file: missing print.css"
    FAIL=1
  fi

done

echo ""

if [ $FAIL -eq 0 ]; then
  echo "✅ Lint passed: all recipe files look good."
else
  echo "⚠️  Lint failed: fix the issues above."
fi
