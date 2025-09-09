# Mindful Infrastructure

Central infrastructure and orchestration repository for the Mindful application ecosystem.

## Repository Structure

This repository manages the infrastructure for:
- **mindful-crm-backend**: CRM backend service (port 8081)
- **mindful-crm-frontend**: CRM web interface (port 3001)
- **mindful-product-backend**: Product management backend (port 8080)
- **mindful-product-frontend**: Product management web interface (port 3000)

## Prerequisites

- Docker & Docker Compose
- Git
- MySQL (for local development without Docker)
- Node.js 18+ (for frontend development)
- Java 17+ & Maven (for backend development)

## Quick Start

### 1. Clone All Repositories

```bash
# Clone infrastructure repository
git clone https://github.com/yourusername/mindful-infrastructure.git
cd mindful-infrastructure

# Run the setup script to clone all service repositories
./setup-repos.sh
```

### 2. Set Up Environment Variables

```bash
# Copy example environment file
cp .env.example .env

# Edit .env with your configuration
nano .env
```

### 3. Start All Services

```bash
# Start all services with Docker Compose
docker-compose up -d

# Or use the Makefile
make up
```

### 4. Access Applications

- **Product Management**: http://localhost:3000
- **CRM Interface**: http://localhost:3001
- **Product API**: http://localhost:8080
- **CRM API**: http://localhost:8081
- **phpMyAdmin**: http://localhost:8082

## Service Ports

| Service | Port | Description |
|---------|------|-------------|
| MySQL | 3306 | Database |
| Product Backend | 8080 | Product Management API |
| CRM Backend | 8081 | CRM API |
| Product Frontend | 3000 | Product Management UI |
| CRM Frontend | 3001 | CRM UI |
| phpMyAdmin | 8082 | Database Management |

## Development

### Running Services Individually

```bash
# Backend services
cd ../mindful-product-backend && mvn spring-boot:run
cd ../mindful-crm-backend && mvn spring-boot:run

# Frontend services
cd ../mindful-product-frontend && npm start
cd ../mindful-crm-frontend && npm start
```

### Database Management

```bash
# Access MySQL CLI
docker exec -it mindful-mysql mysql -u mindful -p

# Run migrations
docker exec mindful-backend ./mvnw flyway:migrate
```

## Deployment

### Production Deployment

```bash
# Use production compose file
docker-compose -f docker-compose.prod.yml up -d
```

### Environment Variables

Key environment variables:
- `DATABASE_URL`: MySQL connection string
- `DATABASE_USERNAME`: Database user
- `DATABASE_PASSWORD`: Database password
- `JWT_SECRET`: Secret key for JWT tokens
- `SERVER_PORT`: Application port

## Monitoring

```bash
# View logs
docker-compose logs -f [service-name]

# Check service health
docker-compose ps

# Monitor resource usage
docker stats
```

## Troubleshooting

### Services not starting
```bash
# Check logs
docker-compose logs backend-crm

# Rebuild services
docker-compose build --no-cache
docker-compose up -d
```

### Database connection issues
```bash
# Verify MySQL is running
docker-compose ps mysql

# Check network connectivity
docker network inspect mindful-infrastructure_mindful-network
```

## Repository Links

- [CRM Backend](https://github.com/yourusername/mindful-crm-backend)
- [CRM Frontend](https://github.com/yourusername/mindful-crm-frontend)
- [Product Backend](https://github.com/yourusername/mindful-product-backend)
- [Product Frontend](https://github.com/yourusername/mindful-product-frontend)