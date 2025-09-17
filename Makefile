# ATA System Development Makefile

.PHONY: help install dev test clean build deploy

# Default target
help:
	@echo "ATA System Development Commands:"
	@echo "  install     - Install all dependencies"
	@echo "  dev         - Start development environment"
	@echo "  test        - Run all tests"
	@echo "  clean       - Clean build artifacts"
	@echo "  build       - Build production images"
	@echo "  deploy      - Deploy to production"

# Install dependencies
install:
	@echo "Installing backend dependencies..."
	cd backend && pip install -r requirements.txt
	@echo "Installing frontend dependencies..."
	cd frontend && npm install

# Start development environment
dev:
	@echo "Starting development environment..."
	docker-compose up -d postgres redis selenium-hub selenium-chrome
	@echo "Services started. Run 'make dev-backend' and 'make dev-frontend' in separate terminals."

dev-backend:
	@echo "Starting backend development server..."
	cd backend && python run.py

dev-frontend:
	@echo "Starting frontend development server..."
	cd frontend && npm run dev

# Run tests
test:
	@echo "Running backend tests..."
	cd backend && pytest
	@echo "Running frontend tests..."
	cd frontend && npm run test

test-backend:
	cd backend && pytest

test-frontend:
	cd frontend && npm run test

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	rm -rf backend/.coverage backend/htmlcov
	rm -rf frontend/dist frontend/node_modules/.cache

# Build production images
build:
	@echo "Building production images..."
	docker-compose build

# Initialize database
init-db:
	@echo "Initializing database..."
	cd backend && python init_db.py

# Start all services
up:
	docker-compose up -d

# Stop all services
down:
	docker-compose down

# View logs
logs:
	docker-compose logs -f

# Database migration
migrate:
	cd backend && flask db migrate

# Database upgrade
upgrade:
	cd backend && flask db upgrade

# Format code
format:
	cd backend && black .
	cd frontend && npm run format

# Lint code
lint:
	cd backend && flake8 .
	cd frontend && npm run lint