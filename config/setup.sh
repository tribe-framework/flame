#!/bin/bash

# Setup script to download phpMyAdmin and Junction
set -e

echo "🚀 Setting up development environment..."

# Check if .env exists and handle accordingly
if [ -d ".env" ]; then
    echo "🗑️ Found .env directory - removing it..."
    rm -rf .env
    SKIP_ENV_SETUP=false
elif [ -f ".env" ]; then
    echo "⚠️ .env file already exists!"
    echo "This script will NOT override your existing .env file."
    echo "Continuing with setup anyway..."
    SKIP_ENV_SETUP=true
else
    SKIP_ENV_SETUP=false
fi

# Create directories
mkdir -p applications
mkdir -p uploads
mkdir -p uploads/sites

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

# Download phpMyAdmin
echo "📦 Downloading phpMyAdmin..."
if [ -d "applications/tribe/phpmyadmin" ]; then
    echo "🗑️ Removing existing phpmyadmin directory..."
    rm -rf applications/tribe/phpmyadmin
fi
    
curl -L https://files.phpmyadmin.net/phpMyAdmin/5.2.2/phpMyAdmin-5.2.2-all-languages.tar.gz -o pma.tar.gz
mkdir -p applications/tribe/phpmyadmin
tar -xzf pma.tar.gz -C applications/tribe/phpmyadmin --strip-components=1
rm pma.tar.gz
echo "✅ phpMyAdmin downloaded successfully!"

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

# Setup environment configuration
if [ "$SKIP_ENV_SETUP" = false ]; then
    echo ""
    echo "🔧 Setting up environment configuration with default values..."
    
    # Use default values directly
    TRIBE_PORT="4480"
    JUNCTION_PORT="4488"
    STATIC_PORT="4484"
    DIST_PHP_PORT="4485"
    DB_PORT="3306"
    DB_PASS="userpassword"
    DB_ROOT_PASSWORD="rootpassword"
    JUNCTION_PASSWORD="password"
    
    # Build URLs using localhost and the provided ports
    TRIBE_BARE_URL="localhost:$TRIBE_PORT"
    JUNCTION_BARE_URL="localhost:$JUNCTION_PORT"
    STATIC_BARE_URL="localhost:$STATIC_PORT"
    DIST_PHP_BARE_URL="localhost:$DIST_PHP_PORT"
    
    echo ""
    echo "📝 Creating .env file..."
    
    # Create .env file from template with default values
    cat > .env << EOF
# Config for Tribe and Junction
SSL=false
DISPLAY_ERRORS=false
ALLOW_API_FULL_ACCESS=true
DEFAULT_TIMEZONE="Asia/Kolkata"

# Tribe settings
TRIBE_BARE_URL="$TRIBE_BARE_URL"
TRIBE_URL="http://$TRIBE_BARE_URL"
TRIBE_PORT=$TRIBE_PORT

# Junction settings
JUNCTION_BARE_URL="$JUNCTION_BARE_URL"
JUNCTION_URL="http://$JUNCTION_BARE_URL"
JUNCTION_SLUG="junction"
JUNCTION_PASSWORD="$JUNCTION_PASSWORD"
TRIBE_API_URL="http://$TRIBE_BARE_URL"
TRIBE_API_KEY=""
JUNCTION_PORT=$JUNCTION_PORT
PLAUSIBLE_AUTH=""
PLAUSIBLE_DOMAIN=""
HIDE_POSTCODE_ATTRIBUTION="false"

# Static hosting settings
STATIC_BARE_URL="$STATIC_BARE_URL"
STATIC_URL="http://$STATIC_BARE_URL"
STATIC_PORT=$STATIC_PORT

# Dist PHP hosting settings
DIST_PHP_BARE_URL="$DIST_PHP_BARE_URL"
DIST_PHP_URL="http://$DIST_PHP_BARE_URL"
DIST_PHP_PORT=$DIST_PHP_PORT

# MySQL database settings
DB_NAME="tribe_db"
DB_USER="tribe_user"
DB_PASS="$DB_PASS"
DB_ROOT_PASSWORD="$DB_ROOT_PASSWORD"
DB_HOST="mysql"
DB_PORT=$DB_PORT
EOF
    
    echo "✅ .env file created successfully!"
    echo ""
    echo "📋 Configuration Summary:"
    echo "  Tribe URL: $TRIBE_BARE_URL"
    echo "  Junction URL: $JUNCTION_BARE_URL"
    echo "  Static Sites URL: $STATIC_BARE_URL"
    echo "  Dist PHP URL: $DIST_PHP_BARE_URL"
    echo "  Database Password: $DB_PASS"
    echo "  Database Root Password: $DB_ROOT_PASSWORD"
    echo "  Junction Password: $JUNCTION_PASSWORD"
    echo ""
else
    echo ""
    echo "ℹ️ Skipping .env setup (file already exists)"
fi