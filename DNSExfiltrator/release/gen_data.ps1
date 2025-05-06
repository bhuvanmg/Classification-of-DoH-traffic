# Parameters
$folder = ".\texts"
$fileCount = 100
$linesPerFile = 10
$charsPerLine = 60

# Ensure target folder exists
if (-Not (Test-Path $folder)) {
    New-Item -ItemType Directory -Path $folder | Out-Null
}

# Function to generate random strings
function Get-RandomString($length) {
    $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    -join ((1..$length) | ForEach-Object { $chars | Get-Random -Count 1 })
}

# Create files
for ($i = 1; $i -le $fileCount; $i++) {
    $fileName = "file_$i.txt"
    $filePath = Join-Path $folder $fileName

    $content = for ($j = 1; $j -le $linesPerFile; $j++) {
        Get-RandomString -length $charsPerLine
    }

    $content | Set-Content -Path $filePath
    Write-Host "Created: $filePath"
}

Write-Host "Finished generating $fileCount random text files in '$folder'."
