#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Deployment...${NC}"

# 1. Install Nginx if not present
if ! command -v nginx &> /dev/null; then
    echo "Installing Nginx..."
    apt-get update
    apt-get install -y nginx
else
    echo "Nginx is already installed."
fi

# 2. Create Directory
echo "Creating website directory at /var/www/valentine..."
mkdir -p /var/www/valentine

# 3. Copy Files
# Assumes the script is run from the folder containing the files
echo "Copying files..."
if [ -f "index.html" ]; then
    cp index.html /var/www/valentine/
else
    echo "Error: index.html not found!"
    exit 1
fi

if [ -f "BackGround.jpeg" ]; then
    cp BackGround.jpeg /var/www/valentine/
fi

# 4. Configure Nginx
echo "Configuring Nginx..."
if [ -f "valentine.conf" ]; then
    cp valentine.conf /etc/nginx/sites-available/valentine
    
    # Create symlink if it doesn't exist
    if [ ! -f "/etc/nginx/sites-enabled/valentine" ]; then
        ln -s /etc/nginx/sites-available/valentine /etc/nginx/sites-enabled/
    fi
    
    # Remove default nginx site to avoid conflicts (Optional)
    rm -f /etc/nginx/sites-enabled/default
else
    echo "Error: valentine.conf not found!"
    exit 1
fi

# 5. Set Permissions
chown -R www-data:www-data /var/www/valentine
chmod -R 755 /var/www/valentine

# 6. Restart Nginx
echo "Restarting Nginx..."
systemctl restart nginx

echo -e "${GREEN}Deployment Complete! Your site should be live on your server IP.${NC}"