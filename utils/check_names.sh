#!/bin/bash

# Fichiers à vérifier
files=(
  "data/pokemon_names.asm"
  "items/item_names.asm"
)

# Longueur exacte attendue pour un nom avec padding
MAX_LENGTH=10

echo "🔍 Vérification des noms (ASCII + format + @ + longueur ${MAX_LENGTH})..."
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

      # Vérifie si le nom contient des caractères non-ASCII (ex: é, è, ê, É, etc.)
      if echo "$name" | grep -qP '[^\x00-\x7F]'; then
        echo "❌ Caractère non-ASCII détecté : \"$name\" dans $file (ligne $linenum)"
        error_found=true
      fi

      # Vérifie que le nom fait exactement 10 caractères
      if [[ ${#name} -ne $MAX_LENGTH ]]; then
        echo "⚠️  Nom de longueur incorrecte : \"$name\" (${#name} caractères) dans $file (ligne $linenum)"
        error_found=true
      fi

      # Vérifie le format général (Majuscule + minuscules/trait-d’union + @ optionnel)
      if [[ ! "$name" =~ ^[A-Z][a-z\-]*@*$ ]]; then
        echo "❌ Format invalide : \"$name\" dans $file (ligne $linenum)"
        error_found=true
      fi
    fi
  done < "$file"
done

if ! $error_found; then
  echo "✅ Tous les noms sont valides, ASCII, et bien formatés avec @ jusqu’à 10 caractères !"
fi
