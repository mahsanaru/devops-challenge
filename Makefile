up:
	@echo "Adding 127.0.0.1 app.localhost to /etc/hosts if not present..."
	@if ! grep -q "127.0.0.1 app.localhost" /etc/hosts; then \
		echo "127.0.0.1 app.localhost" | sudo tee -a /etc/hosts > /dev/null; \
		echo "Entry added."; \
	else \
		echo "Entry already exists."; \
	fi

	@echo "--- CREATE vault env file ---"
	touch app/vault_credentials.env app/vault_init.env

	@echo "--- CREATE DB Credentials ---"
	@echo "POSTGRES_USER=backend_user" > .env
	@echo "POSTGRES_PASSWORD=$(shell openssl rand -hex 12)" >> .env
	@echo "POSTGRES_DB=devops_challenge" >> .env

	@echo "--- Starting Vault, DB, Traefik ---"
	docker compose up -d vault-server db traefik
	@echo "--- Waiting for Vault to start (10 seconds) ---"
	sleep 5

	@echo "--- Running Ansible playbook to configure Vault ---"
	ansible-playbook setup.yml

	@echo "--- Ansible playbook finished. Starting backend service ---"
	docker compose up -d backend

	@echo "--- All services started and configured ---"
	@echo "You can check status with: docker compose ps"

down:
	@echo "--- removing all services and volumes ---"
	docker compose down --volumes

logs:
	@echo "--- Showing container logs ---"
	docker-compose logs -f
	
test:
	@echo "Checking health of https://app.localhost/api/health..."
	@status=$$(curl -s -o /dev/null -w "%{http_code}" -k https://app.localhost/api/health); \
	if [ "$$status" -eq 200 ]; then \
		echo "healthy"; \
	else \
		echo "unhealthy (status $$status)"; \
		exit 1; \
	fi