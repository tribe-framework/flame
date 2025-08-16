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
    echo "⚠️  .env file already exists!"
    echo "This script will NOT override your existing .env file."
    echo "Continuing with setup anyway..."
    SKIP_ENV_SETUP=true
else
    SKIP_ENV_SETUP=false
fi

# Create directories
mkdir -p applications
mkdir -p uploads

# Download phpMyAdmin
echo "📦 Downloading phpMyAdmin..."
if [ -d "applications/phpmyadmin" ]; then
    echo "🗑️ Removing existing phpmyadmin directory..."
    rm -rf applications/phpmyadmin
fi
    
curl -L https://files.phpmyadmin.net/phpMyAdmin/5.2.2/phpMyAdmin-5.2.2-all-languages.tar.gz -o pma.tar.gz
mkdir -p applications/phpmyadmin
tar -xzf pma.tar.gz -C applications/phpmyadmin --strip-components=1
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
    TRIBE_PORT="1212"
    JUNCTION_PORT="4488"
    DB_PORT="3306"
    DB_PASS="userpassword"
    DB_ROOT_PASSWORD="rootpassword"
    JUNCTION_PASSWORD="password"
    
    # Build URLs using localhost and the provided ports
    TRIBE_BARE_URL="localhost:$TRIBE_PORT"
    JUNCTION_BARE_URL="localhost:$JUNCTION_PORT"
    
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
    echo "  Database Password: $DB_PASS"
    echo "  Database Root Password: $DB_ROOT_PASSWORD"
    echo "  Junction Password: $JUNCTION_PASSWORD"
    echo ""
else
    echo ""
    echo "ℹ️ Skipping .env setup (file already exists)"
fi

echo "🎉 Setup complete! You can now run 'docker-compose up -d'"