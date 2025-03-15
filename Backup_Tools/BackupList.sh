#!/bin/bash

# Dateiname für die Pakete-Liste
output_file="manual_packages.txt"
second_file="manual_package.txt"

# Alle manuell installierten Pakete abrufen
# Pakete, die nicht automatisch installiert wurden
echo "Lese manuell installierte Pakete aus..."
apt-mark showmanual > "$output_file"

# Prüfen, ob die Liste erfolgreich erstellt wurde
if [[ -s $output_file ]]; then
    echo "Liste der installierten Pakete wurde in '$output_file' gespeichert."
    
    # Installationsbefehl erstellen
    echo "Erstelle Wiederherstellungs-Kommando..."
    restore_command="sudo apt install $(tr '\n' ' ' < $second_file)"
    echo "$restore_command" > restore-command.sh
    
    chmod a+x restore-command.sh
    echo "Wiederherstellungs-Kommando wurde in 'restore-command.sh' gespeichert."
    echo "Zum Wiederherstellen ausführen: ./restore-command.sh"
else
    echo "Keine installierten Pakete gefunden oder Fehler beim Erstellen der Liste."
fi
