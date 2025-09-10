#!/bin/bash

set -e

echo "🚀 Setting up development environment..."

# Check if tribe-server is running
echo "🔍 Checking if tribe-server is running..."
if ! docker network ls | grep -q "tribe_network"; then
    echo "⚠️ tribe_network not found!"
    echo ""
    echo "Please ensure tribe-server is running first:"
    echo "  1. Clone or create the tribe-server project"
    echo "  2. Run: docker compose up -d"
    echo "  3. Then run this project setup"
    echo ""
    echo "The tribe-server provides MySQL and Syncthing services for all projects."
    exit 1
else
    echo "✅ tribe_network found - tribe-server is running!"
fi

# Load environment variables
set -a
[ -f .env ] && source .env
set +a

# Validate database connection
echo "🔍 Testing MySQL connection..."

# First check if container exists and is running
if ! docker ps --format '{{.Names}}' | grep -q "^${DB_HOST}$"; then
    echo "⚠️ ${DB_HOST} container is not running"
    echo "   Please start tribe-server first: docker compose up -d"
    exit 1
fi

# Wait for MySQL to be ready
echo "⏳ Waiting for MySQL to be ready..."
timeout=60
count=0
until docker exec ${DB_HOST} mysqladmin ping -u root -p"${MYSQL_ROOT_PASSWORD}" --silent 2>/dev/null; do
    sleep 2
    count=$((count + 2))
    if [ $count -ge $timeout ]; then
        echo "⚠️ MySQL did not become ready within ${timeout} seconds"
        docker logs ${DB_HOST} | tail -10
        exit 1
    fi
done

echo "✅ MySQL is ready and connection successful!"

# Check if database exists
echo "🔍 Checking if database ${DB_NAME} exists..."

# More reliable database existence check
DB_EXISTS=$(docker exec ${DB_HOST} mysql -u root -p"$MYSQL_ROOT_PASSWORD" -sN -e "SELECT COUNT(*) FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='${DB_NAME}';")

if [ "$DB_EXISTS" -eq 0 ]; then
    echo "📦 Database ${DB_NAME} does not exist. Creating..."
    
    # Create database
    if docker exec ${DB_HOST} mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"; then
        echo "✅ Database ${DB_NAME} created successfully!"
    else
        echo "⚠️ Failed to create database ${DB_NAME}"
        exit 1
    fi
    
    # Create user if not exists
    echo "👤 Creating database user ${DB_USER}..."
    if docker exec ${DB_HOST} mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';"; then
        echo "✅ User ${DB_USER} created successfully!"
    else
        echo "⚠️ Failed to create user ${DB_USER}"
        exit 1
    fi
    
    # Grant privileges
    echo "🔑 Granting privileges to ${DB_USER}..."
    docker exec ${DB_HOST} mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%'; FLUSH PRIVILEGES;"
    echo "✅ Privileges granted to ${DB_USER}!"
    
    # Import SQL schema
    if [ -f "/config/mysql/init/install.sql" ]; then
        echo "📥 Importing database schema from install.sql..."
        
        # Import directly without copying to container
        if docker exec -i ${DB_HOST} mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$DB_NAME" < /config/mysql/init/install.sql; then
            echo "✅ Database schema imported successfully!"
        else
            echo "⚠️ Failed to import database schema"
            exit 1
        fi
    else
        echo "⚠️ install.sql file not found, skipping schema import"
    fi
    
else
    echo "✅ Database ${DB_NAME} already exists!"
    echo "ℹ️ Skipping database creation and schema import."
fi

# Create directories
mkdir -p applications
mkdir -p uploads
mkdir -p uploads/sites
mkdir -p uploads/backups
mkdir -p config/syncthing

echo "📁 Created necessary directories"

# Create uploads/sites/dist directory if it doesn't exist
if [ ! -d "uploads/sites/dist" ]; then
    echo "📁 Creating uploads/sites/dist directory..."
    mkdir -p uploads/sites/dist
    
    # Create index.html with "Hello, world!" content
    echo "📄 Creating default index.html..."
    echo "Hello, world!" > uploads/sites/dist/index.html
    echo "✅ Default static site created in uploads/sites/dist!"
else
    echo "ℹ️ uploads/sites/dist directory already exists, skipping creation"
fi

# Create uploads/sites/dist-php directory if it doesn't exist
if [ ! -d "uploads/sites/dist-php" ]; then
    echo "📁 Creating uploads/sites/dist-php directory..."
    mkdir -p uploads/sites/dist-php
    
    # Create index.php with "Hello, PHP world!" content
    echo "📄 Creating default index.php..."
    cat > uploads/sites/dist-php/index.php << 'EOF'
<?php
require_once 'config/config.php';
echo "Hello, PHP world @ ".time();
?>
EOF
    echo "✅ Default PHP site created in uploads/sites/dist-php!"
else
    echo "ℹ️ uploads/sites/dist-php directory already exists, skipping creation"
fi

# Download Junction
echo "📦 Downloading Junction..."
if [ -d "applications/junction" ]; then
    echo "🗑️ Removing existing junction directory..."
    rm -rf applications/junction
fi

curl -L -o junction-dev.zip "https://github.com/tribe-framework/junction/archive/refs/heads/dev.zip"
mkdir -p applications/junction
unzip -q junction-dev.zip
mv junction-dev/dist applications/junction/dist
rm -rf junction-dev
rm junction-dev.zip
chmod -R 755 applications/junction
echo "✅ Junction downloaded successfully!"