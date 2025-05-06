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

## 🛠️ Installation


### DNSExfiltrator setup

### Server 

DNSExfiltrator is a proof-of-concept (PoC) tool designed to demonstrate how data can be exfiltrated over the DNS protocol. It works by encoding data into DNS queries, which are sent to an attacker-controlled domain. A DNS server controlled by the attacker decodes the incoming queries and reconstructs the original data.
This technique is commonly used in real-world scenarios where traditional outbound channels (HTTP, FTP, etc.) are monitored or blocked, but DNS traffic is still permitted. DNSExfiltrator helps simulate this behavior for research, detection, and defense testing.

In this project, DNSExfiltrator is used to generate labeled examples of DNS tunneling traffic. We use DNSExfiltrator to send 100 txt files over DNS to our remote server. We use DNS-over-HTTPS (DoH) protocol to send data. 

#### Requirements

- DNS Server and Domain (we used dohe.live and tunnel.dohe.live for dga and dns tunneling respectively)
- DNSExfiltrator 
- dnsproxy
- doh-server
- Coredns


```bash
git clone https://github.com/yourusername/dns-traffic-classification.git
cd dns-traffic-classification
