$session = New-PSSession -ComputerName BNESP
Invoke-Command -Session $session -ScriptBlock { Add-PSSnapin Microsoft.SharePoint.PowerShell }
Invoke-Command -Session $session -ScriptBlock {
    $results = @()
    Get-SPSite -WebApplication "http://bnesp" -limit All | ForEach-Object {  
        foreach ($w in $_.AllWebs) {
            foreach($docLib in $w.Lists | where {$_.BaseTemplate -eq "DocumentLibrary"}) {
                $docLib.ParentWebUrl
                
                foreach ($folder in $docLib.Folders) {
                    $folder.URL
                }
            }        
        }
    }
}
