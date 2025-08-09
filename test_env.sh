#!/bin/bash

echo "🔧 Testing Development Environment Setup"
echo "========================================"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test function
test_command() {
    if command -v "$1" &> /dev/null; then
        echo -e "${GREEN}✅ $1 is installed${NC}"
        if [ "$2" ]; then
            echo -e "   Version: $($1 $2 2>/dev/null || echo 'Version check failed')"
        fi
    else
        echo -e "${RED}❌ $1 is NOT installed${NC}"
    fi
}

test_service() {
    if systemctl is-active --quiet "$1"; then
        echo -e "${GREEN}✅ $1 service is running${NC}"
    else
        echo -e "${RED}❌ $1 service is NOT running${NC}"
    fi
}

echo
echo "📦 Basic System Tools"
echo "===================="
test_command "curl" "--version"
test_command "wget" "--version"
test_command "git" "--version"

echo
echo "🐳 Docker Environment"
echo "==================="
test_command "docker" "--version"
test_command "docker-compose" "--version"
test_service "docker"

# Test Docker permissions
echo
echo "🔑 Docker Permissions"
echo "===================="
if groups | grep -q docker; then
    echo -e "${GREEN}✅ User is in docker group${NC}"
else
    echo -e "${RED}❌ User is NOT in docker group${NC}"
fi

# Test Docker functionality
echo
echo "🧪 Docker Functionality Test"
echo "=========================="
if docker ps &> /dev/null; then
    echo -e "${GREEN}✅ Docker is accessible without sudo${NC}"
    echo "Current containers:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
else
    echo -e "${RED}❌ Docker requires sudo or user needs to log out/in${NC}"
fi

echo
echo "📱 Node.js Environment"
echo "===================="
test_command "node" "--version"
test_command "npm" "--version"
test_command "npx" "--version"

# Test npm global packages
echo
echo "🌐 Global npm packages"
echo "===================="
for pkg in nodemon pm2 typescript; do
    if npm list -g "$pkg" &> /dev/null; then
        echo -e "${GREEN}✅ $pkg is installed globally${NC}"
    else
        echo -e "${YELLOW}⚠️  $pkg is NOT installed globally${NC}"
    fi
done

echo
echo "💻 Development Tools"
echo "==================="
test_command "code" "--version"
test_command "psql" "--version"
test_command "redis-cli" "--version"

echo
echo "🔌 VS Code Extensions"
echo "===================="
if command -v code &> /dev/null; then
    echo "Installed VS Code extensions:"
    code --list-extensions | head -10
    echo "Total extensions: $(code --list-extensions | wc -l)"
else
    echo -e "${RED}❌ VS Code not found${NC}"
fi

echo
echo "📁 Project Structure"
echo "==================="
if [ -d "$HOME/Development/farmo" ]; then
    echo -e "${GREEN}✅ Project directory exists${NC}"
    echo "Structure:"
    tree "$HOME/Development/farmo" 2>/dev/null || ls -la "$HOME/Development/farmo"
else
    echo -e "${YELLOW}⚠️  Project directory not found${NC}"
    echo "Creating project directories..."
    mkdir -p "$HOME/Development/farmo"/{backend,frontend,mobile}
    echo -e "${GREEN}✅ Project directories created${NC}"
fi

echo
echo "🔐 Security Tools"
echo "================"
test_service "ufw"
test_service "fail2ban"

echo
echo "🎯 Summary"
echo "=========="
echo "Test completed! Check the results above."
echo
echo "Next steps if everything looks good:"
echo "1. Deploy databases: ansible-playbook playbooks/deploy-databases.yml"
echo "2. Test containers: docker ps"
echo "3. Start coding! 🚀"