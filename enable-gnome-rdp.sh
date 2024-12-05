#!/bin/bash -x
RDP_USER="${USER}"
RDP_PASS="12345678"
export GRDCERTDIR=/var/tmp/${USER}.tmp
#sudo dnf -y install gnome-remote-desktop freerdp
#sudo -u gnome-remote-desktop winpr-makecert \
#    -silent -rdp -path ~gnome-remote-desktop rdp-tls
sudo grdctl --system rdp enable
sudo grdctl --system rdp set-credentials "${RDP_USER}" "${RDP_PASS}"
sudo grdctl --system rdp set-tls-key ${GRDCERTDIR}/grd-tls.key
sudo grdctl --system rdp set-tls-cert ${GRDCERTDIR}/grd-tls.crt
sudo systemctl --now enable gnome-remote-desktop.service
sudo firewall-cmd --permanent --add-service=rdp
sudo firewall-cmd --reload

# Client
#sudo dnf -y install gnome-connections
#gnome-connections rdp://bluefin
