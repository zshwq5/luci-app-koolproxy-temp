#!/bin/sh
echo "$(date "+%F %T"): 正在下载adblockplus规则...."
curl -k -s https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt | grep ^\|\|[^\*]*\^$ | sed -e 's:||:address\=\/:' -e 's:\^:/0\.0\.0\.0:' > /tmp/dnsmasq.adblock
	if [ "Z$?" == "Z0" ]; then
		sed -i '/youku/d' /tmp/dnsmasq.adblock >/dev/null 2>&1
		sed -i '/[1-9]\{1,3\}\.[1-9]\{1,3\}\.[1-9]\{1,3\}\.[1-9]\{1,3\}/d' /tmp/dnsmasq.adblock >/dev/null 2>&1
		if ( ! cmp -s /tmp/dnsmasq.adblock /usr/share/koolproxy/dnsmasq.adblock ); then
			echo "$(date "+%F %T"): 检测到adblockplus规则有更新，开始转换规则！"
			mv /tmp/dnsmasq.adblock /usr/share/koolproxy/dnsmasq.adblock
			echo "$(date "+%F %T"): adblockplus规则转换完成，应用新规则。"
			/etc/init.d/dnsmasq restart >/dev/null 2>&1
		else
			echo "$(date "+%F %T"): adblockplus本地规则和服务器规则相同，无需更新!"
			rm -f /tmp/dnsmasq.adblock
			exit
		fi
	else
		echo "$(date "+%F %T"): 获取在线版本时出现错误! "
		[ -f /tmp/adlist.txt ] && rm -f /tmp/adlist.txt
	fi
