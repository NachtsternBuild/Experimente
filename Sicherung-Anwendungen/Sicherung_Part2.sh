#!/bin/bash

# Datei mit der App-Liste
input_file="app-liste.txt"

# Suche nach der App-Liste
if [ ! -f "$input_file" ]; then
    echo "Die Datei $input_file existiert nicht."
    exit 1
fi

# Installationsbefehl je nach Paketmanager
install_command=""

# Überprüfen, welcher Paketmanager verfügbar ist
if command -v apt-get >/dev/null 2>&1; then
    install_command="sudo apt-get install -y"
elif command -v yum >/dev/null 2>&1; then
    install_command="sudo yum install -y"
elif command -v dnf >/dev/null 2>&1; then
    install_command="sudo dnf install -y"
elif command -v pacman >/dev/null 2>&1; then
    install_command="sudo pacman -S --noconfirm"
elif command -v zypper >/dev/null 2>&1; then
    install_command="sudo zypper install -y"
else
    echo "Kein unterstützter Paketmanager gefunden."
    exit 1
fi

# Lese die App-Liste ein und installiere jede App
while IFS= read -r app_name; do
    # Konvertiere den App-Namen in das Paket, das installiert werden soll
    # Dies kann je nach Distribution unterschiedlich sein.
    # Hier wird davon ausgegangen, dass der App-Name auch das Paket ist.
    # TODO:
    #      - Pakete mit nicht gleichen App-Namen herausfinden
    package_name="$app_name"
    
    echo "Installiere $package_name..."
    $install_command "$package_name"
done < "$input_file"

echo "Alle Apps wurden installiert."
