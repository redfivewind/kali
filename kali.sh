# Initialise global constants
echo "########################################"
echo "[*] Initialising global constants..."
echo "########################################"
DEP_ARRAY=(
    "docker.io"
    "docker-compose"
    "golang"
    "linux-headers-generic"
    "neo4j"
    "pwgen"
    "wine"
    "wine32"
)
PKG_ARRAY=(
    "arjun"
    "asleap"
    "awscli"
    "bloodhound"
    "chisel"
    "cloudbrute"
    "cloud-enum"
    "crackmapexec"
    "dkms"
    "dnscat2-client"
    "dnscat2-server"
    "dub"
    "feroxbuster"
    "freeradius"
    "gettext"
    "gitleaks"
    "gospider"
    "hcxdumptool"
    "hcxtools"
    "hcxpcapngtool"
    "hostapd"
    "hostapd-mana"
    "libgio-2.0-dev-bin"
    "magic-wormhole"
    "mingw-w64"
    "seclists"
    "snmpenum"
    "spice-vdagent"
    "sshuttle"
    "subfinder"
    "sublist3r"
    "wapiti"
    "python3-wsgidav"
)

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
sudo apt dist-upgrade -y
sudo apt full-upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y
sudo apt clean -y

# Install dependencies
echo "########################################"
echo "[*] Installing dependencies..."
echo "########################################"

for dep in "${DEP_ARRAY[@]}"; do
    echo "[*] Installing dependency '$dep'..."
    sudo apt install -y $dep
done

# Install dependencies
echo "########################################"
echo "[*] Configuring dependencies..."
echo "########################################"

# Configure Docker
echo "[*] Configuring Docker..."
sudo usermod -aG docker $USER
sudo systemctl enable docker --now

# Configure Linux
echo "[*] Configuring Linux..."
KERNEL_CMDLINE=$(cat /etc/kernel/cmdline)
echo "$KERNEL_CMDLINE modprobe.blacklist=nouveau nouveau.modeset=0" | sudo tee /etc/kernel/cmdline

# Configure Neo4j
echo "[*] Configuring Neo4j..."
NEO4J_PW=$(pwgen -c -n -y -s 32 1)
sudo neo4j-admin set-initial-password "$NEO4J_PW"
sudo systemctl enable neo4j --now

# Configure PostgreSQL
echo "[*] Configuring PostgreSQL..."
sudo runuser -u postgres -- psql -c 'ALTER DATABASE postgres REFRESH COLLATION VERSION; ALTER DATABASE template1 REFRESH COLLATION VERSION;'
sudo systemctl enable postgresql --now

# Install packages
echo "########################################"
echo "[*] Installing packages..."
echo "########################################"

for pkg in "${PKG_ARRAY[@]}"; do
    echo "[*] Installing package '$pkg'..."
    sudo apt install -y $pkg
done

# Setup katana
echo "[*] Setting up katana..."
go install github.com/projectdiscovery/katana/cmd/katana@latest
sudo mv ~/go/bin/katana /usr/bin

# Setup kerbrute
echo "[*] Setting up kerbrute..."
sudo pipx install kerbrute

# Setup NVIDIA driver & CUDA toolkit
echo "[*] Setting up NVIDIA driver & CUDA toolkit..."
sudo apt install -y nvidia-driver
sudo apt install -y nvidia-cuda-toolkit

# Setup pacu
echo "[*] Setting up pacu..."
sudo apt install -y pacu

# Setup s3-account-search
echo "[*] Setting up s3-account-search..."
pipx install s3-account-search

# Setup Tilix
echo "[*] Setting up Tilix..."
cd /tmp
git clone https://github.com/gnunn1/tilix
cd tilix
dub build --build=release
sudo ./install.sh
cd


# Setup Wappalyzer
echo "[*] Setting up Wappalyzer..."
pipx install wappalyzer

# Autoremove packages
echo "########################################"
echo "[*] Autoremoving packages..."
echo "########################################"
sudo apt autoremove -y

# Configure packages
echo "########################################"
echo "[*] Configuring packages..."
echo "########################################"

# Configure Bloodhound
echo "[*] Configuring Bloodhound..."
sudo cp /etc/bhapi/bhapi.json /etc/bhapi/bhapi.json.old
jq --arg secret "$NEO4J_PW" '.neo4j.secret = $secret' /etc/bhapi/bhapi.json | sudo tee /etc/bhapi/bhapi.json
bloodhound-setup

# Configure Metasploit
echo "[*] Configuring Metasploit..."
sudo msfdb init

# Configure Veil
echo "[*] Configuring Veil..."
sudo sed -i 's/"pip" "install" "pefile"/"pip" "install" "-Iv" "pefile==2019.4.18"/g' /usr/share/veil/config/setup.sh
veil --setup --force --silent

# Configure wordlists
echo "[*] Configuring wordlists..."
sudo gunzip /usr/share/wordlists/rockyou.txt.gz
