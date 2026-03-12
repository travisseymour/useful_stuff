# 1. Add the VSCodium GPG key
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
  | sudo gpg --dearmor -o /usr/share/keyrings/vscodium-archive-keyring.gpg

# 2. Add the VSCodium repository
echo "deb [signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg] \
https://download.vscodium.com/debs vscodium main" \
  | sudo tee /etc/apt/sources.list.d/vscodium.list > /dev/null

# 3. Update your package list
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y

# 4. Install VSCodium
sudo apt install codium -y

