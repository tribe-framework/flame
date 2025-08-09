#!/bin/bash

# Junction Installation Script
# Downloads and extracts the Junction framework to applications/junction

set -e  # Exit on any error

echo "🚀 Installing Junction Framework..."

# Create applications directory if it doesn't exist
mkdir -p /applications

# Download the Junction repository
echo "📥 Downloading Junction from GitHub..."
curl -L -o junction-dev.zip "https://github.com/tribe-framework/junction/archive/refs/heads/dev.zip"

# Check if download was successful
if [ ! -f "junction-dev.zip" ]; then
    echo "❌ Error: Failed to download Junction repository"
    exit 1
fi

echo "📦 Extracting Junction..."

# Remove existing junction directory if it exists
if [ -d "/applications/junction" ]; then
    echo "🗑️  Removing existing junction directory..."
    rm -rf /applications/junction
fi

# Extract the zip file
unzip -q junction-dev.zip

# Move the extracted folder to the correct location
mv junction-dev /applications/junction

# Clean up the zip file
rm junction-dev.zip

# Set proper permissions
chmod -R 755 /applications/junction

echo "✅ Junction installed successfully!"