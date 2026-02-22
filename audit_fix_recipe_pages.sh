#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Recipe HTML Style/Link Auditor + Auto-Fixer
# Repo root: /home/ron/Code/recipes
#
# Fixes:
# - Bad/old asset refs (../assets/style.css, ../assets/sidebar.js)
# - Missing/incorrect CSS links (slate.css, recipes.css, print.css)
# - Missing/incorrect sidebar.js include
# - Bad relative paths due to nested directories
#
# Safety:
# - Makes a .bak backup before modifying any file
# - Logs all actions
# ============================================================

ROOT="/home/ron/Code/recipes"
EXPORTS="/home/ron/exports"
TS="$(date +"%Y%m%d_%H%M%S")"
LOG="$EXPORTS/recipe_style_audit_${TS}.log"

mkdir -p "$EXPORTS"

echo "==========================================" | tee "$LOG"
echo "RECIPE STYLE AUDIT/FIX - $TS" | tee -a "$LOG"
echo "ROOT: $ROOT" | tee -a "$LOG"
echo "LOG : $LOG" | tee -a "$LOG"
echo "==========================================" | tee -a "$LOG"

# Find the proper relative prefix from a file's directory to the repo root
# by walking up until we find css/slate.css and js/sidebar.js.
find_prefix() {
  local file_dir="$1"
  local cur="$file_dir"
  local prefix=""

  while true; do
    if [[ -f "$cur/css/slate.css" && -f "$cur/js/sidebar.js" ]]; then
      # If file_dir == cur then prefix is "./"
      if [[ "$prefix" == "" ]]; then
        echo "./"
      else
        echo "$prefix"
      fi
      return 0
    fi

    # Stop if we hit filesystem root or leave $ROOT
    if [[ "$cur" == "/" ]]; then break; fi
    if [[ "${cur}/" != "${ROOT}/"* && "$cur" != "$ROOT" ]]; then break; fi

    cur="$(dirname "$cur")"
    prefix="../${prefix}"
  done

  # Fallback if we didn't find a root (shouldn't happen if repo layout is consistent)
  echo "../"
  return 0
}

# Normalize head CSS links and body sidebar script.
# Uses perl for robust multi-line edits.
fix_file() {
  local f="$1"
  local d
  d="$(dirname "$f")"
  local prefix
  prefix="$(find_prefix "$d")"

  # Determine desired paths
  local slate="${prefix}css/slate.css"
  local recipes="${prefix}css/recipes.css"
  local print="${prefix}css/print.css"
  local sidebar="${prefix}js/sidebar.js"

  # Quick checks
  local had_old_assets=0
  grep -qE 'assets/style\.css|assets/sidebar\.js' "$f" && had_old_assets=1

  # If no <head> or </body>, skip (but log)
  if ! grep -qi '<head' "$f" || ! grep -qi '</body>' "$f"; then
    echo "SKIP (missing <head> or </body>): $f" | tee -a "$LOG"
    return 0
  fi

  # Backup
  cp -a "$f" "$f.bak"

  # 1) Remove old assets refs
  perl -0777 -i -pe '
    s/^\s*<link[^>]+assets\/style\.css[^>]*>\s*\n//gmi;
    s/^\s*<script[^>]+assets\/sidebar\.js[^>]*>\s*<\/script>\s*\n//gmi;
    s/^\s*<script[^>]+assets\/sidebar\.js[^>]*>\s*\n//gmi;
  ' "$f"

  # 2) Remove any existing slate/recipes/print CSS links (regardless of path),
  #    then insert the correct three right before </head>.
  perl -0777 -i -pe '
    s/^\s*<link[^>]+href="[^"]*css\/slate\.css"[^>]*>\s*\n//gmi;
    s/^\s*<link[^>]+href="[^"]*css\/recipes\.css"[^>]*>\s*\n//gmi;
    s/^\s*<link[^>]+href="[^"]*css\/print\.css"[^>]*>\s*\n//gmi;
  ' "$f"

  perl -0777 -i -pe '
    s#</head>#  <link rel="stylesheet" href="__SLATE__" />\n  <link rel="stylesheet" href="__RECIPES__" />\n  <link rel="stylesheet" href="__PRINT__" />\n</head>#i
  ' "$f"

  # Fill placeholders
  perl -0777 -i -pe '
    s/__SLATE__/ENV{SLATE}/g;
    s/__RECIPES__/ENV{RECIPES}/g;
    s/__PRINT__/ENV{PRINT}/g;
  ' SLATE="$slate" RECIPES="$recipes" PRINT="$print" "$f"

  # 3) Ensure exactly one sidebar.js include right before </body>
  # Remove all existing sidebar.js includes (any path), then insert correct one.
  perl -0777 -i -pe '
    s/^\s*<script[^>]+src="[^"]*js\/sidebar\.js"[^>]*>\s*<\/script>\s*\n//gmi;
    s/^\s*<script[^>]+src="[^"]*js\/sidebar\.js"[^>]*>\s*\n//gmi;
  ' "$f"

  perl -0777 -i -pe '
    s#</body>#<script src="__SIDEBAR__"></script>\n</body>#i
  ' "$f"

  perl -0777 -i -pe 's/__SIDEBAR__/ENV{SIDEBAR}/g;' SIDEBAR="$sidebar" "$f"

  # 4) Decide if anything actually changed vs backup
  if cmp -s "$f" "$f.bak"; then
    rm -f "$f.bak"
    echo "OK (no change): $f" | tee -a "$LOG"
  else
    echo "FIXED: $f" | tee -a "$LOG"
    echo "  prefix: $prefix" | tee -a "$LOG"
    if [[ "$had_old_assets" -eq 1 ]]; then
      echo "  removed: old ../assets refs" | tee -a "$LOG"
    fi
  fi
}

export -f find_prefix
export -f fix_file
export ROOT EXPORTS LOG

# Scan all HTML files under repo root
# (If you want to exclude certain dirs like node_modules, add -path exclusions.)
mapfile -t FILES < <(find "$ROOT" -type f -name "*.html" | sort)

echo "Files found: ${#FILES[@]}" | tee -a "$LOG"

for f in "${FILES[@]}"; do
  fix_file "$f"
done

echo "" | tee -a "$LOG"
echo "DONE. Log: $LOG" | tee -a "$LOG"
echo "Backups created only for modified files: *.bak" | tee -a "$LOG"