## SETUP DEMONSTRATION

Create a virtual machine (Ubuntu 22.04) with a public ip address.
Create NS and A records in domain provider 
![Screenshot 2025-04-23 175831](https://github.com/user-attachments/assets/b3064459-7aeb-464c-b9e1-9194366fbd4a)


### DGA Traffic

#### SERVER :

INSTALL THE FOLLOWING: 
- CoreDNS
- doh-server

#### doh-server Setup: 

Install certificates for your domain (dohe.live)
![certbot](https://github.com/user-attachments/assets/ad248292-9967-477d-ae15-f8080071bf50)

Renew certificates if expired 
![certbot renew](https://github.com/user-attachments/assets/a1c68d5c-9d78-40a2-96ab-30ab560955f2)

It will create cert files here:
/etc/letsencrypt/live/dohe.live/fullchain.pem
/etc/letsencrypt/live/dohe.live/privkey.pem

Add these to doh-server.conf 
![doh-server conf](https://github.com/user-attachments/assets/9e4eca4b-a5c7-4392-8591-83e9a1c27dae)

Run doh-server:
![dns-over-https server logging](https://github.com/user-attachments/assets/cd54e33d-62d1-4871-9f80-540d27576d90)

It will show logs for resolved DoH queries when DGA script is running on the client.
![dns-over-https server logging](https://github.com/user-attachments/assets/f7761a08-b81f-4c67-8959-886b1aab6615)


#### CoreDNS Setup:

Create Corefile:
![corefile for dga](https://github.com/user-attachments/assets/f3deaa74-3b95-417c-846c-da14783c9e41)

Run Coredns: 
![coredns dga logging](https://github.com/user-attachments/assets/ae8c57fd-bc97-4ddf-bfe8-fb79ec9414f4)

It will show logs for DNS queries.

#### CLIENT :

INTSALL THE FOLLOWING:
- Adguard dns proxy
- Domain Generation Algorithms and dns_query scripts
- Wireshark 

#### Adguard dns proxy: 

Run proxy using following command:
![adguard cmd dga](https://github.com/user-attachments/assets/8443a9e7-5d7d-410a-9918-4dc59f19e07a)
This runs dnsproxy on localhost port 45 through which all DGA queries are forwarded to our server dohe.live

#### DGA Scripts:

Run the dns_query.bat file in Windows system. This sends DGA queries to our server for long durations.
![dns_query bat ](https://github.com/user-attachments/assets/7b5f3232-4cdb-481b-9b21-3a96874e48b8)

#### OVERALL SETUP :
![dga setup](https://github.com/user-attachments/assets/96c59d3f-4c3e-4a2d-a3ca-c2c48cb33d4d)

#### Wireshark:

Run Wireshark with following filter to capture DGA traffic being sent to our server IP
![wireshark filter for dga](https://github.com/user-attachments/assets/3b313546-8b4d-4d71-b24d-d8db03f40deb)


### DNSExfiltrator (DNS TUNNELING TOOL)

#### SERVER :

INSTALL THE FOLLOWING :
- CoreDNS
- doh-server
- DNSExfiltrator

#### CoreDNS config :

create zone file in /etc/coredns:
![coredns db file](https://github.com/user-attachments/assets/6dc54e02-35e4-487f-ae3a-9618eb86df12)

create Corefile:
![corefile for dns tunneling](https://github.com/user-attachments/assets/56c0895c-bfc8-4f9c-a53a-e0c23a5baf56)

run coredns: 
![coredns tunnel dohe live resolved](https://github.com/user-attachments/assets/8d5b5584-6e57-46f3-a66f-68414ea8f0cc)

Check if everything is running correctly by searching up tunnel.dohe.live
![tunnel dohe live dig ](https://github.com/user-attachments/assets/3d8c8d22-5778-4a85-b27d-f2c9978b0fa2)
It resolves tunnel.dohe.live to server IP.

#### doh-server :

Run doh-server: It logs all the DNS requests received by client which are of the following format - <data>.tunnel.dohe.live
![doh server dnsexfil logging](https://github.com/user-attachments/assets/a006d828-f46a-460c-a57f-c6af04706003)


#### DNSExfiltrator :

Run the DNSExfiltrator server which listens and decodes data sent from client:
![dnsexfil_server recieve](https://github.com/user-attachments/assets/9d868ab0-43c7-49b4-a58e-9e57123c2f93)


#### CLIENT:

INSTALL THE FOLLOWING:
- Adguard dns proxy
- DNSExfiltrator
- dnsexfil scripts
- Wireshark

#### Adguard dns proxy:

Run the dns proxy:
![adguard cmd dnsexfil](https://github.com/user-attachments/assets/b3448ba4-78c0-4c5e-8297-8cfce31fca5a)

Check if tunnel.dohe.live is being resolved to server IP :
![tunnel dohe live dig ](https://github.com/user-attachments/assets/950baec8-1ec2-4115-91a8-447d460bc1ca)

#### dnsexfil Scripts:

Run the gen_data.ps1 script inside DNSExfiltrator/release folder.
This generates 100 txt files in the same directory
![gen_data start](https://github.com/user-attachments/assets/17dbddc2-5915-4c12-92cb-cdc5440d06a6)
![gen_data end](https://github.com/user-attachments/assets/c100b262-77de-4e7d-ab70-ad3c70fd57d9)

Run the exfil_data.ps1 script which sends the TXT files encrypted in DNS requests.
![dnsexfil_client send](https://github.com/user-attachments/assets/f8c55ba9-f982-487e-972f-6fccbefd5fc7)

#### Wireshark:

Run Wireshark with following filter:
![wireshark filter for dnsexfiltrator](https://github.com/user-attachments/assets/7eabb859-de98-481d-9e86-436f139202ac)

This captures all DNSExfiltrator traffic which is being sent through Adguard dns server (94.140.14.14)



### DoHlyzer :

Send the pcap files through Dohlyzer to obtain CSV's

![dohlyzer](https://github.com/user-attachments/assets/4dc3fe5a-f4fb-4831-bd24-4cc26b3270c9)



## SAMPLE PCAP:

![image](https://github.com/user-attachments/assets/a99a81ca-5946-4736-8fa1-2b72ddfe7151)


## SAMPLE CSV: 

![csv](https://github.com/user-attachments/assets/96bd4608-6ee6-40b0-8659-90cc3ba928ae)

