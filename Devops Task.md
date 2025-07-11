# 🧪 Senior DevOps Take-Home Challenge (1-Day)

## 🎯 Objective

Build a secure, containerized mini platform consisting of a PostgreSQL service and a simple TypeScript backend API, deployed locally using Docker Compose, with secrets managed via HashiCorp Vault. Demonstrate infrastructure automation and security best practices in a time-efficient manner.

## 🧩 Scenario

You're tasked with deploying a simple service that exposes an API to read/write user data to a PostgreSQL database. This service should be securely deployed using containerization best practices. Database credentials must be fetched from Vault at runtime.

## 📦 Deliverables

Submit as a GitHub repo with clear folder structure and README covering:

- Setup instructions (should work with `make up` or similar)
- Architecture diagram
- Design decisions
- Security considerations

## 🧱 Tech Stack

- **Docker & Docker Compose**
- **PostgreSQL**
- **HashiCorp Vault**
- **TypeScript (backend only)**
- **Traefik (reverse proxy & load balancer)**

## 🔧 Assignment Tasks

### 1. Infrastructure Setup (Docker Compose)

- Deploy PostgreSQL database via Docker Compose
- Deploy Vault server in development mode via Docker Compose
- Configure Traefik as reverse proxy and load balancer for the backend service via Docker Compose
- All services should be networked properly and start with a single command

### 2. Vault Configuration

- Store PostgreSQL credentials in Vault KV store
- Configure Vault to allow the backend service to retrieve secrets using AppRole authentication
- Provide an Ansible playbook that initializes Vault with necessary policies and secrets

### 3. TypeScript Backend Service (Pre-built & Fully Functional)

A complete TypeScript backend is provided in the `/backend` folder with these endpoints:

- `POST /api/users` - Create a user (accepts username, email)
- `GET /api/users` - List all users from PostgreSQL
- `GET /api/health` - Health check endpoint (includes database connectivity check)

**The backend is already configured to:**

- ✅ Connect to PostgreSQL using credentials from Vault
- ✅ Handle database initialization (creates tables automatically)
- ✅ Include proper error handling and logging
- ✅ Fallback to environment variables if Vault is unavailable

**Your DevOps tasks for the backend:**

- Create a Dockerfile for the backend service
- Configure Docker Compose to run the backend with proper networking
- Set up environment variables for database and Vault connection
- Ensure Traefik can route to the backend service (port 8443 -> backend)
- Verify the application works end-to-end with your infrastructure

**Note:** The backend code is complete and functional - you only need to containerize it and integrate it with your infrastructure. No application development is required.

### 4. Automation & Scripts

Create automation with Ansible:

- `setup.yml` - Ansible playbook to initialize Vault, create policies, and seed initial data
- `Makefile` or `docker-compose.yml` with simple commands:
  - `make up` - Start all services
  - `make down` - Stop all services
  - `make logs` - View service logs
  - `make test` - Run basic API tests

### 5. Security Implementation

- Backend retrieves DB credentials from Vault at startup (no hardcoded secrets)
- Vault AppRole authentication for service-to-service communication
- Proper Docker networking (services not exposed unnecessarily)
- Basic input validation in API endpoints

## 🎁 Bonus Tasks (Optional - if time permits)

- Add basic API tests using Jest or similar (testing infrastructure, not backend code)
- Implement Docker health checks for all services
- Create a simple infrastructure status dashboard
