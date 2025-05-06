## DoHLyzer Setup 

Requirements:  
Python - 3.10.12  
system - Ubuntu  

```bash
sudo apt install -y python3.10-venv
python3 -m venv dohlyzer
source ~/boosting/bin/activate
```

```bash
git clone https://github.com/bhuvanmg/Classification-of-DoH-traffic.git
cd DoHLyzer
pip install .
```

Usage: 

```bash
python dohlyzer.py -f <pcap file> -c <output csv>
```

## Feature List

| Parameter | Feature Description |
|-----------|---------------------|
| **F1**    | Number of flow bytes sent |
| **F2**    | Rate of flow bytes sent |
| **F3**    | Number of flow bytes received |
| **F4**    | Rate of flow bytes received |
| **F5**    | Variance of packet length |
| **F6**    | Standard deviation of packet length |
| **F7**    | Mean packet length |
| **F8**    | Median packet length |
| **F9**    | Mode packet length |
| **F10**   | Skew from median packet length |
| **F11**   | Skew from mode packet length |
| **F12**   | Coefficient of variation of packet length |
| **F13**   | Variance of packet time |
| **F14**   | Standard deviation of packet time |
| **F15**   | Mean packet time |
| **F16**   | Median packet time |
| **F17**   | Mode packet time |
| **F18**   | Skew from median packet time |
| **F19**   | Skew from mode packet time |
| **F20**   | Coefficient of variation of packet time |
| **F21**   | Variance of request/response time difference |
| **F22**   | Standard deviation of request/response time difference |
| **F23**   | Mean request/response time difference |
| **F24**   | Median request/response time difference |
| **F25**   | Mode request/response time difference |
| **F26**   | Skew from median request/response time difference |
| **F27**   | Skew from mode request/response time difference |
| **F28**   | Coefficient of variation of request/response time difference |
