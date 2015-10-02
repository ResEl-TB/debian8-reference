echo "Initialisation de la VM"
echo "Les modifications sont effectues une fois toute les questions repondues"
echo "Ne pas oublier de creer la fiche dans le LDAP"

### Entrees utilisateur

printf "\nNom de la machine (sans le FQDN, 'debian' par ex.): "
read hostname

printf "Adresse IP dans le VLAN 997 (172.22.{2,3}.XXX): "
read ip_adm

printf "\nVotre nom d'utilisateur: "
read username

read -s -p "Mot de passe pour $username: " user_pwd

printf "\n"
read -s -p "Nouveau mot de passe root: " root_pwd

printf "\n\n"
echo "Appliquer les modifications ?"
select yn in "Oui" "Non"; do
    case $yn in
        Oui ) break;;
        Non ) exit;;
    esac
done

### Modifications de la configuration

echo "root:$root_pwd" | chpasswd

echo "$hostname" > /etc/hostname
echo "$ip_adm  $hostname.adm.maisel.enst-bretagne.fr  $hostname" >> /etc/hosts

useradd -G sshusers $username
echo "$username:$user_pwd" | chpasswd

sed -i "/^#iface eth0/s/^#//"     /etc/network/interfaces
sed -i "/^#.*172.*/s/^#//"        /etc/network/interfaces
sed -i "/^#.*255.*/s/^#//"        /etc/network/interfaces
sed -i "s/172.22.X.XXX/$ip_adm/g" /etc/network/interfaces

dpkg-reconfigure openssh-server
service networking restart
