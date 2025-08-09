# Farmo Development Environment

🌾 Automated development environment setup for the Farmo agricultural platform using Ansible.

## What This Does

This Ansible project automatically sets up a complete development environment with:

- **Docker & Docker Compose** - Container management
- **PostgreSQL** - Database server
- **Redis** - Caching and session storage
- **Keycloak** - Authentication and identity management
- **Nginx** - Web server and reverse proxy
- **Node.js 20** - JavaScript runtime
- **Development Tools** - VS Code, database clients, etc.

## Quick Start

### Prerequisites

- Ubuntu/Debian Linux system
- Python 3 and pip installed
- Sudo access

### Installation

1. **Install Ansible**
   ```bash
   sudo apt update
   sudo apt install python3-pip
   pip3 install ansible
   ```

2. **Clone and Setup**
   ```bash
   git clone <repository-url>
   cd farmo-ansible
   ```

3. **Run Setup**
   ```bash
   # Full development environment
   ansible-playbook playbooks/setup-development.yml

   # Deploy services (PostgreSQL, Redis, Keycloak)
   ansible-playbook playbooks/deploy-services.yml

   # Deploy web services with Nginx
   ansible-playbook playbooks/deploy-web-services.yml
   ```

4. **Test Installation**
   ```bash
   ./test_env.sh
   ```

## Usage

### After Installation

- **Main Website**: http://localhost
- **Health Check**: http://localhost/health
- **Keycloak Admin**: http://localhost:8080/auth/admin
- **Database**: localhost:5432 (user: `farmo_user`, password: `devpassword`)
- **Redis**: localhost:6379

### Development Workflow

```bash
# Check running containers
docker ps

# Test database connection
psql -h localhost -U farmo_user -d farmo_dev

# Test Redis
redis-cli ping

# View logs
docker logs farmo-postgres
docker logs farmo-redis
docker logs farmo-keycloak
```

## Project Structure

```
├── playbooks/           # Ansible playbooks
│   ├── setup-development.yml    # Full dev environment
│   ├── deploy-services.yml      # Backend services
│   └── deploy-web-services.yml  # Web services
├── roles/              # Ansible roles
│   ├── common/         # Basic system setup
│   ├── docker/         # Docker installation
│   ├── postgresql/     # Database setup
│   ├── redis/          # Cache setup
│   ├── keycloak/       # Authentication setup
│   ├── nginx/          # Web server setup
│   └── nodejs/         # Node.js setup
├── inventories/        # Environment configurations
└── group_vars/         # Variable definitions
```

## Configuration

Edit variables in:
- `inventories/development/group_vars/all.yml` - Main configuration
- `inventories/development/hosts.yml` - Host settings

### Key Settings

```yaml
# Database
postgres_db: farmo_dev
postgres_user: farmo_user
postgres_password: devpassword

# Keycloak
keycloak_admin_user: admin
keycloak_admin_password: admin123

# Application
app_port: 3000
domain_name: farmo.local
```

## Troubleshooting

### Docker Permission Issues
```bash
# Add user to docker group and restart session
sudo usermod -aG docker $USER
# Log out and log back in
```

### Service Not Starting
```bash
# Check container status
docker ps -a

# View container logs
docker logs <container-name>

# Restart services
ansible-playbook playbooks/deploy-services.yml
```

### Database Connection Issues
```bash
# Check PostgreSQL container
docker exec -it farmo-postgres psql -U farmo_user -d farmo_dev

# Reset database
docker stop farmo-postgres
docker rm farmo-postgres
ansible-playbook playbooks/deploy-services.yml
```

## Development

### Adding New Services

1. Create a new role in `roles/`
2. Add tasks in `roles/<service>/tasks/main.yml`
3. Include the role in appropriate playbooks
4. Update variables in `group_vars/`

### Environment Types

- **Development**: `inventories/development/` - Local setup
- **Production**: Create `inventories/production/` for server deployment

## Contributing

1. Test changes with `./test_env.sh`
2. Ensure all services start correctly
3. Update documentation for new features
4. Follow Ansible best practices

## License

MIT License - See LICENSE file for details

---

🚜 **Happy farming with Farmo!** 🌾