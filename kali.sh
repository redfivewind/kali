# Initialise global variables
echo "[*] Initialising global variables..."
USER=$(whoami)

# Update system
echo "[*] Updating the system..."
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

# Install Docker
echo "[*] Installing Docker..."
sudo apt install -y docker.io
sudo apt install -y docker-compose
sudo usermod -aG docker $USER

# Install Bloodhound
echo "[*] Installing Bloodhound..."
#FIXME

# Install seclists
echo "[*] Installing seclists..."
sudo apt install -y seclists

# Configure services
echo "[*] Configuring services..."
sudo systemctl enable postgresql --now
