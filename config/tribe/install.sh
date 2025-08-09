#!/bin/bash

# Tribe Installation Script
# Downloads and extracts the Tribe framework to applications/tribe

set -e  # Exit on any error

echo "🚀 Installing Tribe Framework..."

# Create applications directory if it doesn't exist
mkdir -p /applications

# Download the Tribe repository
echo "📥 Downloading Tribe from GitHub..."
curl -L -o tribe-dev.zip "https://github.com/tribe-framework/tribe/archive/refs/heads/dev.zip"

# Check if download was successful
if [ ! -f "tribe-dev.zip" ]; then
    echo "❌ Error: Failed to download Tribe repository"
    exit 1
fi

echo "📦 Extracting Tribe..."

# Tribe directory if it exists
if [ -d "/applications/tribe" ]; then
    echo "❌ Error: Tribe directory exists..."
else
    # Extract the zip file
    unzip -q tribe-dev.zip

    # Move the extracted folder to the correct location
    mv tribe-dev /applications/tribe

    # Clean up the zip file
    rm tribe-dev.zip

    # Set proper permissions
    chmod -R 755 /applications/tribe

    echo "✅ Tribe installed successfully!"
fi