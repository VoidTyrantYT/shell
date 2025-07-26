#!/bin/bash
# Installation script for My Minecraft Panel
# Generated on: 2025-07-26T08:11:48.667Z

set -e

echo "Installing My Minecraft Panel Panel..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create directories
mkdir -p data logs

# Set permissions
chmod 755 data logs

# Generate random passwords if .env doesn't exist
if [ ! -f .env ]; then
    echo "Generating .env file with random passwords..."
    DB_PASSWORD=$(openssl rand -base64 32)
    DB_ROOT_PASSWORD=$(openssl rand -base64 32)
    
    sed -i "s/change_me_please/$DB_PASSWORD/g" .env
    sed -i "s/change_root_password_please/$DB_ROOT_PASSWORD/g" .env
fi

# Pull images
echo "Pulling Docker images..."
docker-compose pull

# Start services
echo "Starting services..."
docker-compose up -d

# Wait for database to be ready
echo "Waiting for database to be ready..."
sleep 30

# Run database migrations (if applicable)
if [ "Custom Panel" = "Pterodactyl" ]; then
    echo "Running database setup..."
    docker-compose exec -T panel php artisan migrate --force
    docker-compose exec -T panel php artisan db:seed --force
fi

echo "Installation complete!"
echo "Panel URL: http://localhost"
echo "HTTPS URL: https://localhost"
echo ""
echo "Please check the logs with: docker-compose logs -f"
