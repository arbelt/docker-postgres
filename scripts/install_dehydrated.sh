#!/usr/bin/env bash

set -ex

declare tmpdir="$(mktemp -d)"

#function cleanup {
    #cd /
    #[[ -d "${tmpdir}" ]] && rm -rf "${tmpdir}"
#}

cd "${tmpdir}"

DH_VERSION=0.4.0
DH_SHA256="611da321330ffd43d1dc497990b486b2dec12c59149803ad7d156980c8527f48"

wget --content-disposition https://github.com/lukas2511/dehydrated/archive/v0.4.0.tar.gz

if [[ $(shasum -a 256 dehydrated-${DH_VERSION}.tar.gz | cut -d' ' -f1) != "${DH_SHA256}" ]] 
then
    echo "SHA256 of downloaded file does not match." >&2
    exit 1
fi

tar -xvzf dehydrated-${DH_VERSION}.tar.gz --strip=1
cp dehydrated /usr/local/bin/dehydrated

perl -pi -e 's/^#?(CHALLENGETYPE)=.*/$1="dns-01"/' /etc/dehydrated/config
perl -pi -e 's!^#?(HOOK)=.*!$1="/usr/lib/dehydrated/hook.sh"!' /etc/dehydrated/config

mkdir -p /etc/dehydrated
cp docs/examples/config /etc/dehydrated/config

wget -O /usr/local/bin/cli53 https://github.com/barnybug/cli53/releases/download/0.8.12/cli53-linux-amd64
chmod +x /usr/local/bin/cli53

wget -O /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
chmod +x /usr/local/bin/jq

mkdir -p /usr/lib/dehydrated
wget -O /usr/lib/dehydrated/hook.sh https://raw.githubusercontent.com/arbelt/dehydrated-route53-hook-script/master/hook.sh
chmod +x /usr/lib/dehydrated/hook.sh

#cleanup

