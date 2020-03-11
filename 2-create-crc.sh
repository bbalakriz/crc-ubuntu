sudo apt-get update
sudo apt-get install --assume-yes qemu-kvm libvirt-daemon libvirt-daemon-system dnsmasq

sudo usermod -a -G libvirt $(whoami)
sudo usermod -a -G libvirt-qemu $(whoami)
sudo usermod -a -G libvirt-dnsmasq $(whoami)

sudo reboot

cat << EOF | sudo tee /etc/systemd/resolved.conf > /dev/null  
[Resolve]
DNS=127.0.0.2
Domains=apps-crc.testing crc.testing
EOF 

sudo sed -i 's/#listen-address=/listen-address=127.0.0.2/g' /etc/dnsmasq.conf 

cat << EOF | sudo tee /etc/default/dnsmasq > /dev/null  
DOMAIN_SUFFIX=``
ENABLED=1
CONFIG_DIR=/etc/dnsmasq.d,.dpkg-dist,.dpkg-old,.dpkg-new
IGNORE_RESOLVCONF=yes
EOF

cat << EOF | sudo tee /etc/dnsmasq.d/crc.conf > /dev/null  
address=/crc.testing/192.168.130.11
address=/apps-crc.testing/192.168.130.11
server=/#/8.8.8.8
EOF

sudo systemctl restart systemd-resolved
sudo systemctl restart dnsmasq

dig foo.apps-crc.testing | echo $(grep 192.168.130.11)
dig api.crc.testing | echo $(grep 192.168.130.11)

curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/crc/latest/crc-linux-amd64.tar.xz && tar -Jxvf crc-linux-amd64.tar.xz

crc config set skip-check-network-manager-installed true
crc config set skip-check-network-manager-config true
crc config set skip-check-network-manager-running true
crc config set skip-check-crc-dnsmasq-file true

crc setup
nohup crc start -m 20480 -p ~/.crc-pull-secret &


References: 
===========
https://github.com/code-ready/crc/issues/549#issuecomment-529379181
https://github.com/code-ready/crc/issues/549#issuecomment-573676404
