#!/bin/sh
echo "$(date "+%F %T"): 正在下载userlist..vokins.."
curl -k -s https://raw.githubusercontent.com/vokins/yhosts/master/dnsmasq/union.conf > /tmp/vokins
if [ "Z$?" == "Z0" ]; then
	echo "$(date "+%F %T"): vokins去广告规则下载完成.."
	sed -i "s?address\=\/\.?address\=\/?" /tmp/vokins >/dev/null 2>&1
	sed -i '/qq.com/d' /tmp/vokins >/dev/null 2>&1
	sed -i '/youku/d' /tmp/vokins >/dev/null 2>&1
	sed -i '/#/d' /tmp/vokins >/dev/null 2>&1
	sed -i '$d' /tmp/vokins >/dev/null 2>&1
	cat /tmp/vokins > /tmp/userlist.conf
	sed -i '1,1d' /tmp/userlist.conf >/dev/null 2>&1
	rm -f /tmp/vokins
	if ( ! cmp -s /tmp/userlist.conf /usr/share/koolproxy/userlist.conf ); then
		echo "$(date "+%F %T"): vokins 规则有更新,开始转换规则!"
		mv /tmp/userlist.conf /usr/share/koolproxy/userlist.conf
		echo "$(date "+%F %T"): vokins 规则转换完成,应用新规则!"
		/etc/init.d/dnsmasq restart >/dev/null 2>&1
	else
		echo "$(date "+%F %T"): vokins 本地规则和在线规则相同,无需更新!"
		rm -f /tmp/userlist.conf && exit
	fi
else
	echo "$(date "+%F %T"): 获取在线规则时出现错误!"
	[ -f /tmp/vokins ] && rm -f /tmp/vokins
fi
