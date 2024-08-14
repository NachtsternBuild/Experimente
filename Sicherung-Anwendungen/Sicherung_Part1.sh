#!/bin/bash

# Ziel-Datei für die App-Liste
output_file="app-liste.txt"

# Alle .desktop-Dateien im System finden und den Namen der Anwendung extrahieren
# Durchsuchen nach Desktop-Dateien
find /usr/share/applications ~/.local/share/applications /usr/local/share/applications -name "*.desktop" | while read -r desktop_file; do
    # Extrahiere den Namen der Anwendung aus der Desktop-Datei
    app_name=$(grep -i '^Name=' "$desktop_file" | head -n 1 | cut -d '=' -f 2)
    if [ -n "$app_name" ]; then
        echo "$app_name" >> "$output_file"
    fi
done

# Duplikate entfernen, falls welche vorhanden sind
sort -u "$output_file" -o "$output_file"

echo "App-Liste wurde in $output_file gespeichert."
