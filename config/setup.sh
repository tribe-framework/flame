#!/bin/bash

# Setup script to download phpMyAdmin, Tribe, and Junction
set -e

echo "🚀 Setting up development environment..."

# Function to prompt user for input with default value
prompt_with_default() {
    local prompt="$1"
    local default="$2"
    local var_name="$3"
    
    echo -n "$prompt [$default]: "
    read user_input
    
    if [ -z "$user_input" ]; then
        eval "$var_name=\"$default\""
    else
        eval "$var_name=\"$user_input\""
    fi
}

# Check if .env file exists and warn user
if [ -f ".env" ]; then
    echo "⚠️  .env file already exists!"
    echo "This script will NOT override your existing .env file."
    echo "If you want to reconfigure, please rename or delete the existing .env file first."
    echo ""
    read -p "Continue with setup anyway? (y/N): " continue_setup
    if [[ ! "$continue_setup" =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 0
    fi
    SKIP_ENV_SETUP=true
else
    SKIP_ENV_SETUP=false
fi

# Create directories
mkdir -p applications
mkdir -p uploads

# Download phpMyAdmin
echo "📦 Downloading phpMyAdmin..."
if [ ! -d "applications/phpmyadmin" ]; then
    curl -L https://files.phpmyadmin.net/phpMyAdmin/5.2.2/phpMyAdmin-5.2.2-all-languages.tar.gz -o pma.tar.gz
    mkdir -p applications/phpmyadmin
    tar -xzf pma.tar.gz -C applications/phpmyadmin --strip-components=1
    rm pma.tar.gz
    echo "✅ phpMyAdmin downloaded successfully!"
else
    echo "ℹ️ phpMyAdmin already exists, skipping..."
fi

# Download Tribe Framework
echo "📦 Downloading Tribe Framework..."
if [ ! -d "applications/tribe" ]; then
    curl -L -o tribe-dev.zip "https://github.com/tribe-framework/tribe/archive/refs/heads/dev.zip"
    unzip -q tribe-dev.zip
    mv tribe-dev applications/tribe
    rm tribe-dev.zip
    chmod -R 755 applications/tribe
    echo "✅ Tribe Framework downloaded successfully!"
else
    echo "ℹ️ Tribe Framework already exists, skipping..."
fi

# Download Junction
echo "📦 Downloading Junction..."
if [ -d "applications/junction" ]; then
    echo "🗑️ Removing existing junction directory..."
    rm -rf applications/junction
fi

curl -L -o junction-dev.zip "https://github.com/tribe-framework/junction/archive/refs/heads/dev.zip"
unzip -q junction-dev.zip
mv junction-dev applications/junction
rm junction-dev.zip
chmod -R 755 applications/junction
echo "✅ Junction downloaded successfully!"

# Setup environment configuration
if [ "$SKIP_ENV_SETUP" = false ]; then
    echo ""
    echo "🔧 Setting up environment configuration..."
    echo "Please provide the following configuration values (press Enter for defaults):"
    echo ""
    
    # Prompt for user inputs
    prompt_with_default "Web URL (without protocol)" "localhost:1212" "WEB_BARE_URL"
    prompt_with_default "Database password" "userpassword" "DB_PASS"
    prompt_with_default "Junction password" "password" "JUNCTION_PASSWORD"
    
    # Generate WEB_URL based on WEB_BARE_URL
    WEB_URL="http://$WEB_BARE_URL"
    TRIBE_API_URL="$WEB_URL"
    
    echo ""
    echo "📝 Creating .env file..."
    
    # Create .env file from template with user values
    cat > .env << EOF
ENV="prod"
ALLOW_CROSS_ORIGIN=true
SSL=false

WEB_BARE_URL="$WEB_BARE_URL"
WEB_URL="$WEB_URL"

DB_NAME="tribe_db"
DB_USER="tribe_user"
DB_PASS="$DB_PASS"
DB_HOST="mysql"
DB_PORT=3306

TRIBE_API_URL="$TRIBE_API_URL"
TRIBE_API_KEY=""

JUNCTION_PASSWORD="$JUNCTION_PASSWORD"
JUNCTION_SLUG="junction"

PLAUSIBLE_AUTH=""
PLAUSIBLE_DOMAIN=""

HIDE_POSTCODE_ATTRIBUTION="false"

DEFAULT_TIMEZONE="Asia/Kolkata"
EOF
    
    echo "✅ .env file created successfully!"
    echo ""
    echo "📋 Configuration Summary:"
    echo "  Web URL: $WEB_URL"
    echo "  Database Password: $DB_PASS"
    echo "  Junction Password: $JUNCTION_PASSWORD"
    echo ""
else
    echo ""
    echo "ℹ️ Skipping .env setup (file already exists)"
fi

echo "🎉 Setup complete! You can now run 'docker-compose up -d'"