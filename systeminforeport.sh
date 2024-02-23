#!bin/bash
#System Report generated by USERNAME, DATE/TIME

#System Information
echo "System Information"
echo "------------------"
echo "Hostname: $(hostname)"
echo "OS: $(lsb_release -d | cut -f2)"
echo "Uptime: $(uptime -p)"
echo

#Hardware Information
echo "Hardware Information"
echo "--------------------"
echo "CPU: $(lscpu | grep "Model name" | awk -F: '{print $2}' | sed 's/ //')"
echo "Speed: $(lscpu | grep "CPU MHz" | awk -F: '{print $2}' | sed 's/ //') MHz (Max: $(lscpu | grep "CPU max MHz" | awk -F: '{print $2}' | sed 's/ //') MHz)"
echo "RAM: $(free -h | grep Mem | awk '{print $2}')"
echo "Disk(s): $(lsblk -o NAME, MODEL, SIZE | grep -v "NAME")"
echo "Video: $(lspci | grep VGA | awk -F": " '{print $3}')"
echo

#Network Information
echo "Network Information"
echo "-------------------"
echo "FQDN: $(hostname --fqdn)"
echo "Host Address: $(hostname -I | cut -d' ' -f1)"
echo "Gateway IP: $(ip route show | grep default | awk '{print $3}')"
echo "DNS Server: $(grep "DNS Servers" /etc/resolv.conf | awk '{print $2}')"
echo

#Interface Information
echo "Interface Information"
echo "---------------------"
echo "InterfaceName: $(ip -o link show | awk -F': ' '{print $2}' | sed 's/ //')"
echo "IP Address: $(ip -o -4 addr show | awk '{print $4}')"
echo

#System Status
echo "System Status"
echo "-------------"
echo "Users Logged In: $(who | cut -d' ' -f1 | sort | uniq | tr '\n' ', ' | sed 's/, $//')"
echo "Disk Space:"
df -h --output=source,avail | grep -v "source"
echo "Process Count: $(ps -A --no-headers | wc -l)"
echo "Load Averages: $(cat /proc/loadavg | awk '{print $1", "$2", "$3}')"
echo "Memory Allocation: $(free -h | grep Mem | awk '{print $3"/"$2}')"
echo "Listening Network Ports: $(ss -tuln | grep "LISTEN" | awk '{print $4}' | awk -F":"'{print $NF}' | sort -n | uniq | tr '\n' ', ' | sed 's/, $//')"
echo "UFW Rules: $(sudo ufw status numbered)"

#Output report
cat <<EOF

echo "System Report generated by $(whoami), today is `date +%D-%T`"
EOF