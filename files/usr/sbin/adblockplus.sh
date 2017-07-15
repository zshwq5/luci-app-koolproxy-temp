#!/bin/sh
echo "$(date "+%F %T"): 正在下载adblockplus规则....."
curl -k -s https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt | grep ^\|\|[^\*]*\^$ | sed -e 's:||:address\=\/:' -e 's:\^:/0\.0\.0\.0:' > /tmp/easylistchina
if [ "Z$?" == "Z0" ]; then
	echo "$(date "+%F %T"): easylistchina 下载完成....."
	curl -k -s https://raw.githubusercontent.com/vokins/yhosts/master/dnsmasq/union.conf > /tmp/vokins
	if [ "Z$?" == "Z0" ]; then
		echo "$(date "+%F %T"): vokins去广告规则下载完成...."
		sed -i "s?address\=\/\.?address\=\/?" /tmp/vokins >/dev/null 2>&1
		sed -i '/qq\.com/d' /tmp/vokins >/dev/null 2>&1
		sed -i '/youku/d' /tmp/vokins >/dev/null 2>&1
		sed -i '/#/d' /tmp/vokins >/dev/null 2>&1
		sed -i '$d' /tmp/vokins >/dev/null 2>&1
		sort -u /tmp/easylistchina /tmp/vokins > /tmp/dnsmasq.adblock
		rm -f /tmp/vokins /tmp/easylistchina
		sed -i '/youku\.com/d' /tmp/dnsmasq.adblock
		sed -i '1,1d' /tmp/dnsmasq.adblock >/dev/null 2>&1
		if ( ! cmp -s /tmp/dnsmasq.adblock /usr/share/koolproxy/dnsmasq.adblock ); then
			echo "$(date "+%F %T"): adblockplus 有更新,开始转换规则!"
			mv /tmp/dnsmasq.adblock /usr/share/koolproxy/dnsmasq.adblock
			echo "$(date "+%F %T"): adblockplus  规则转换完成并应用!"
			/etc/init.d/dnsmasq restart >/dev/null 2>&1
		else
			echo "$(date "+%F %T"): adblockplus 本地和在线相同,退出!"
			rm -f /tmp/dnsmasq.adblock
		fi
	else
		echo "$(date "+%F %T"): vokins去广告规则下载出错...."
		if [ -f /tmp/easylistchina ]; then
			rm -f /tmp/easylistchina
		fi
		if [ -f /tmp/vokins ]; then
			rm -f /tmp/vokins
		fi
		exit
	fi
else
	echo "$(date "+%F %T"): 获取 adblockplus 规则时出现错误!"
	if [ -f /tmp/easylistchina ]; then
		rm -f /tmp/easylistchina
	fi
	exit
fi
