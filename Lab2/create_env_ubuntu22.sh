#!/usr/bin/bash
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
clear

# Step 1: Create (or recreate) the KnowledgeIra-Labs directory
if [ -d "KnowledgeIra-Labs" ]; then
    echo -e "${BLUE}Removing existing KnowledgeIra-Labs directory...${NC}"
    rm -rf KnowledgeIra-Labs
fi
echo -e "${GREEN}Creating new KnowledgeIra-Labs directory...${NC}"
mkdir KnowledgeIra-Labs
cd KnowledgeIra-Labs/

# Step 2: Check Secure Boot Status
if ! command -v mokutil &>/dev/null; then
    sudo apt update
    sudo apt install -y mokutil
fi
secure_boot_status=$(sudo mokutil --sb-state)
if [[ $secure_boot_status == "SecureBoot enabled" ]]; then
    echo -e "${GREEN}Secure boot is enabled. Please disable it from BIOS.${NC}"
else
    echo -e "${GREEN}Secure boot is disabled.${NC}"
fi

# Step 3: Check CPU Virtualization
if lscpu | grep -i -E 'svm|vmx' &>/dev/null; then
    echo -e "${GREEN}Virtualization is supported on this machine.${NC}"
else
    echo -e "${RED}Virtualization is not supported or not enabled in the BIOS.${NC}"
fi

# Step 4: Install Vagrant
if ! command -v vagrant &> /dev/null; then
    echo -e "${BLUE}Installing Vagrant...${NC}"
    sudo apt update
    sudo apt install -y vagrant
else
    echo -e "${GREEN}Vagrant is already installed.${NC}"
fi

# Step 5: Install VirtualBox and DKMS
if ! command -v virtualbox &> /dev/null; then
    echo -e "${BLUE}Installing VirtualBox and DKMS...${NC}"
    sudo apt update
    sudo apt install -y virtualbox dkms
else
    echo -e "${GREEN}VirtualBox is already installed.${NC}"
fi

# Step 6: Create Vagrantfile
echo -e "${BLUE}Creating Vagrantfile...${NC}"
cat > Vagrantfile <<EOL
Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.vm.define "knowledgeira" do |node|
    node.vm.box = "generic/ubuntu2204"
    node.vm.hostname = "knowledgeira"
    node.vm.network "private_network", ip: "192.168.57.100"
  end
end
EOL

# Step 7: Start Vagrant Box
echo -e "${BLUE}Starting Vagrant box...${NC}"
vagrant up

# Step 8: Display Vagrant Box Status
echo -e "${GREEN}Vagrant box status:${NC}"
vagrant status
