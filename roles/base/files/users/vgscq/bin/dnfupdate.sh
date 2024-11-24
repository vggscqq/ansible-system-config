#!/bin/bash

set -e

timeout 0.2 ping -c 1 1.1.1.1 &> /dev/null && echo -e  "$g OK" || echo -e  "$r Fail"

sudo journalctl --vacuum-time=2d # clean systemd journal
sudo dnf -y clean all # clean dnf cache
sudo dnf -y autoremove # remove unused
sudo pkcon refresh force -c -1 # packagekit cache


sudo dnf -y update
sudo dnf -y upgrade

if [ "$1" == "reboot" ]; then
	sudo systemctl reboot
fi

if [ "$1" == "shutdown" ]; then
        sudo shutdown now
fi

