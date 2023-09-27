#!/usr/bin/bash
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
clear

# Step 1: Create (or recreate) the KnowledgeIra-Labs directory
echo -e "${BLUE}STEP 1: Setting up KnowledgeIra-Labs directory...${NC}"
echo "------------------------------------------------"
if [ -d "KnowledgeIra-Labs" ]; then
    echo "Removing existing KnowledgeIra-Labs directory..."
    rm -rf KnowledgeIra-Labs
    sleep 10
fi
echo "Creating new KnowledgeIra-Labs directory..."
mkdir KnowledgeIra-Labs
cd KnowledgeIra-Labs/
sleep 10

# Step 2: Check Secure Boot Status
echo -e "\n\n${BLUE}STEP 2: Checking Secure Boot Status...${NC}"
echo "------------------------------------------------"
if ! command -v mokutil &>/dev/null; then
    sudo apt update
    sudo apt install -y mokutil
    sleep 10
fi
secure_boot_status=$(sudo mokutil --sb-state)
if [[ $secure_boot_status == "SecureBoot enabled" ]]; then
    echo "Secure boot is enabled. Please disable it from BIOS."
else
    echo "Secure boot is disabled."
fi
sleep 10

# Step 3: Check CPU Virtualization
echo -e "\n\n${BLUE}STEP 3: Checking CPU Virtualization...${NC}"
echo "------------------------------------------------"
if lscpu | grep -i -E 'svm|vmx' &>/dev/null; then
    echo "Virtualization is supported on this machine."
else
    echo "Virtualization is not supported or not enabled in the BIOS."
fi
sleep 10

# Step 4: Install Vagrant
echo -e "\n\n${BLUE}STEP 4: Installing Vagrant...${NC}"
echo "------------------------------------------------"
if ! command -v vagrant &> /dev/null; then
    sudo apt update
    sudo apt install -y vagrant
    sleep 10
else
    echo "Vagrant is already installed."
fi

# Step 5: Install VirtualBox and DKMS
echo -e "\n\n${BLUE}STEP 5: Installing VirtualBox and DKMS...${NC}"
echo "------------------------------------------------"
if ! command -v virtualbox &> /dev/null; then
    sudo apt update
    sudo apt install -y virtualbox dkms
    sleep 10
else
    echo "VirtualBox is already installed."
fi

# Step 6: Create Vagrantfile
echo -e "\n\n${BLUE}STEP 6: Creating Vagrantfile...${NC}"
echo "------------------------------------------------"
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
sleep 10

# Step 7: Start Vagrant Box
echo -e "\n\n${BLUE}STEP 7: Starting Vagrant box...${NC}"
echo "------------------------------------------------"
vagrant up
sleep 10

# Step 8: Display Vagrant Box Status
echo -e "\n\n${BLUE}STEP 8: Displaying Vagrant box status...${NC}"
echo "------------------------------------------------"
vagrant status
