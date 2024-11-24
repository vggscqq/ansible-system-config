#!/bin/bash

ping -q -c1 1.1.1.1 &>/dev/null

if [ $? -eq 0 ]; then
	echo "Online"
	yes | yay -Syu
	yes | yay --devel -Suy

	#rm /var/lib/pacman/db.lck
	yes | sudo pacman -Rns $(pacman -Qtdq)
	sudo rm -rf /home/*/.cache/*
	sudo rm -rf /var/cache/*
	#touch /var/lib/pacman/db.lck
	sudo journalctl --vacuum-time=1weeks
else
	echo "Offline"
	exit
fi

if [ "$1" = "reboot" ]; then
    sudo systemctl reboot
else
    echo "Done"
fi

if [ "$1" = "shutdown" ]; then
    sudo shutdown now
else
    echo "Done"
fi


#yes | sudo yay -Syu
#yes | yay --devel -Suy

#rm /var/lib/pacman/db.lck
#yes | sudo pacman -Rns $(pacman -Qtdq)
#sudo rm -rf /home/*/.cache/*
#sudo rm -rf /var/cache/*
#touch /var/lib/pacman/db.lck
#sudo journalctl --vacuum-time=1weeks

#sudo systemctl reboot
