#!/usr/bin/env zsh

# Initialise global constants
echo "########################################"
echo "[*] Initialising global constants..."
echo "########################################"

DEP_APT_ARRAY=(
    "docker.io"
    "docker-compose"
    "golang"
    "linux-headers-generic"
    "neo4j"
    "pwgen"
    "wine"
    "wine32"
)
PKG_APT_ARRAY=(
    "arjun"
    "asleap"
    "awscli"
    "bloodhound"
    "chisel"
    "cloudbrute"
    "cloud-enum"
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
    "hostapd"
    "hostapd-mana"
    "libgio-2.0-dev-bin"
    "magic-wormhole"
    "mingw-w64"
    "nvidia-driver"
    "nvidia-cuda-toolkit"
    "pacu"
    "python3-wsgidav"
    "seclists"
    "snmpenum"
    "spice-vdagent"
    "sshuttle"
    "subfinder"
    "sublist3r"
    "wapiti"
)
PKG_GO_ARRAY=(
    "github.com/projectdiscovery/katana/cmd/katana@latest"
)
PKG_PIPX_ARRAY=(
    "kerbrute"
    "s3-account-search"
    "wappalyzer"
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

for dep_apt in "${DEP_APT_ARRAY[@]}"; do
    echo "[*] Installing APT dependency '$dep_apt'..."
    sudo apt install -y $dep_apt
done

# Configure dependencies
echo "########################################"
echo "[*] Configuring dependencies..."
echo "########################################"

# Configure Docker
echo "[*] Configuring Docker..."
sudo usermod -aG docker $USER
sudo systemctl enable docker --now

# Configure Go
echo "[*] Configuring Go..."
echo "export GOROOT=/usr/local/go" >> ~/.bashrc
echo "export GOPATH=\$HOME/go" >> ~/.bashrc
echo "export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin" >> ~/.bashrc
echo "export GOROOT=/usr/local/go" >> ~/.zshrc
echo "export GOPATH=\$HOME/go" >> ~/.zshrc
echo "export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin" >> ~/.zshrc
source ~/.zshrc

# Configure GRUB2
echo "[*] Configuring GRUB2 (if applicable)..."
if [ -f /etc/default/grub ]; then
    sed -i 's/^\(GRUB_CMDLINE_LINUX="[^"]*\)"/\1 modprobe.blacklist=nouveau nouveau.modeset=0"/' /etc/default/grub
fi

# Configure Linux kernel
echo "[*] Configuring the Linux kernel (if applicable)..."
if [ -f /etc/kernel/cmdline ]; then
    KERNEL_CMDLINE=$(cat /etc/kernel/cmdline)
    echo "$KERNEL_CMDLINE modprobe.blacklist=nouveau nouveau.modeset=0" | sudo tee /etc/kernel/cmdline
fi

# Configure Neo4j
echo "[*] Configuring Neo4j..."
NEO4J_PW=$(pwgen -c -n -y -s 32 1)
sudo neo4j-admin set-initial-password "$NEO4J_PW"
sudo systemctl enable neo4j --now

# Configure PostgreSQL
echo "[*] Configuring PostgreSQL..."
sudo systemctl enable postgresql --now
sudo runuser -u postgres -- psql -c 'ALTER DATABASE postgres REFRESH COLLATION VERSION; ALTER DATABASE template1 REFRESH COLLATION VERSION;'

# Install packages
echo "########################################"
echo "[*] Installing packages..."
echo "########################################"

for pkg_apt in "${PKG_APT_ARRAY[@]}"; do
    echo "[*] Installing APT package '$pkg_apt'..."
    sudo apt install -y $pkg_apt
done

for pkg_go in "${PKG_GO_ARRAY[@]}"; do
    echo "[*] Installing Go package '$pkg_go'..."
    sudo apt install -y $pkg_go
done

for pkg_pipx in "${PKG_PIPX_ARRAY[@]}"; do
    echo "[*] Installing PIPX package '$pkg_pipx'..."
    sudo pipx install $pkg_pipx
done

# Setup Tilix
echo "[*] Setting up Tilix..."
cd /tmp
git clone https://github.com/gnunn1/tilix
cd tilix
dub build --build=release
sudo ./install.sh
cd

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
