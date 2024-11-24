#!/bin/bash

ihatedocker () {
	docker stop $(docker ps -a -q) > /dev/null 2>&1 
	docker rm $(docker ps -a -q) > /dev/null 2>&1
	docker rmi $(docker image ls -a -q) > /dev/null 2>&1
	docker volume rm $(docker volume ls -q) > /dev/null 2>&1
	docker system prune -a -f > /dev/null 2>&1
}

ihatedocker
sleep 0.5
ihatedocker
sleep 0.5
sudo systemctl stop docker
