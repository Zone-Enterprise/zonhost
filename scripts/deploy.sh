#!/bin/bash

# Nhost Deployment Script
# This script helps with manual deployments and can be used for local testing

set -e

# Configuration
NHOST_BASE_DIR="${NHOST_BASE_DIRECTORY:-.}"
ENVIRONMENT="${1:-development}"

echo "🚀 Starting Nhost deployment..."
echo "Environment: $ENVIRONMENT"
echo "Base Directory: $NHOST_BASE_DIR"

# Check if nhost.toml exists
if [ ! -f "$NHOST_BASE_DIR/nhost.toml" ]; then
    echo "❌ nhost.toml not found in $NHOST_BASE_DIR"
    exit 1
fi

cd "$NHOST_BASE_DIR"

# Check if Nhost CLI is installed
if ! command -v nhost &> /dev/null; then
    echo "❌ Nhost CLI is not installed. Please install it with:"
    echo "npm install -g @nhost/cli"
    exit 1
fi

# Check authentication
echo "🔐 Checking authentication..."
if ! nhost auth whoami &> /dev/null; then
    echo "❌ Not authenticated with Nhost. Please run:"
    echo "nhost auth login"
    exit 1
fi

# Display configuration
echo "📋 Displaying current configuration..."
nhost config show

# Deploy database migrations
echo "🗄️  Deploying database migrations..."
if [ -d "nhost/migrations" ]; then
    nhost hasura migrations apply --all-databases
    echo "✅ Database migrations applied"
else
    echo "⚠️  No migrations directory found, skipping..."
fi

# Apply GraphQL metadata
echo "🔗 Applying GraphQL metadata..."
if [ -d "nhost/metadata" ]; then
    nhost hasura metadata apply
    echo "✅ GraphQL metadata applied"
else
    echo "⚠️  No metadata directory found, skipping..."
fi

# Deploy serverless functions
echo "⚡ Deploying serverless functions..."
if [ -d "functions" ]; then
    nhost functions deploy
    echo "✅ Serverless functions deployed"
else
    echo "⚠️  No functions directory found, skipping..."
fi

echo "🎉 Deployment completed successfully!"
echo ""
echo "Next steps:"
echo "1. Check your Nhost dashboard for deployment status"
echo "2. Test your GraphQL endpoint"
echo "3. Verify your serverless functions are working"