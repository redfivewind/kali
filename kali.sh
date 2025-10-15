# Initialise global variables
echo "[*] Initialising global variables..."
USER=$(whoami)

# Update system
echo "[*] Updating the system..."
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

# Setup Bloodhound
echo "[*] Setting up Bloodhound..."
sudo apt install -y neo4j
sudo apt install -y bloodhound

# Setup Docker
#echo "[*] Setting up Docker..."
#sudo apt install -y docker.io
#sudo apt install -y docker-compose
#sudo usermod -aG docker $USER
#sudo systemctl enable docker --now

# Setup Metasploit
echo "[*] Setting up Metasploit..."
sudo systemctl enable postgresql --now
sudo msfdb init

# Setup seclists
echo "[*] Setting up seclists..."
sudo apt install -y seclists
