rm -rf files/bin
mkdir -p files/bin
wget --no-check-certificate 'https://kprule.com/kp.dat' -O files/usr/share/koolproxy/data/rules/kp.dat
wget --no-check-certificate 'https://kprule.com/koolproxy.txt' -O files/usr/share/koolproxy/data/rules/koolproxy.txt
wget --no-check-certificate 'https://kprule.com/daily.txt' -O files/usr/share/koolproxy/data/rules/daily.txt
wget --no-check-certificate 'https://kprule.com/user.txt' -O files/usr/share/koolproxy/data/rules/user.txt
wget --no-check-certificate 'https://koolproxy.com/downloads/arm' -O files/bin/arm
wget --no-check-certificate 'https://koolproxy.com/downloads/i386' -O files/bin/i386
wget --no-check-certificate 'https://koolproxy.com/downloads/mips' -O files/bin/mips
wget --no-check-certificate 'https://koolproxy.com/downloads/mipsel' -O files/bin/mipsel
wget --no-check-certificate 'https://koolproxy.com/downloads/x86_64' -O files/bin/x86_64
gzip files/bin/arm
gzip files/bin/i386
gzip files/bin/mips
gzip files/bin/mipsel
gzip files/bin/x86_64
#chmod +x files/bin/*

wget --no-check-certificate https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt -O- | grep ^\|\|[^\*]*\^$ | sed -e 's:||:address\=\/:' -e 's:\^:/0\.0\.0\.0:' > files/usr/share/koolproxy/dnsmasq.adblock
sed -i '/youku/d' files/usr/share/koolproxy/dnsmasq.adblock
#sed -i '/[1-9]\{1,3\}\.[1-9]\{1,3\}\.[1-9]\{1,3\}\.[1-9]\{1,3\}/d' files/usr/share/koolproxy/dnsmasq.adblock
