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

# Setup dnscat2
echo "[*] Setting up dnscat2..."
sudo apt install -y dnscat2-client
sudo apt install -y dnscat2-server

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

# Setup mingw-w64
echo "[*] Setting up mingw-w64..."
sudo apt install -y mingw-w64

# Setup pacu
echo "[*] Setting up pacu..."
sudo apt install -y pacu

# Setup seclists
echo "[*] Setting up seclists..."
sudo apt install -y seclists

# Setup Veil
echo "[*] Setting up Veil..."
sudo apt install -y veil

# Setup Wine
echo "[*] Setting up Wine..."
sudo apt install -y wine
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y wine32

# Setup wordlists
echo "[*] Setting up wordlists..."
sudo gunzip /usr/share/wordlists/rockyou.txt.gz
