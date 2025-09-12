#!/bin/bash

set -e

# Create directories
mkdir -p uploads/sites

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

echo "✅ Setup completed"