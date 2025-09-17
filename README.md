# Mindful Infrastructure

Production-ready Docker configuration for the Mindful application stack.

## 🚀 Architecture

This repository provides fully containerized infrastructure for:
- **MySQL Database**: Persistent data storage with automatic schema setup
- **Product Backend**: Spring Boot API (port 8080)
- **CRM Backend**: Spring Boot CRM API (port 8081)
- **Product Frontend**: React web app (port 3000)
- **CRM Frontend**: React CRM interface (port 3001)
- **phpMyAdmin**: Database management interface (port 8082, dev only)

## ✅ Production-Ready Features

- ✅ **Fully Containerized**: No external dependencies required
- ✅ **Automatic Schema Setup**: Database tables created automatically
- ✅ **Health Checks**: Built-in health monitoring for all services
- ✅ **Security**: Environment variable templates and .gitignore protection
- ✅ **Production Config**: Separate production overrides
- ✅ **Schema Management**: Export/import scripts included

## 📋 Prerequisites

- Docker & Docker Compose
- Git

## 🚀 Quick Start

### 1. Clone and Configure

```bash
# Clone repository
git clone <your-repo-url>
cd mindful-infrastructure

# Copy and configure environment
cp .env.example .env
# Edit .env with your production values
```

### 2. Generate Secure Credentials

```bash
# Generate JWT secret
openssl rand -base64 32

# Generate strong database passwords
openssl rand -base64 24
```

### 3. Start the Stack

```bash
# Development
docker-compose up -d

# Production
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### 4. Access Applications

- **Product Management**: http://localhost:3000
- **CRM Interface**: http://localhost:3001
- **Product API**: http://localhost:8080/api
- **CRM API**: http://localhost:8081/api
- **phpMyAdmin**: http://localhost:8082 (dev only)

## 📦 Service Ports

| Service | Port | Description |
|---------|------|-------------|
| MySQL | 3306 | Database |
| Product Backend | 8080 | Product Management API |
| CRM Backend | 8081 | CRM API |
| Product Frontend | 3000 | Product Management UI |
| CRM Frontend | 3001 | CRM UI |
| phpMyAdmin | 8082 | Database Management |

## 🛠️ Schema Management

The database schema is automatically created from `mysql-init.sql` which includes:
- User creation and permissions
- Complete database schema with all tables
- Stored procedures and indexes

### Export Current Schema
```bash
./scripts/export-schema.sh
```

### Database Access
```bash
# MySQL CLI
docker-compose exec mysql mysql -u mindful -p productdb

# phpMyAdmin (development)
open http://localhost:8082
```

## 🔒 Security & Production

### Production Checklist
- [ ] Change all default passwords in `.env`
- [ ] Generate new JWT secret key
- [ ] Use `validate` for `DDL_AUTO` in production
- [ ] Set logging levels to `WARN` or `ERROR`
- [ ] Review and update security configurations

### Critical Environment Variables
**Required for Production:**
- `MYSQL_ROOT_PASSWORD` - Strong root password
- `DATABASE_PASSWORD` - Strong mindful user password
- `CRM_DATABASE_PASSWORD` - Strong CRM database password
- `JWT_SECRET` - Secure JWT signing key (generate with `openssl rand -base64 32`)

## 📊 Health Checks & Monitoring

All services include built-in health checks:
- **MySQL**: `mysqladmin ping`
- **Backend Services**: `/actuator/health` endpoints
- **Frontend Services**: HTTP status checks

### Monitoring Commands
```bash
# View all service logs
docker-compose logs -f

# Specific service logs
docker-compose logs -f backend
docker-compose logs -f mysql

# Service status
docker-compose ps

# Resource usage
docker stats
```

## 🛠️ Troubleshooting

**Database connection issues:**
- Check if MySQL container is running: `docker-compose ps`
- Verify credentials in `.env`
- Check logs: `docker-compose logs mysql`

**Port conflicts:**
- Ensure ports 3000, 3001, 8080, 8081, 3306, 8082 are available
- Modify port mappings in docker-compose.yml if needed

**Service startup issues:**
```bash
# Rebuild services
docker-compose build --no-cache
docker-compose up -d

# Check specific service logs
docker-compose logs backend-crm
```

## 📋 Maintenance

**Database Backup:**
```bash
docker-compose exec mysql mysqldump -u root -p productdb > backup.sql
```

**Database Restore:**
```bash
docker-compose exec -i mysql mysql -u root -p productdb < backup.sql
```

**Update Schema:**
```bash
# Export current schema
./scripts/export-schema.sh

# Update mysql-init.sql with new schema
# Restart with new schema
docker-compose down && docker-compose up -d
```

## 🗂️ File Structure

```
mindful-infrastructure/
├── docker-compose.yml          # Main Docker configuration
├── docker-compose.prod.yml     # Production overrides
├── mysql-init.sql              # Database initialization + schema
├── .env                        # Environment variables (not committed)
├── .env.example               # Environment template
├── scripts/
│   └── export-schema.sh       # Schema export script
└── README.md                  # This file
```