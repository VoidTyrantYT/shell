#!/bin/bash
# Startup script for My Minecraft Panel
# Generated on: 2025-07-26T08:11:48.667Z

set -e

echo "Starting My Minecraft Panel Panel..."

# Check if .env exists
if [ ! -f .env ]; then
    echo "Error: .env file not found. Please run install.sh first."
    exit 1
fi

# Load environment variables
export $(cat .env | grep -v '^#' | xargs)

# Start services
docker-compose up -d

# Wait for services to be healthy
echo "Waiting for services to start..."
sleep 10

# Check service health
if docker-compose ps | grep -q "Up"; then
    echo "Panel started successfully!"
    echo "Panel URL: http://localhost"
    echo "HTTPS URL: https://localhost"
else
    echo "Error: Some services failed to start. Check logs with: docker-compose logs"
    exit 1
fi

# Show logs
echo "Showing recent logs (Ctrl+C to exit):"
docker-compose logs -f --tail=50
