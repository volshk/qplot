import subprocess
import os

def download_files(base_url, file_prefix, file_suffix, start, end, output_dir):
    # Ensure the output directory exists
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    for i in range(start, end + 1):
        file_name = f"{file_prefix}{i}{file_suffix}"
        url = f"{base_url}/{file_name}"
        output_path = os.path.join(output_dir, file_name)
        command = ["curl", "-o", output_path, url]
        print(f"Downloading {file_name} from {url} to {output_path}...")
        subprocess.run(command)
        
# Example usage:
base_url = "https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/supporting/admixture_files"  # Replace with the actual base URL
file_prefix = "ALL.wgs.phase3_shapeit2_filtered.20141217.maf0.05."
file_suffix = ".Q"
start = 5  # Starting numeric character
end = 25   # Ending numeric character

output_dir = "data"  # Output directory

download_files(base_url, file_prefix, file_suffix, start, end, output_dir)
