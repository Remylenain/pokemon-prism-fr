#!/bin/bash

# Fichiers à vérifier
files=(
  "data/pokemon_names.asm"
  "items/item_names.asm"
)

echo "🔍 Vérification des noms mal formatés (doivent être Majuscule + minuscules)..."
echo

error_found=false

for file in "${files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "⚠️  Fichier introuvable : $file"
    continue
  fi

  while IFS= read -r line || [[ -n "$line" ]]; do
    # Supprime les commentaires
    clean_line=$(echo "$line" | cut -d';' -f1 | xargs)

    # Cherche une chaîne entre guillemets
    if [[ "$clean_line" =~ \"([^\"]+)\" ]]; then
      name="${BASH_REMATCH[1]}"
      if [[ ! "$name" =~ ^[A-Z][a-zéèêàùîçäëïôöü\-]*$ ]]; then
        echo "❌ Mauvais format : \"$name\" dans $file"
        error_found=true
      fi
    fi
  done < "$file"
done

if ! $error_found; then
  echo "✅ Tous les noms sont bien formatés !"
fi