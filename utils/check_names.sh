#!/bin/bash

# Fichiers à vérifier
files=(
  "data/pokemon_names.asm"
  "items/item_names.asm"
)

# Longueur maximale d’un nom (modifiable si besoin)
MAX_LENGTH=10

echo "🔍 Vérification des noms (format + longueur max ${MAX_LENGTH})..."
echo

error_found=false

for file in "${files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "⚠️  Fichier introuvable : $file"
    continue
  fi

  linenum=0
  while IFS= read -r line || [[ -n "$line" ]]; do
    ((linenum++))
    clean_line=$(echo "$line" | cut -d';' -f1 | xargs)

    if [[ "$clean_line" =~ \"([^\"]+)\" ]]; then
      name="${BASH_REMATCH[1]}"
      if [[ ! "$name" =~ ^[A-Z][a-zéèêàùîçäëïôöü\-]*$ ]]; then
        echo "❌ Format invalide : \"$name\" dans $file (ligne $linenum)"
        error_found=true
      fi
      if [[ ${#name} -gt $MAX_LENGTH ]]; then
        echo "⚠️  Trop long : \"$name\" (${#name} caractères) dans $file (ligne $linenum)"
        error_found=true
      fi
    fi
  done < "$file"
done

if ! $error_found; then
  echo "✅ Tous les noms sont bien formatés et dans les limites de longueur !"
fi