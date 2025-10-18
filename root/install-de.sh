#!/usr/bin/env bash
set -e

# --- Update Arch repos ---
pacman -Syu --noconfirm

# --- KDE Plasma ---
if jq ".DE" "/options.json" | grep -q "KDE Plasma (Heavy)"; then
    pacman -S --noconfirm plasma-desktop dolphin gwenview konsole systemsettings kde-gtk-config kio-extras kwrite
    sed -i 's/applications:org.kde.discover.desktop,/applications:org.kde.konsole.desktop,/g' /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml || true
    cp /startwm-kde.sh /defaults/startwm.sh
fi

# --- XFCE4 ---
if jq ".DE" "/options.json" | grep -q "XFCE4 (Lightweight)"; then
    pacman -S --noconfirm xfce4 xfce4-goodies mousepad xfce4-terminal firefox
    rm -f /etc/xdg/autostart/xscreensaver.desktop || true
    cp /startwm-xfce.sh /defaults/startwm.sh
fi

# --- I3 ---
if jq ".DE" "/options.json" | grep -q "I3 (Very Lightweight)"; then
    pacman -S --noconfirm i3 i3status i3lock st firefox
    cp /startwm-i3.sh /defaults/startwm.sh
fi

# --- GNOME ---
if jq ".DE" "/options.json" | grep -q "GNOME 42 (Very Heavy)"; then
    pacman -S --noconfirm gnome gnome-tweaks gnome-control-center gnome-terminal firefox
    # Load dconf settings if present
    if [ -f /jammy.dconf.conf ]; then
        export $(dbus-launch)
        dconf load / < /jammy.dconf.conf || echo "⚠️ dconf load failed."
    fi
    echo "export XDG_CURRENT_DESKTOP=GNOME" >> ~/.bashrc
    echo "export XDG_CURRENT_DESKTOP=GNOME" >> /config/.bashrc
    cp /startwm-gnome.sh /defaults/startwm.sh
fi

# --- Cinnamon ---
if jq ".DE" "/options.json" | grep -q "Cinnamon"; then
    pacman -S --noconfirm cinnamon firefox
    cp /startwm-cinnamon.sh /defaults/startwm.sh
fi

# --- LXQT ---
if jq ".DE" "/options.json" | grep -q "LXQT"; then
    pacman -S --noconfirm lxqt firefox
    cp /startwm-lxqt.sh /defaults/startwm.sh
fi

# --- Final setup ---
chmod +x /defaults/startwm.sh
rm -f /startwm-*.sh
