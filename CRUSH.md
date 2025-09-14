# CRUSH Agent Configuration

## Build Commands
- `make build` - Build all Docker images
- `make up` - Start all services
- `make down` - Stop all services
- `make restart` - Restart all services
- `make rebuild` - Clean rebuild of all services
- `make dev` - Start in development mode
- `make prod` - Start in production mode

## Test Commands
- `make test-backend` - Run backend tests in Docker container
- For running a single test: `docker-compose exec [service] mvn -Dtest=TestClassName#testMethodName test`

## Lint/Format Commands
- Backend (Java): `docker-compose exec backend mvn checkstyle:check`
- Frontend (JS/TS): `docker-compose exec frontend npm run lint`

## Development Commands
- `make logs` - View logs from all services
- `make clean` - Remove containers, networks, and volumes
- Service-specific logs: `make backend-logs`, `make frontend-logs`, `make crm-logs`, `make mysql-logs`

## Code Style Guidelines
- Java backend: Follow standard Spring Boot conventions with Maven
- JavaScript/TypeScript frontend: Use ES6+ with React patterns
- Naming: camelCase for variables/functions, PascalCase for classes/components
- Imports: Alphabetize and group by external/internal
- Types: Use TypeScript for frontend, strong typing in Java backend
- Error handling: Try-catch blocks with proper logging
- Formatting: Use Prettier for frontend, Checkstyle for backend
- Documentation: Javadoc for backend, JSDoc for frontend

## Database Operations
- `make db-shell` - Access MySQL shell
- `make db-backup` - Create database backup

## Infrastructure
- Multi-repo architecture managed by setup-repos.sh
- Docker-based development environment
- Environment variables in .env files