## DNS EXFILTRATOR CLIENT SETUP 

After setting up the server and dnsproxy on client side,

Run gen_data.ps1 in powershell:
```powershell
./gen_data.ps1
```
This generates 100 random TXT files in texts folder.

Now Run exfil_data.ps1 in powershell:
```powershell
./exfil_data.ps1
```
This sends the 100 TXT files to our server(tunnel.dohe.live) using DoH and DNS Exfiltrator. 

Capture this traffic using wireshark with following filters:
```bash
ip.addr == 94.140.14.14 && not tcp.port == 22
```

This filters all traffic going through adguard dns server ignoring all ssh connections.
Save the pcaps and use DoHLyzer to convert them to CSV.
