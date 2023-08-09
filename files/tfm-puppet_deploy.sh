#!/bin/bash
#
# FOREMAN DEPLOY : PUPPETSERVER (+PUPPETCA)
#

export http_proxy='http://172.16.202.253:3128'

wget https://apt.puppet.com/puppet6-release-buster.deb
dpkg -i puppet6-release-buster.deb
apt-get -qy update
apt --yes install puppet-agent

REQUIRED_PKG=foreman-installer
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
apt-get --yes install gnupg
wget -q https://deb.theforeman.org/pubkey.gpg -O- | apt-key add -
cat > /etc/apt/sources.list.d/foreman.list <<EOF
# Debian Buster
deb http://deb.theforeman.org/ buster 2.3
# Plugins compatible with Stable
deb http://deb.theforeman.org/ plugins 2.3
EOF
apt-get -qy update
apt-get --yes install $REQUIRED_PKG || exit 1
fi

foreman-installer \
--skip-puppet-version-check \
--no-enable-foreman \
--no-enable-foreman-cli \
--no-enable-foreman-proxy \
--enable-puppet \
--puppet-server-foreman-url=https://tfm-app.loxda.net \
--puppet-server=true \
--puppet-server-ca=true \
--puppet-server-admin-api-whitelist=localhost \
--puppet-server-admin-api-whitelist=tfm-puppet.loxda.net \
--puppet-server-admin-api-whitelist=tfm-proxy.loxda.net \
--puppet-server-ca-client-whitelist=localhost \
--puppet-server-ca-client-whitelist=tfm-puppet.loxda.net \
--puppet-server-ca-client-whitelist=tfm-proxy.loxda.net \
--puppet-server-environment-class-cache-enabled=false \
--puppet-server-envs-dir="/etc/puppetlabs/code/environments" \
--puppet-codedir="/etc/puppetlabs/code"

# trigger SSL signing after puppserver deployment
/opt/puppetlabs/bin/puppet ssl bootstrap --server tfm-puppet.loxda.net
