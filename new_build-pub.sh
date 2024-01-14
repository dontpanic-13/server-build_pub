# Check and apply system updates
apt-get update && apt-get dist-upgrade -y

#Install prerequisites
echo Installing prereqs....

apt-get -y install git htop net-tools ca-certificates curl gnupg sudo
curl -fsSL https://deb.nodesource.com/setup_21.x | bash - &&\
apt-get install -y nodejs

echo prereq install complete!

/sbin/adduser user sudo


#Install Cronicle and copy config file
curl -s https://raw.githubusercontent.com/jhuckaby/Cronicle/master/bin/install.js | node
rm /opt/cronicle/conf/config.json
cd /opt/cronicle/conf/
wget -O config.json https://raw.githubusercontent.com/dontpanic-13/server-build/main/cronicle/config.json?token=SUPERSECRETTOKEN
#\\\\\\\  Install Docker  ///////#
echo Starting Docker Install...
# Add Docker's official GPG key:
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

#Install latest version

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo Docker install completed!

#\\\\\\\  Install Netdata  ///////#
wget -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh && sh /tmp/netdata-kickstart.sh --no-updates --stable-channel --disable-telemetry

# Edit Client API KEY #
echo Setting client API key...

CLIENTAPI=$(cat /var/lib/netdata/registry/netdata.public.unique.id)
OLDAPI=SUPERDUPERAPIKEY

cd /etc/netdata/

sed -i "s/$OLDAPI/$CLIENTAPI/" stream.conf

