#!/bin/bash

# Nhost Deployment Script
# This script helps with manual deployments and can be used for local testing

set -e

# Function to log deployment failure
log_deployment_failure() {
    local exit_code=$1
    local failed_step="$2"
    local log_file="deployment_log_failed.txt"
    
    echo "❌ Deployment failed!"
    echo "Timestamp: $(date -u '+%Y-%m-%d %H:%M:%S UTC')" > "$log_file"
    echo "Environment: $ENVIRONMENT" >> "$log_file"
    echo "Base Directory: $NHOST_BASE_DIR" >> "$log_file"
    echo "Failed Step: $failed_step" >> "$log_file"
    echo "Exit Code: $exit_code" >> "$log_file"
    echo "User: $(whoami)" >> "$log_file"
    echo "Working Directory: $(pwd)" >> "$log_file"
    echo "" >> "$log_file"
    echo "Troubleshooting Steps:" >> "$log_file"
    echo "1. Check if Nhost CLI is properly authenticated (nhost auth whoami)" >> "$log_file"
    echo "2. Verify nhost.toml configuration is valid" >> "$log_file"
    echo "3. Ensure project is linked correctly (nhost link --help)" >> "$log_file"
    echo "4. Check database migration syntax if migration step failed" >> "$log_file"
    echo "5. Verify GraphQL metadata format if metadata step failed" >> "$log_file"
    echo "6. Review function code for syntax errors if function deployment failed" >> "$log_file"
    echo "" >> "$log_file"
    echo "Log file created: $log_file"
    
    cat "$log_file"
    exit $exit_code
}

# Trap to catch failures
trap 'log_deployment_failure $? "Unknown step"' ERR

# Configuration
NHOST_BASE_DIR="${NHOST_BASE_DIRECTORY:-.}"
ENVIRONMENT="${1:-development}"

echo "🚀 Starting Nhost deployment..."
echo "Environment: $ENVIRONMENT"
echo "Base Directory: $NHOST_BASE_DIR"

# Check if nhost.toml exists
if [ ! -f "$NHOST_BASE_DIR/nhost.toml" ]; then
    log_deployment_failure 1 "Configuration check - nhost.toml not found"
fi

cd "$NHOST_BASE_DIR"

# Check if Nhost CLI is installed
if ! command -v nhost &> /dev/null; then
    log_deployment_failure 1 "Prerequisites check - Nhost CLI not installed"
fi

# Check authentication
echo "🔐 Checking authentication..."
if ! nhost auth whoami &> /dev/null; then
    log_deployment_failure 1 "Authentication check - Not authenticated with Nhost"
fi

# Display configuration
echo "📋 Displaying current configuration..."
nhost config show || log_deployment_failure $? "Configuration display"

# Deploy database migrations
echo "🗄️  Deploying database migrations..."
if [ -d "nhost/migrations" ]; then
    nhost hasura migrations apply --all-databases || log_deployment_failure $? "Database migrations"
    echo "✅ Database migrations applied"
else
    echo "⚠️  No migrations directory found, skipping..."
fi

# Apply GraphQL metadata
echo "🔗 Applying GraphQL metadata..."
if [ -d "nhost/metadata" ]; then
    nhost hasura metadata apply || log_deployment_failure $? "GraphQL metadata"
    echo "✅ GraphQL metadata applied"
else
    echo "⚠️  No metadata directory found, skipping..."
fi

# Deploy serverless functions
echo "⚡ Deploying serverless functions..."
if [ -d "functions" ]; then
    nhost functions deploy || log_deployment_failure $? "Serverless functions"
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