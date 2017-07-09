#!/bin/sh
echo "$(date "+%F %T"): 正在下载adblockplus规则..."
#wget-ssl --quiet --no-check-certificate https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt -O /tmp/adlist.txt
curl -k -s https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt | grep ^\|\|[^\*]*\^$ | sed -e 's:||:address\=\/:' -e 's:\^:/0\.0\.0\.0:' > /tmp/easylistchina
if [ "$?" == "0" ]; then
	#grep ^\|\|[^\*]*\^$ /tmp/adlist.txt | sed -e 's:||:address\=\/:' -e 's:\^:/0\.0\.0\.0:' > /tmp/dnsmasq.adblock
	#rm -f /tmp/adlist.txt
	curl -k -s https://raw.githubusercontent.com/vokins/yhosts/master/dnsmasq/union.conf > /tmp/vokins
	sed -i "s?address\=\/\.?address\=\/?" /tmp/vokins >/dev/null 2>&1
	sed -i '/qq.com/d' /tmp/vokins >/dev/null 2>&1
	sed -i '/youku/d' /tmp/vokins >/dev/null 2>&1
	sed -i '/#/d' /tmp/vokins >/dev/null 2>&1
	sed -i '$d' /tmp/vokins >/dev/null 2>&1

	sort -u /tmp/easylistchina /tmp/vokins > /tmp/dnsmasq.adblock
	rm -f /tmp/easylistchina /tmp/vokins
	sed -i '/#/d' /tmp/dnsmasq.adblock >/dev/null 2>&1
	sed -i '$d' /tmp/dnsmasq.adblock >/dev/null 2>&1
	sed -i '/youku/d' /tmp/dnsmasq.adblock >/dev/null 2>&1
	sed -i '/[1-9]\{1,3\}\.[1-9]\{1,3\}\.[1-9]\{1,3\}\.[1-9]\{1,3\}/d' /tmp/dnsmasq.adblock >/dev/null 2>&1
	sed -i '1,1d' /tmp/dnsmasq.adblock >/dev/null 2>&1
	diff /tmp/dnsmasq.adblock /usr/share/koolproxy/dnsmasq.adblock >/dev/null
	[ $? = 0 ] && echo "$(date "+%F %T"): adblockplus本地规则和服务器规则相同，无需更新!" && rm -f /tmp/dnsmasq.adblock && exit
	echo "$(date "+%F %T"): 检测到adblockplus规则有更新，开始转换规则！"
	sed -i '/youku/d' /tmp/dnsmasq.adblock >/dev/null 2>&1
	sed -i '/[1-9]\{1,3\}\.[1-9]\{1,3\}\.[1-9]\{1,3\}\.[1-9]\{1,3\}/d' /tmp/dnsmasq.adblock >/dev/null 2>&1
	mv /tmp/dnsmasq.adblock /usr/share/koolproxy/dnsmasq.adblock
	echo "$(date "+%F %T"): adblockplus规则转换完成，应用新规则。"
	/etc/init.d/dnsmasq restart >/dev/null 2>&1
else
	echo "$(date "+%F %T"): 获取在线版本时出现错误! "
	[ -f /tmp/adlist.txt ] && rm -f /tmp/adlist.txt
fi
