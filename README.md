## Project Setup Instructions

This guide will walk you through setting up and running the entire application stack locally using Docker Compose, Ansible, and Make.

### 1\. Prerequisites

Before you begin, ensure you have the following software installed on your machine (MacOS):

  * **Docker Desktop (or Docker Engine & Docker Compose):** This includes Docker Engine and Docker Compose.
      * [Install Docker Desktop](https://www.docker.com/products/docker-desktop/)
  * **Ansible:** Used for configuring Vault.
      * Install via brew: `brew install ansible`

### 2\. Project Structure

Your project directory is structured as follows:

```
project/
├── docker-compose.yml
├── Makefile
├── setup.yml                  # Ansible playbook
├── app/
│   └── backend/
│       └── ...                # backend application code
│   └── vault_credentials.env  # <-- This file will be created by Ansible for the VAULT_TOKEN
│   └── vault_init.env         # <-- This file will be created by Ansible for the Vault root token, role_id and secret_id
├── backend.Dockerfile         # Dockerfile for backend service
├── traefik/
│   ├── dynamic_conf.yml       # traefik config
│   └── certs/                 # self-signed tls
```

### 3\. Installation

Navigate to the root directory of your project in your terminal.

#### a. Bring Up and Configure the System

The following command will orchestrate the entire setup:

1.  Start Vault, PostgreSQL, and Traefik containers.
2.  Wait for Vault and PostgreSQL to become healthy.
3.  Run the Ansible playbook to configure Vault (enable AppRole, create policies, seed DB credentials, generate AppRole Role ID/Secret ID, TOKEN).
4.  Start the Backend application, which will then use the newly generated TOKEN.
5.  Check `backend` application exposed as `https://app.localhost` through Traefik. Note that the TLS certificates are self-signed.

```bash
make up
```

#### b. Bring Down the System

To stop and remove all running containers, networks, and volumes associated with your project:

```bash
make down
```

#### c. Check the logs

To check the logs of the running containers:

```bash
make logs
```

#### c. Check the logs

To check the logs of the running containers:

```bash
make test
```

### 4\. Verification

After running `make up` successfully:

2.  **Test Backend Application:**
    If your `backend` application exposes an endpoint (e.g., `https://app.localhost` through Traefik), try accessing it in your browser or via `curl` to confirm it's running and can connect to Vault/DB.
    *(You might need to add `127.0.0.1 app.localhost` to your `/etc/hosts` file.

3.  **Check Backend Logs:**

    ```bash
    docker compose logs backend
    ```

    Look for messages indicating successful connection to Vault and the database.
