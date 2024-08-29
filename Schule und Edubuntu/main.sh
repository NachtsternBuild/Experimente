#!/bin/bash

# Fehlerbehandlung aktivieren
set -e

### 1. PXE-Server einrichten und konfigurieren ###
setup_pxe_server() {
  echo "Aktualisiere das System und installiere benötigte Pakete..."
  apt update && apt upgrade -y
  apt install -y isc-dhcp-server tftpd-hpa apache2 syslinux pxelinux wget

  echo "Konfiguriere DHCP-Server..."
  cat <<EOF > /etc/dhcp/dhcpd.conf
default-lease-time 600;
max-lease-time 7200;
authoritative;

subnet 192.168.1.0 netmask 255.255.255.0 {
  range 192.168.1.100 192.168.1.200;
  option routers 192.168.1.1;
  option broadcast-address 192.168.1.255;
  next-server 192.168.1.10; # IP des PXE Servers
  filename "pxelinux.0";
}
EOF

  systemctl restart isc-dhcp-server

  echo "Konfiguriere TFTP-Server..."
  mkdir -p /srv/tftpboot
  cp /usr/lib/PXELINUX/pxelinux.0 /srv/tftpboot/
  cp /usr/lib/syslinux/modules/bios/ldlinux.c32 /srv/tftpboot/

  mkdir -p /srv/tftpboot/pxelinux.cfg
  cat <<EOF > /srv/tftpboot/pxelinux.cfg/default
DEFAULT install
LABEL install
  MENU LABEL Install Edubuntu
  KERNEL ubuntu-installer/amd64/linux
  APPEND vga=normal initrd=ubuntu-installer/amd64/initrd.gz netcfg/get_hostname=unassigned-hostname netcfg/get_domain=unassigned-domain priority=critical auto=true
EOF

  echo "Lade Edubuntu-Installationsdateien herunter..."
  mkdir -p /var/www/html/ubuntu
  cd /var/www/html/ubuntu
  wget http://archive.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/current/images/netboot/netboot.tar.gz
  tar -xzf netboot.tar.gz -C /srv/tftpboot --strip-components=1

  echo "Konfiguriere Apache-Webserver..."
  systemctl restart apache2

  echo "PXE-Server ist bereit für die Installation von Edubuntu!"
}

### 2. Benutzerrechte und Gruppen einrichten ###
setup_user_permissions() {
  echo "Erstelle Gruppen für Lehrer und Schüler..."
  groupadd teachers || echo "Gruppe 'teachers' existiert bereits"
  groupadd students || echo "Gruppe 'students' existiert bereits"

  echo "Füge Beispielbenutzer zu den jeweiligen Gruppen hinzu..."
  usermod -aG teachers lehrer1 || echo "Benutzer 'lehrer1' existiert nicht"
  usermod -aG students schueler1 || echo "Benutzer 'schueler1' existiert nicht"

  echo "Konfiguriere Sudo-Rechte für die Gruppe 'teachers'..."
  echo "%teachers ALL=(ALL) ALL" > /etc/sudoers.d/teachers

  echo "Entferne Sudo-Rechte für die Gruppe 'students'..."
  echo "%students ALL=(ALL) NOPASSWD: /bin/false" > /etc/sudoers.d/students

  chmod 0440 /etc/sudoers.d/students
  chmod 0440 /etc/sudoers.d/teachers

  echo "Setze korrekte Rechte für Home-Verzeichnisse..."
  chown root:root /home
  chmod 755 /home

  for USER in $(getent passwd | awk -F: '/\/home\/(schueler|lehrer)/ {print $1}')
  do
      if id -nG "$USER" | grep -qw "teachers"; then
          chown "$USER:teachers" "/home/$USER"
          chmod 700 "/home/$USER"
      elif id -nG "$USER" | grep -qw "students"; then
          chown "$USER:students" "/home/$USER"
          chmod 700 "/home/$USER"
      fi
  done

  echo "Benutzerrechte und Gruppen erfolgreich konfiguriert!"
}

### 3. Angepasstes SystemRescueCD-ISO erstellen ###
setup_custom_systemrescuecd() {
  echo "SystemRescueCD ISO anpassen..."

  # Laden und Mounten der SystemRescueCD ISO
  SYSTEMRESCUE_URL="https://download.system-rescue.org/systemrescue-10.00-amd64.iso"
  wget -O /tmp/systemrescue.iso $SYSTEMRESCUE_URL

  mkdir /mnt/systemrescuecd
  mount -o loop /tmp/systemrescue.iso /mnt/systemrescuecd
  mkdir /custom-rescuecd
  cp -r /mnt/systemrescuecd/* /custom-rescuecd/
  umount /mnt/systemrescuecd

  # Automatisches Installationsskript erstellen
  mkdir -p /custom-rescuecd/autorun
  cat <<EOF > /custom-rescuecd/autorun/install-edubuntu.sh
#!/bin/bash
set -e
DISK="/dev/sda"
echo "Partitioniere und formatiere die Festplatte..."
parted \$DISK mklabel gpt
parted -a optimal \$DISK mkpart primary ext4 0% 100%
mkfs.ext4 \${DISK}1
mount_point="/mnt/edubuntu"
mkdir -p \$mount_point
mount \${DISK}1 \$mount_point
ISO_URL="http://cdimage.ubuntu.com/edubuntu/releases/20.04/release/edubuntu-20.04-desktop-amd64.iso"
ISO_FILE="/tmp/edubuntu.iso"
wget -O \$ISO_FILE \$ISO_URL
mount -o loop \$ISO_FILE /mnt
rsync -a /mnt/ \$mount_point/
umount /mnt
mount --bind /dev \$mount_point/dev
mount --bind /proc \$mount_point/proc
mount --bind /sys \$mount_point/sys
chroot \$mount_point grub-install \$DISK
chroot \$mount_point update-grub
umount \$mount_point/dev
umount \$mount_point/proc
umount \$mount_point/sys
umount \$mount_point
rm \$ISO_FILE
echo "Installation abgeschlossen. Starte neu..."
reboot
EOF

  chmod +x /custom-rescuecd/autorun/install-edubuntu.sh

  # Autorun Datei für SystemRescueCD
  echo "Erstelle autorun-Datei..."
  echo "/autorun/install-edubuntu.sh" > /custom-rescuecd/sysresccd/autorun

  # Neue ISO erstellen
  echo "Erstelle neue SystemRescueCD ISO..."
  mkisofs -o /tmp/custom-systemrescuecd.iso -b isolinux/isolinux.bin -c isolinux/boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table -J -R -V "CUSTOMRESCUE" /custom-rescuecd

  echo "Angepasste SystemRescueCD ISO erstellt: /tmp/custom-systemrescuecd.iso"
}

### 4. Anpassung des Anmeldebildschirms und Einschränkungen für Anwendungen ###
configure_desktop_environment() {
  echo "Konfiguriere den Anmeldebildschirm so, dass keine Benutzer angezeigt werden..."

  # Konfiguration für GDM3 (GNOME Display Manager)
  mkdir -p /etc/gdm3/
  cat <<EOF > /etc/gdm3/greeter.dconf-defaults
[org/gnome/login-screen]
# Verhindert die Anzeige von Benutzern am Login-Bildschirm
disable-user-list=true
EOF

  # Anwenden der Konfiguration
  echo "Änderungen anwenden..."
  dconf update
  update-desktop-database

  echo "Desktop-Umgebung erfolgreich konfiguriert!"
}

# Hauptprogramm
setup_pxe_server
setup_user_permissions
setup_custom_systemrescuecd
configure_desktop_environment

echo "Alle Schritte erfolgreich abgeschlossen!"

