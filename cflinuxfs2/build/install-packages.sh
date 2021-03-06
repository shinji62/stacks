set -e -x

source /etc/lsb-release

function apt_get() {
  # CHANGES from lucid64 script:
  # - REMOVED `--fix-broken` option as seems to be missing in trusty
  apt-get -y --force-yes --no-install-recommends "$@"
}

# CHANGES from lucid64 packages:
# - REPLACED libmagick9-dev with graphicsmagick-libmagick-dev-compat
# - REMOVED libgraphviz4 as it does not exist in trusty
# - REMOVED libpango1.0-common as it does not exist in trusty
# - REMOVED laptop-detect
packages_from_lucid_debootstrap="
aptitude
dmidecode
fontconfig
gsfonts
laptop-detect
libatk1.0-0
libatm1
libavahi-client3
libavahi-common-data
libavahi-common3
libcairo2
libclass-accessor-perl
libcups2
libcwidget3
libdatrie1
libdirectfb-1.2-9
libdjvulibre-dev
libdjvulibre-text
libdjvulibre21
libdrm-intel1
libdrm-nouveau2
libdrm-radeon1
libept1.4.12
libgd2-noxpm-dev
libgpm2
libgraphviz-dev
libgtk-3-0
libgtk-3-common
libilmbase-dev
libilmbase6
libio-string-perl
libnl-3-200
libopenexr-dev
libopenexr6
libpango1.0-0
libparse-debianchangelog-perl
libpixman-1-0
libsub-name-perl
libthai-data
libthai0
libts-0.0-0
libxapian22
libxcb-render-util0
libxcb-render0
libxcomposite1
libxcursor1
libxdamage1
libxfixes3
libxft2
libxi6
libxinerama1
libxrandr2
libxrender1
libxt-dev
libxt6
shared-mime-info
tasksel
tasksel-data
tsconf
ttf-dejavu-core
"

## Pulled from Diego Trusty rootfs
packages_copied_from_diego_trusty_script="
cron
fakeroot
less
libicu-dev
libyaml-dev
manpages
manpages-dev
python
"

packages_copied_from_lucid_script="
bind9-host
bison
build-essential
ca-certificates
curl
dnsutils
flex
fuse-emulator-utils
gdb
git-core
gnupg-curl
graphicsmagick-libmagick-dev-compat
imagemagick
iputils-arping
libaio1
libbz2-dev
libcap2-bin
libcurl3
libcurl3-dev
libfuse-dev
libfuse2
libmysqlclient-dev
libncurses5-dev
libpq-dev
libreadline6-dev
libsasl2-modules
libsigc++-2.0-0c2a
libsqlite-dev
libsqlite3-dev
libssl-dev
libsysfs2
libxml2
libxml2-dev
libxslt1-dev
libxslt1.1
lsof
lzma
ocaml-base-nox
openssh-server
openssl
psmisc
quota
rsync
sshfs
strace
sysstat
tcpdump
traceroute
unzip
wget
zip
"

cat > /etc/apt/sources.list <<EOS
deb http://archive.ubuntu.com/ubuntu $DISTRIB_CODENAME main universe multiverse
deb http://archive.ubuntu.com/ubuntu $DISTRIB_CODENAME-updates main universe multiverse
deb http://security.ubuntu.com/ubuntu $DISTRIB_CODENAME-security main universe multiverse
EOS

# install gpgv so we can update
apt_get install gpgv
apt_get update
apt_get dist-upgrade
apt_get install $packages_copied_from_lucid_script $packages_from_lucid_debootstrap $packages_copied_from_diego_trusty_script ubuntu-minimal

apt-get clean

rm -rf /usr/share/doc/* /usr/share/man/* /usr/share/groff/* /usr/share/info/* /usr/share/lintian/* /usr/share/linda/*
