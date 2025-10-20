# Initialise global variables
echo "[*] Initialising global variables..."
USER=$(whoami)

# Update system
echo "[*] Updating the system..."
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

# Setup awscli
echo "[*] Setting up awscli..."
sudo apt install -y awscli

# Setup Bloodhound
echo "[*] Setting up Bloodhound..."
sudo apt install -y neo4j
sudo apt install -y bloodhound

# Setup crackmapexec
echo "[*] Setting up crackmapexec..."
sudo apt install -y crackmapexec

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

# Setup pacu
echo "[*] Setting up pacu..."
sudo apt install -y pacu

# Setup seclists
echo "[*] Setting up seclists..."
sudo apt install -y seclists

# Setup wordlists
echo "[*] Setting up wordlists..."
sudo gunzip /usr/share/wordlists/rockyou.txt.gz
