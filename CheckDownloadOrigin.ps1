$downloadsPath = "$env:USERPROFILE\Downloads"
$schoolPath = "$env:USERPROFILE\Documents\Schule"
$schoolDomains = @('https://rbbk-do.de/', 'https://schulendortmund.taskcards.app/')

$folderMap = @{
    'Englisch' = 'ENG'
    'EVP' = 'EVP'
    'GIT-T' = 'GIT-T'
    'PGL' = 'PGL'
    'STD' = 'STD'
    'gitwbl' = 'GITWBL'
}

Get-ChildItem -Path $downloadsPath -File | ForEach-Object {
    try {
        $stream = Get-Content -Path $_.FullName -Stream Zone.Identifier -ErrorAction Stop
        $urls = ($stream | Select-String -Pattern '(HostUrl|ReferrerUrl)=(.*)$').Matches.Groups[2].Value
        
        if ($urls | Where-Object { $url = $_; $schoolDomains | Where-Object { $url -like "$_*" } }) {
            $targetFolder = $null
            
            foreach ($key in $folderMap.Keys) {
                if ($urls -match $key) {
                    $targetFolder = Join-Path $schoolPath $folderMap[$key]
                    break
                }
            }
            
            if ($targetFolder) {
                Write-Host "$($_.Name) -> $($folderMap[$key])" -ForegroundColor Green
                Move-Item -Path $_.FullName -Destination $targetFolder -Force
            }
        }
    }
    catch {}
}
