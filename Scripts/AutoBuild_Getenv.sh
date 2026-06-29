#!/bin/bash
# AutoBuild Module by Xinb/Xinbyte <https://github.com/xopenwrt/X-OpenWrt-New>
# AutoBuild Functions
Get_Action_Info() {
echo "---------------------------- Soc Info | 🏅AMD Yes ----------------------------"
lscpu | grep "Model name" 
lscpu | grep "CPU(s)" 
echo "--------------------------------- Memory Info --------------------------------"
free -m
echo "---------------------------------- Disk Info ---------------------------------"
lsblk
echo "------------------------------- Disk Usage Info ------------------------------"
df -h


# Get IP Info
echo "------------------------------- IP Address Info ------------------------------"
IP="$(curl --connect-timeout 5 --max-time 10 -fsS ip.115115.xyz 2>/dev/null || true)"
printf "%s\n" "${IP}"
# curl -s https://searchplugin.csdn.net/api/v1/ip/get?ip=${IP} | jq -r .data.address
[ -n "${IP}" ] && curl --connect-timeout 5 --max-time 10 -fsS "https://api.vore.top/api/IPdata?ip=${IP}" 2>/dev/null | jq -r .adcode.o || true
}

Get_Release_Info() {
echo "------------------------------- Build Version Data ----------------------------"
echo ${NOW_DATA_VERSION}
echo "------------------------------ Build Kernel Version ---------------------------"
grep "KERNEL_PATCHVER:=" "${OPENWRT_BUILD_DIR}/target/linux/x86/Makefile"

}