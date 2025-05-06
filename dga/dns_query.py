import os
import glob
import re
import dns.resolver
from striprtf.striprtf import rtf_to_text

def extract_text_from_rtf(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        rtf_content = f.read()
    return rtf_to_text(rtf_content)

def extract_domains(text):
    domain_pattern = r'\b(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}\b'
    return re.findall(domain_pattern, text)

def query_domains_locally(domains, source_file):
    resolver = dns.resolver.Resolver(configure=False)
    resolver.nameservers = ['127.0.0.1']
    resolver.port = 45

    for domain in set(domains):
        try:
            answers = resolver.resolve(domain, 'A')
            for rdata in answers:
                print(f"[{source_file}] {domain} -> {rdata.address}")
        except Exception as e:
            print(f"[{source_file}] {domain} -> Error: {e}")

def process_all_rtf_files(folder_path):
    rtf_files = glob.glob(os.path.join(folder_path, '*.rtf'))
    for rtf_file in rtf_files:
        print(f"\n📄 Processing: {rtf_file}")
        text = extract_text_from_rtf(rtf_file)
        domains = extract_domains(text)
        query_domains_locally(domains, os.path.basename(rtf_file))

# Main
if __name__ == "__main__":
    folder = "dga_domains"  # Your folder containing .rtf files
    process_all_rtf_files(folder)
