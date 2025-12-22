# Initialise global variables
echo "########################################"
echo "[*] Initialising global variables..."
echo "########################################"
USER=$(whoami)

# Update system
echo "########################################"
echo "[*] Updating the system..."
echo "########################################"
sudo dpkg --add-architecture i386
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

# Prepare dependencies
echo "########################################"
echo "[*] Preparing dependencies..."
echo "########################################"

# Setup Docker
echo "[*] Setting up Docker..."
sudo apt install -y docker.io
sudo apt install -y docker-compose
sudo usermod -aG docker $USER
sudo systemctl enable docker --now

# Setup generic Linux headers
echo "[*] Setting up the generic Linux headers..."
sudo apt install -y linux-headers-generic

# Setup Wine
echo "[*] Setting up Wine..."
sudo apt install -y wine
sudo apt install -y wine32

# Install packages
echo "########################################"
echo "[*] Installing packages..."
echo "########################################"

# Setup asleap
echo "[*] Setting up asleap..."
sudo apt install -y asleap

# Setup awscli
echo "[*] Setting up awscli..."
sudo apt install -y awscli

# Setup Bloodhound
echo "[*] Setting up Bloodhound..."
sudo apt install -y neo4j
sudo apt install -y bloodhound

# Setup Chisel
echo "[*] Setting up Chisel..."
sudo apt install -y chisel

# Setup cloudbrute
echo "[*] Setting up cloudbrute..."
sudo apt install -y cloudbrute

# Setup cloud-enum
echo "[*] Setting up cloud-enum..."
sudo apt install -y cloud-enum

# Setup crackmapexec
echo "[*] Setting up crackmapexec..."
sudo apt install -y crackmapexec

# Setup DKMS
echo "[*] Setting up DKMS..."
sudo apt install -y dkms

# Setup dnscat2
echo "[*] Setting up dnscat2..."
sudo apt install -y dnscat2-client
sudo apt install -y dnscat2-server

# Setup FreeRADIUS
echo "[*] Setting up FreeRADIUS..."
sudo apt install -y freeradius

# Setup gitleaks
echo "[*] Setting up gitleaks..."
sudo apt install -y gitleaks

# Setup hostapd
echo "[*] Setting up hostapd..."
sudo apt install -y hostapd

# Setup hostapd-mana
echo "[*] Setting up hostapd-mana..."
sudo apt install -y hostapd-mana

# Setup kerbrute
echo "[*] Setting up kerbrute..."
sudo pipx install kerbrute

# Setup magic-wormhole
echo "[*] Setting up magic-wormhole..."
sudo apt install -y magic-wormhole

# Setup Metasploit
echo "[*] Setting up Metasploit..."
sudo systemctl enable postgresql --now
sudo msfdb init

# Setup mingw-w64
echo "[*] Setting up mingw-w64..."
sudo apt install -y mingw-w64

# Setup NVIDIA driver & CUDA toolkit
echo "[*] Setting up NVIDIA driver & CUDA toolkit..."
sudo apt install -y nvidia-driver
sudo apt install -y nvidia-cuda-toolkit
KERNEL_CMDLINE=$(cat /etc/kernel/cmdline)
echo "$KERNEL_CMDLINE modprobe.blacklist=nouveau nouveau.modeset=0" | sudo tee /etc/kernel/cmdline

# Setup pacu
echo "[*] Setting up pacu..."
sudo apt install -y pacu

# Setup s3-account-search
echo "[*] Setting up s3-account-search..."
pipx install s3-account-search

# Setup seclists
echo "[*] Setting up seclists..."
sudo apt install -y seclists

# Setup snmpenum
echo "[*] Setting up snmpenum..."
sudo apt install -y snmpenum

# Setup spice-vdagent
echo "[*] Setting up spice-vdagent..."
sudo apt install -y spice-vdagent

# Setup sshuttle
echo "[*] Setting up sshuttle..."
sudo apt install -y sshuttle

# Setup subfinder
echo "[*] Setting up subfinder..."
sudo apt install -y subfinder

# Setup sublist3r
echo "[*] Setting up sublist3r..."
sudo apt install -y sublist3r

# Setup Tilix
echo "[*] Setting up Tilix..."
sudo apt install -y dub gettext libgio-2.0-dev-bin
cd /tmp
git clone https://github.com/gnunn1/tilix
cd tilix
dub build --build=release
sudo ./install.sh
cd

# Setup Veil
echo "[*] Setting up Veil..."
sudo apt install -y veil
sudo sed -i 's/"pip" "install" "pefile"/"pip" "install" "-Iv" "pefile==2019.4.18"/g' /usr/share/veil/config/setup.sh
veil --setup

# Setup Wapiti
echo "[*] Setting up Wapiti..."
sudo apt install -y wapiti

# Setup wordlists
echo "[*] Setting up wordlists..."
sudo gunzip /usr/share/wordlists/rockyou.txt.gz

# Setup wsgidav
echo "[*] Setting up wsgidav..."
sudo apt install -y python3-wsgidav

# Autoremove packages
echo "########################################"
echo "[*] Autoremoving packages..."
echo "########################################"
sudo apt autoremove -y
sudo apt clean -y
sudo apt autoclean -y
