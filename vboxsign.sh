#!/bin/bash
# Sign and load VirtualBox modules
# https://www.majlovesreg.one/tag/code/
# https://www.majlovesreg.one/thoughts/sign-virtualbox-on-ubuntu-16-04-with-secure-boot-enabled/

# Run as root
[ "$(whoami)" = root ] || exec sudo "$0" "$@"

# Set working directory
dir=$SSL_SIGN_KEYS
cd $dir

# (Optional) Setting env KBUILD_SIGN_PIN for encrypted keys
printf "Please enter key passphrase (leave blank if not needed): "
read -s
export KBUILD_SIGN_PIN="$REPLY"

# (Optional) Decrypt private key. To initially encrypt, run `gpg -c MOK.priv` then shred MOK.priv
#gpg -d --batch --passphrase-file /owned/by/root/.pass MOK.priv.gpg > MOK.priv
echo

# Sign and load modules
for module in vboxdrv vboxnetflt vboxnetadp vboxpci; do
	[ "$(hexdump -e '"%_p"' $(modinfo -n $module) | tail | grep signature)" ] && echo -e "\e[93mModule $module is already signed. Skipping.\e[0m" || /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n $module)
	printf "$module: "
	echo $(hexdump -e '"%_p"' $(modinfo -n $module) | tail | grep signature)
	modprobe $module && echo -e "\e[92m$module successfully loaded\e[0m" || echo -e "\e[91mFailed to load $module\e[0m"
done

# (Optional) Shred private key
echo
#shred -vfuz MOK.priv
