# Docker commands for PulseFit

.PHONY: help build up down logs clean restart shell db-shell

# Default target
help:
	@echo "Available commands:"
	@echo "  build     - Build Docker images"
	@echo "  up        - Start all services"
	@echo "  down      - Stop all services"
	@echo "  logs      - View logs"
	@echo "  clean     - Clean up containers and images"
	@echo "  restart   - Restart all services"
	@echo "  shell     - Access app container shell"
	@echo "  db-shell  - Access database shell"

# Build Docker images
build:
	docker-compose build --no-cache

# Start all services
up:
	docker-compose up -d

# Start services in foreground
up-fg:
	docker-compose up

# Stop all services
down:
	docker-compose down

# View logs
logs:
	docker-compose logs -f

# View specific service logs
logs-app:
	docker-compose logs -f pulsefit-app

logs-db:
	docker-compose logs -f postgres

# Clean up
clean:
	docker-compose down -v
	docker system prune -f
	docker volume prune -f

# Restart services
restart:
	docker-compose restart

# Access app container shell
shell:
	docker-compose exec pulsefit-app sh

# Access database shell
db-shell:
	docker-compose exec postgres psql -U pulsefit_user -d pulsefit

# Development mode
dev:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

# Production mode
prod:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Health check
health:
	curl -f http://localhost:3000/api/health || echo "Health check failed"

# Database backup
backup:
	docker-compose exec postgres pg_dump -U pulsefit_user pulsefit > backup_$(shell date +%Y%m%d_%H%M%S).sql

# Database restore
restore:
	@read -p "Enter backup file path: " file; \
	docker-compose exec -T postgres psql -U pulsefit_user -d pulsefit < $$file
