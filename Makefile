NETWORK_NAME := mysql_network
create-network:
	@docker network inspect ${NETWORK_NAME} >/dev/null || (docker network create -d bridge --subnet 192.168.154.0/24 ${NETWORK_NAME} && echo "Created network: ${NETWORK_NAME}")

start-mysql: create-network
	docker run -d --name mysql \
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

## Database is taken from here https://github.com/datacharmer/test_db
install-employees-db:
	wget https://github.com/datacharmer/test_db/archive/master.zip
	unzip master.zip && rm master.zip
	docker cp test_db-master/. mysql:/
	docker exec -it mysql sh -c "mysql -u root -p examples < /employees.sql"

restart-adminer:
	docker restart adminer