#!/bin/bash

echo "Nettoyage de la VM pour la creation d'un template"
echo "- Suppression des fichiers temporaires"
echo "- Suppression des cles SSH"
echo "- Suppression de la configuration reseau"
printf "\n"

echo "Voulez-vous continuer ?"
select yn in "Oui" "Non"; do
    case $yn in
        Oui ) break;;
        Non ) exit;;
    esac
done

# Nettoyage de apt
apt-get autoremove
apt-get autoclean
apt-get clean

# Suppression des fichiers temporaires
rm -rf /tmp/*
rm -f /var/log/wtmp /var/log/btmp

# Nettoyage de /root
rm -rf /root/.vim*
rm -rf /root/*.swp
rm -rf /root/.config

# Suppression de la configuration reseau
cp /etc/network/interfaces.sample /etc/network/interfaces
cp /etc/hosts.sample /etc/hosts

# Suppression des cles SSH
rm -f /etc/ssh/*key*

# Suppression de l'historique du shell
rm /root/.bash_history

echo 'Nettoyage termine. `history -c && shutdown -h now` pour eteindre la machine.'
