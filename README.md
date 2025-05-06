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

Clone the repository:

```bash
git clone https://github.com/yourusername/dns-traffic-classification.git
cd dns-traffic-classification
