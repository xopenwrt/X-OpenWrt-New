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
IP=`curl ip.115115.xyz -s`
curl ip.115115.xyz -s
# curl -s https://searchplugin.csdn.net/api/v1/ip/get?ip=${IP} | jq -r .data.address
Addr_Country=`curl -s "http://demo.ip-api.com/json/${IP}?fields=66842623&lang=zh-CN" | jq -r .country`
Addr_Province=`curl -s "http://demo.ip-api.com/json/${IP}?fields=66842623&lang=zh-CN" | jq -r .regionName`
Addr_City=`curl -s "http://demo.ip-api.com/json/${IP}?fields=66842623&lang=zh-CN" | jq -r .city`
echo "${Addr_Country}, ${Addr_Province}, ${Addr_City}"
}

Get_Release_Info() {
echo "------------------------------- Build Version Data ----------------------------"
echo ${NOW_DATA_VERSION}
echo "------------------------------ Build Kernel Version ---------------------------"
`cat ${OPENWRT_BUILD_DIR}/target/linux/x86/Makefile | grep KERNEL_PATCHVER:=`

}