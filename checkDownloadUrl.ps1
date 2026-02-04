$downloads = Get-ChildItem -Path "C:\Users\pakugbe\Downloads" 
$downloads
foreach ($file in $downloads) {
   if (Test-Path -Path $file -PathType Leaf) {
      if (([regex]::IsMatch($file.Name, '\.(odt|odp|jar|fls|circ|ITU8)$'))) {
         Write-Host "$($file.Name) Found" -ForegroundColor Yellow
         Move-Item -Path $file  -Destination "C:\Users\pakugbe\OneDrive - tegosgroup\Dokumente\SchoolStuffs"
         #New-Item -Path   name   -ItemType
      }
      try {
         $stream = Get-Content -Path $file -Stream Zone.Identifier 
         $HostUrl = ([regex]::Matches([string]$stream, "HostUrl=(.*)$")).Groups[1].Value
         $referralUrl = ([regex]::Matches([string]$stream, "ReferrerUrl=(.*) H")).Groups[1].Value
         #Write-Host $HostUrl
         #Write-Host $referralUrl
         if ($HostUrl.StartsWith("https://rbbk-do.de/") -or $referralUrl.StartsWith("https://schulendortmund.taskcards.app/") ) {
            Write-Host "FOUND!! $($file.Name)" -ForegroundColor Green
            Move-Item -Path $file  -Destination "C:\Users\pakugbe\OneDrive - tegosgroup\Dokumente\SchoolStuffs"
         }

   
      }
      catch {
         Write-Host "$($file.Name) does not contain Stream"
      } 

        
   }
}  
 
#write-host $url.GetType() -ForegroundColor Green


  