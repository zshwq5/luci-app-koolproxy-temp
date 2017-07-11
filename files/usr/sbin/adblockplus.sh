#!/bin/sh
echo "$(date "+%F %T"): 正在下载adblockplus规则...."
curl -k -s https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt | grep ^\|\|[^\*]*\^$ | sed -e 's:||:address\=\/:' -e 's:\^:/0\.0\.0\.0:' > /tmp/easylistchina
sed -i '/[1-9]\{1,3\}\.[1-9]\{1,3\}\.[1-9]\{1,3\}\.[1-9]\{1,3\}/d' /tmp/easylistchina >/dev/null 2>&1
echo "$(date "+%F %T"): easylistchina 下载完成...."
curl -k -s https://raw.githubusercontent.com/vokins/yhosts/master/dnsmasq/union.conf > /tmp/vokins
	if [ "Z$?" == "Z0" ]; then
		sed -i "s?address\=\/\.?address\=\/?" /tmp/vokins >/dev/null 2>&1
		sed -i '/qq.com/d' /tmp/vokins >/dev/null 2>&1
		sed -i '/#/d' /tmp/vokins >/dev/null 2>&1
		#cat /tmp/vokins >> /tmp/easylistchina
		sort -u /tmp/easylistchina /tmp/vokins > /tmp/dnsmasq.adblock
		rm -f /tmp/vokins /tmp/easylistchina
		sed -i '/youku.com/d' /tmp/dnsmasq.adblock
		sed -i '$d' /tmp/dnsmasq.adblock >/dev/null 2>&1
		sed -i '1,1d' /tmp/dnsmasq.adblock >/dev/null 2>&1
		if ( ! cmp -s /tmp/dnsmasq.adblock /usr/share/koolproxy/dnsmasq.adblock ); then
			echo "$(date "+%F %T"): 检测到 adblockplus 规则有更新，开始转换规则！"
			mv /tmp/dnsmasq.adblock /usr/share/koolproxy/dnsmasq.adblock
			echo "$(date "+%F %T"): adblockplus 规则转换完成，应用新规则。"
			/etc/init.d/dnsmasq restart >/dev/null 2>&1
		else
			echo "$(date "+%F %T"): adblocks 本地规则和在线规则相同，无需更新!"
			rm -f /tmp/dnsmasq.adblock /tmp/vokins
		fi
	else
		echo "$(date "+%F %T"): 获取在线规则时出现错误!"
		[ -f /tmp/easylistchina ] && rm -f /tmp/easylistchina
		[ -f /tmp/vokins ] && rm -f /tmp/vokins
	fi
