import subprocess
import os
import json
import re
import sys

# Color codes
w = "\033[0;37m"
m = "\033[0;37m"
b = "\033[38;5;14m"
r = "\033[0;31m"
g = "\033[0;32m"
r1 = "\033[0;91m"
o = "\033[0;33m"

# Function to get CPU information
def get_cpu_info():
    result = subprocess.check_output(["awk", "-F", ': ', '/^model name/ {print $2; exit;}', "/proc/cpuinfo"])
    return result.decode().strip()

# Function to get CPU temperature
def get_cpu_temperature():
    try:
        result = subprocess.check_output(["awk", '{printf "%.0f", $1/1000}', "/sys/class/thermal/thermal_zone0/temp"])
        return result.decode().strip()
    except Exception:
        return "N\A"

# Function to calculate uptime
def get_uptime():
    result = subprocess.check_output(["cut", "-f1", "-d.", "/proc/uptime"])
    uptime = float(result.decode().strip())
    updays = int(uptime / 60 / 60 / 24)
    uphours = int(uptime / 60 / 60 % 24)
    upmins = int(uptime / 60 % 60)
    upsec = int(uptime % 60)
    return updays, uphours, upmins, upsec

# Function to get system information
def get_system_info():
    kernel = os.uname().release
    hostname = os.uname().nodename
    users = 1
    #users = len(os.getusers())
    la = ' '.join(os.popen('cat /proc/loadavg').read().split()[:3])
    return kernel, hostname, users, la

# Function to calculate RAM usage
def get_swap_usage():
    swap_info = subprocess.check_output(["swapon", "-s"]).decode().split('\n')[1:]
    total_size_mb = 0
    total_used_mb = 0
    for i in swap_info:
        swap = i.split()
        if len(swap) == 5:
            total_size_mb += int(swap[2])
            total_used_mb += int(swap[3])

    total_size_gb = round((total_size_mb) / 1048576, 2)
    total_used_gb = round((total_used_mb) / 1048576, 2)

    usage = round((total_used_gb * 100) / total_size_gb)

    return total_used_gb, total_size_gb, usage



# Function to calculate RAM usage
def get_ram_usage():
    result = subprocess.check_output(["free", "-m"])
    size_ram_mb = int(result.decode().split('\n')[1].split()[1])
    used_ram_mb = int(result.decode().split('\n')[1].split()[2])

    total_size_gb = round((size_ram_mb / 1024), 2)
    total_used_gb = round((used_ram_mb / 1024), 2)

    usage = round(((total_used_gb * 100) / total_size_gb), 2)

    return total_size_gb, total_used_gb, usage


# Function to save RAM usage bar
def save_ram_bar(total_used_gb, total_size_gb, usage):
    total_slots = 20
    filled_slots = int((usage * total_slots) / 100)
    empty_slots = total_slots - filled_slots

    #bar = "[" + "█" * filled_slots + "░" * empty_slots + f"] {usage}% [{total_used_gb} / {total_size_gb} Gb]"

    if int(usage) > 80:
        bar = r1 + "[" + "|" * filled_slots + " " * empty_slots + f"] {usage}% [{total_used_gb} / {total_size_gb} Gb]"
    elif int(usage) > 50:
        bar = o + "[" + "|" * filled_slots + " " * empty_slots + f"] {usage}% [{total_used_gb} / {total_size_gb} Gb]"
    else:
        bar = g + "[" + "|" * filled_slots + " " * empty_slots + f"] {usage}% [{total_used_gb} / {total_size_gb} Gb]"

    return bar

# Function to get IP addresses
def parse_ip_a(output):
    interfaces = []
    current_interface = None

    for line in output.split('\n'):
        line = line.strip()
        if not line:
            continue

        if line[0].isdigit():
            if current_interface:
                interfaces.append(current_interface)
            parts = line.split()
            current_interface = {'name': parts[1][:-1], 'ips': []}
        elif line.startswith('inet '):
            ip_match = re.search(r'inet (\d+\.\d+\.\d+\.\d+)/(\d+)', line)
            if ip_match:
                current_interface['ips'].append( (ip_match.group(1), ip_match.group(2)) )

    if current_interface:
        interfaces.append(current_interface)

    return interfaces

def get_ip_addresses():
    result = subprocess.check_output(["ip", "a"])
    return parse_ip_a(result.decode())

# Function to print IP addresses
def print_ip_addresses(ip_addresses):
    print(f"\n{w}*{b} Interfaces:")
    print(f"\tNIC\t\tIP")
    for iface in ip_addresses:
        if len(iface['ips']) == 1:
            if not iface['name'] == 'lo':
                print(f"\t{g}{iface['name']: <16}{m}{iface['ips'][0][0]}\t/{iface['ips'][0][1]}")

# Function to get Tailscale information
def get_tailscale_info():
    result = subprocess.check_output(["tailscale", "status", "-json"])
    data = json.loads(result.decode())
    return data

# Function to print Tailscale information
def print_tailscale_info(peers):
    print(f"\n{w}*{b} Tailscale:")
    print(f"\t\t\tIP\t\t\tDNS{w}")
    
    sf = peers.get("Self", {})
    print("\t\t\t{}\t\t{}\n".format(sf.get("TailscaleIPs")[0], sf.get("DNSName")[:-1]))

    for peer_id, peer_info in peers.get('Peer', {}).items():
        tailscale_ips = peer_info.get('TailscaleIPs', [])
        online_status = peer_info.get('Online', False)
        dns_name = peer_info.get('DNSName', '')

        if tailscale_ips and online_status:
            tailscale_ip = tailscale_ips[0]
            #print(f"\t\t\t{tailscale_ip}\t\t{online_status}\t{dns_name}")
            print(f"\t\t\t{tailscale_ip}\t\t{dns_name[:-1]}")



# Function to check internet connectivity
def check_internet():
    result = os.system("timeout 0.2 ping -c 1 1.1.1.1 > /dev/null 2>&1")
    return f"{g}OK" if result == 0 else f"{r}Fail"

# Function to print internet information
def print_internet_info():
    istate = "\n{}*{} Internet: {}".format(w, b, check_internet())
    print(istate)
    if not "Fail" in istate:
        inet = subprocess.check_output(['ip', '-j', 'r', 'get', '1.1.1.1']).decode().splitlines()[0]
        inet = json.loads(inet)
        print(f"{w}{inet[0]['prefsrc']} @ {inet[0]['dev']} via {inet[0]['gateway']}")

def main():
    # Gather system information
    cpu = get_cpu_info()
    if "workstation" in sys.argv:
        cputemp = get_cpu_temperature()
    updays, uphours, upmins, upsec = get_uptime()
    kernel, hostname, users, uptime = get_system_info()

    # Gather RAM information
    total_ram_size_gb, total_ram_used_gb, ram_usage = get_ram_usage()
    ram_bar = save_ram_bar(total_ram_used_gb, total_ram_size_gb, ram_usage)

    # Gather SWAP information
    total_swap_size_gb, total_swap_used_gb, swap_usage = get_swap_usage()
    swap_bar = save_ram_bar(total_swap_size_gb, total_swap_used_gb, swap_usage)

    # Gather IP addresses
    ip_addresses = get_ip_addresses()

    # Gather Tailscale information
    if "workstation" in sys.argv:
        tailscale_peers = get_tailscale_info()

    # Print system information
    #print(f"\n{w}*{b} Welcome Back {m}{os.getlogin()}")
    print(f"{w}*{b} Hostname: {m}{hostname}")
    if "workstation" in sys.argv:
        print(f"{w}*{b} CPU: {m}{cpu}{b} CPU Temp: {m}{cputemp}°C")
    else:
        print(f"{w}*{b} CPU: {m}{cpu}{b}")
    print(f"{w}*{b} Uptime: {m}{updays} days {uphours} hours {upmins} minutes {upsec} seconds")
    print(f"{w}*{b} Load Avg. {m}{uptime}")
    print(f"{w}*{b} Memory: {m}{ram_bar}")
    print(f"{w}*{b} Swap:   {m}{swap_bar}")
    #print(f"{w}*{b} Kernel: {m}{kernel}")
    #print(f"{w}*{b} Users logged in: {m}{users}")

    # Print IP addresses
    print_ip_addresses(ip_addresses)

    # Print Tailscale information\
    if "workstation" in sys.argv:
        print_tailscale_info(tailscale_peers)

    # Print internet information
    print_internet_info()

if __name__ == "__main__":
    main()

