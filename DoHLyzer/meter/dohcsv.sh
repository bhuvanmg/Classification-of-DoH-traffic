#!/bin/bash

# Adjust range as needed
start=13
end=13  # Replace with highest file number

for i in $(seq $start $end); do
    pcap_file="./dnsexfil_${i}doh.pcap"
    csv_file="./dnsexfil_${i}.csv"

    if [[ -f "$pcap_file" ]]; then
        echo "Analyzing $pcap_file -> $csv_file"
        python dohlyzer.py -f "$pcap_file" -c "$csv_file"
    else
        echo "File $pcap_file not found, skipping."
    fi
done
