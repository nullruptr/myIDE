up:
# docker compose up --build -d
# Docker コンテナ内の時刻が Windows ホストとずれるため，対策．
# https://scrapbox.io/javememo/docker%E3%82%B3%E3%83%B3%E3%83%86%E3%83%8A%E5%86%85%E3%81%AE%E6%99%82%E5%88%BB%E3%81%8CWindows%E3%83%9B%E3%82%B9%E3%83%88%E3%81%A8%E3%81%9A%E3%82%8C%E3%82%8B
	wsl --set-default Ubuntu
	wsl -u root apt update
	wsl -u root apt-get upgrade
	wsl -u root apt install -y ntpdate
	wsl -u root ntpdate ntp.nict.jp
	docker compose build --progress=plain
	docker compose up -d

exec:
	docker exec -it nvim bash

up-simply-exec:
	docker compose build --progress=plain
	docker compose up -d

up-exec:
	make up
	make exec

down:
	docker compose down

prune:
	docker image prune -a

rm:
	docker rm $$(docker ps -q)

b-prune:
	docker builder prune

clear:
	make down
	make prune
	make b-prune