#!/bin/bash

# Function to check if command succeeded
check_status() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

echo "Starting repository separation..."

# Repository URLs
PERSONAL_WEBSITE_URL="https://github.com/peterosw/personal-website.git"
TECH_RADAR_URL="https://github.com/peterosw/IT-tech-Radar.git"

# 1. Create temporary directory for IT Tech Radar
echo "Moving IT Tech Radar to temporary location..."
mv it-projects-poc ../it-projects-poc-temp
check_status "Failed to move IT Tech Radar project"

# 2. Configure personal website repository
echo "Configuring personal website repository..."
git add .
git commit -m "Update personal website structure and configuration"
check_status "Failed to commit personal website changes"

echo "Setting personal website remote URL..."
git remote set-url origin $PERSONAL_WEBSITE_URL
check_status "Failed to set personal website remote URL"

# 3. Initialize IT Tech Radar repository
echo "Initializing IT Tech Radar repository..."
cd ../it-projects-poc-temp
check_status "Failed to change directory"

git init
check_status "Failed to initialize IT Tech Radar repository"

git add .
git commit -m "Initial commit for IT Tech Radar project"
check_status "Failed to commit IT Tech Radar files"

echo "Setting IT Tech Radar remote URL..."
git remote add origin $TECH_RADAR_URL
check_status "Failed to add IT Tech Radar remote"

git branch -M main
check_status "Failed to rename branch"

# 4. Move IT Tech Radar back to final location
echo "Moving IT Tech Radar to final location..."
cd ..
mv it-projects-poc-temp website2/it-projects-poc
check_status "Failed to move IT Tech Radar to final location"

echo "Repository separation complete!"
echo ""
echo "Next steps:"
echo "1. Push personal website:"
echo "   cd /Users/peterosw/Downloads/website2"
echo "   git push -u origin main"
echo ""
echo "2. Push IT Tech Radar:"
echo "   cd /Users/peterosw/Downloads/website2/it-projects-poc"
echo "   git push -u origin main"
