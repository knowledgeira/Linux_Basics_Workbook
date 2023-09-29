# Step 2: Install Chocolatey (Package Manager for Windows)
Set-ExecutionPolicy RemoteSigned -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Step 3: Setting up KnowledgeIra-Labs directory
$directoryPath = "C:\KnowledgeIra-Labs"
if (Test-Path $directoryPath -PathType Container) {
    Remove-Item -Path $directoryPath -Recurse -Force
}
New-Item -Path $directoryPath -ItemType Directory
cd $directoryPath

# Step 4: Install VirtualBox
choco install virtualbox -y

# Step 5: Install Vagrant
choco install vagrant -y

# Step 6: Create Vagrantfile
@"
Vagrant.configure("2") do |config|
 config.ssh.insert_key = false
 config.vm.define "knowledgeira" do |node|
 node.vm.box = "generic/ubuntu2204"
 node.vm.hostname = "knowledgeira"
 node.vm.network "private_network", ip: "192.168.57.100"
 end
end
"@ | Out-File -Encoding ascii Vagrantfile

# Step 7: Start Vagrant Box
# Disable the Windows firewall temporarily
netsh advfirewall set allprofiles state off
vagrant up

# Step 8: Display Vagrant Box Status
vagrant status

# Enable the Windows firewall again
netsh advfirewall set allprofiles state on

# Step 9: SSH into the Vagrant Box
# Provide an on-screen message
Write-Host "You can now SSH into the Vagrant box 'knowledgeira' using the following command:"
Write-Host "vagrant ssh knowledgeira"
