up:
	@echo "Adding 127.0.0.1 app.localhost to /etc/hosts if not present..."
	@if ! grep -q "127.0.0.1 app.localhost" /etc/hosts; then \
		echo "127.0.0.1 app.localhost" | sudo tee -a /etc/hosts > /dev/null; \
		echo "Entry added."; \
	else \
		echo "Entry already exists."; \
	fi
	
	@echo "--- CREATE DB Credentials ---"
	@echo "POSTGRES_USER=backend_user" > .env
	@echo "POSTGRES_PASSWORD=$(shell openssl rand -hex 12)" >> .env
	@echo "POSTGRES_DB=devops_challenge" >> .env

	@echo "--- Starting Vault, DB, Traefik ---"
	docker compose up -d vault-server db traefik

	@echo "--- Running Ansible playbook to configure Vault ---"
	@echo "Enter PostgreSQL username and password."
	ansible-playbook setup.yml

	@echo "--- Ansible playbook finished. Starting backend service ---"
	docker compose up -d backend

	@echo "--- All services started and configured ---"
	@echo "You can check status with: docker compose ps"

down:
	docker-compose down

logs:
	docker-compose logs -f

setup:
	ansible-playbook setup.yml
	
# test: