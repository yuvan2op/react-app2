#!/bin/sh
set -e

# Test nginx configuration
echo "Testing nginx configuration..."
if nginx -t; then
    echo "✓ Nginx configuration is valid"
else
    echo "✗ Nginx configuration test failed"
    exit 1
fi

# Start nginx
echo "Starting nginx..."
exec nginx -g "daemon off;"

