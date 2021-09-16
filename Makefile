.DEFAULT_GOAL := help

## -- HELP --

## This help message
## Which can also be multiline
.PHONY: help
help:
	@printf "Usage\n";

	@awk '{ \
			if ($$0 ~ /^.PHONY: [a-zA-Z\-\/\_0-9]+$$/) { \
				helpCommand = substr($$0, index($$0, ":") + 2); \
				if (helpMessage) { \
					printf "\033[36m%-20s\033[0m %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^[a-zA-Z\-\/\_0-9.]+:/) { \
				helpCommand = substr($$0, 0, index($$0, ":")); \
				if (helpMessage) { \
					printf "\033[36m%-20s\033[0m %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^##/) { \
				if (helpMessage) { \
					helpMessage = helpMessage"\n                     "substr($$0, 3); \
				} else { \
					helpMessage = substr($$0, 3); \
				} \
			} else { \
				if (helpMessage) { \
					print "\n                     "helpMessage"\n" \
				} \
				helpMessage = ""; \
			} \
		}' \
		$(MAKEFILE_LIST)


## -- Docker --

## Start the stack with MySql
.PHONY: compose/run
compose/run:
	docker-compose up

## Start full stack
.PHONY: compose/full
compose/full:
	docker-compose -f docker-compose.yml -f docker-compose-traefik.yml up

## Start Keycloak in debug mode using h2
.PHONY: compose/dev
compose/dev:
	docker-compose -f docker-compose-dev.yml up &&  docker-compose rm -fsv

## Start full stack
.PHONY: compose/userapi
compose/userapi:
	docker-compose -f docker-compose-api.yml up &&  docker-compose rm -fsv

## -- Realm  --

## Create realm into keycloak
.PHONY: realm/create
realm/create:
	docker-compose exec keycloak \
	/opt/jboss/keycloak/bin/kcadm.sh create realms -s enabled=true -f /tmp/demo-realm.json --no-config --server http://localhost:8080/auth --realm master --user admin --password password

## Delete realm into keycloak
.PHONY: realm/delete
realm/delete:
	docker-compose exec keycloak \
	/opt/jboss/keycloak/bin/kcadm.sh delete realms/acme-demo --no-config --server http://localhost:8080/auth --realm master --user admin --password password

## Delete realm into keycloak
.PHONY: realm/reload
realm/reload: realm/delete realm/create

## -- Development --

## Build local project modules
.PHONY: mvn/install
mvn/install:
	(mvn clean install -DskipTests)

## Build authenticator providers only
.PHONY: mvn/build-auth
mvn/build-auth:
	(cd ./authenticator-jar && mvn clean install -DskipTests)

## Deploy authenticator providers only
.PHONY: mvn/deploy-auth
mvn/deploy-auth:
	(cd ./authenticator-ear && mvn clean wildfly:deploy -Dwildfly.username=keycloak -Dwildfly.password=keycloak)

## Build authenticator providers only
.PHONY: mvn/build-user
mvn/build-user:
	(cd ./user-provider-jar && mvn clean install -DskipTests)

## Deploy authenticator providers only
.PHONY: mvn/deploy-user
mvn/deploy-user:
	(cd ./user-provider-ear && mvn clean wildfly:deploy -Dwildfly.username=keycloak -Dwildfly.password=keycloak)

## Get a token using password
.PHONY: keycloak/login
keycloak/login:
	./test-direct-grant.sh

## Show openid info page
.PHONY: keycloak/openid-config
keycloak/openid-config:
	curl -v -k http://localhost:8080/auth/realms/acme-demo/.well-known/openid-configuration  | jq '.'

## SSH into keycloak container
.PHONY: keycloak/ssh
keycloak/ssh:
	docker-compose exec keycloak bash

## Show info about the project
.PHONY: keycloak/info
keycloak/info:
	@echo "Account url http://localhost/auth/realms/acme-demo/account/"
	@echo "Account url http://localhost/auth/realms/acme-demo/protocol/openid-connect/logout"

## -- Tools --



