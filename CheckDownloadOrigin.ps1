$downloadsPath = "$env:USERPROFILE\Downloads"
$schoolPath = "$env:USERPROFILE\Documents\Schule"
$schoolDomains = @('https://rbbk-do.de/', 'https://schulendortmund.taskcards.app/')

Get-ChildItem -Path $downloadsPath -File | ForEach-Object {
    $shouldMove = $false
    
    try {
        $stream = Get-Content -Path $_.FullName -Stream Zone.Identifier -ErrorAction Stop
        $urls = ($stream | Select-String -Pattern '(HostUrl|ReferrerUrl)=(.*)$').Matches.Groups[2].Value
        
        if ($urls | Where-Object { $url = $_; $schoolDomains | Where-Object { $url -like "$_*" } }) {
            Write-Host "$($_.Name) Found (Domain Match)" -ForegroundColor Green
            $shouldMove = $true
        }
    }
    catch {
        
    }
    
    if ($shouldMove) {
        Move-Item -Path $_.FullName -Destination $schoolPath -Force
    }
}