#!/bin/bash


rmount () {
        (\
                setsid rclone mount --rc --rc-addr=127.0.0.1:5572 vggscqq-gdrive: ~/cloud/vggscqq-gdrive/ &> /dev/null & \
                setsid rclone mount --rc --rc-addr=127.0.0.1:5573 citizenfirst-yandex: ~/cloud/citizenfirst-yandex/ &> /dev/null & \
        )
}

rumount () {
        for dir in ~/cloud/*
        do
                fusermount -u "$dir"
                #echo "$dir"
        done
}


FILE=""
DIR="/home/vgscq/cloud/vggscqq-gdrive/"
if [ -d "$DIR" ]
then
	if [ "$(ls -A $DIR)" ]; then
		echo "Unmounting"
		rumount
	else
		echo "Mounting"
		rmount
	fi
else
	echo "Directory $DIR not found."
fi
