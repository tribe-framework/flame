#!/bin/bash

URL="https://tribe.localhost:12000"

# Wait for the URL to respond
while ! curl -k -s "$URL" > /dev/null 2>&1; do
    echo "URL not accessible yet, waiting..."
    sleep 2
done

echo "Service is ready! Opening $URL"

# Cross-platform browser opening
if command -v xdg-open > /dev/null; then
    xdg-open "$URL"  # Linux
elif command -v open > /dev/null; then
    open "$URL"      # macOS
elif command -v start > /dev/null; then
    start "$URL"     # Windows
else
    echo "Could not detect how to open browser. Please manually open: $URL"
fi