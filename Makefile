NETWORK_NAME := mysql_network
create-network:
	@docker network inspect ${NETWORK_NAME} >/dev/null || (docker network create -d bridge --subnet 192.168.154.0/24 ${NETWORK_NAME} && echo "Created network: ${NETWORK_NAME}")

start-mysql: create-network
	docker run -d --name mysql \
	-p 3306:3306 \
	-e MYSQL_DATABASE=examples \
	-e MYSQL_ROOT_PASSWORD=root \
	--network ${NETWORK_NAME} \
	mysql:5.7.26

start-adminer:
	docker run -d --name adminer \
	-p 8080:8080 \
	--network ${NETWORK_NAME} \
	adminer:4.7.1-standalone

enter-mysql:
	docker exec -it mysql mysql -u root -p examples