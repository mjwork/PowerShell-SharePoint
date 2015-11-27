Add-PSSnapin Microsoft.SharePoint.PowerShell

Start-SPAssignment -global

$results = @()
$inputPath = "C:\Temp\SharePointSitesList.csv"
$outputPath = "C:\Temp\DocLibrariesStructure.csv"
$sharepointSitesList = Get-Content $inputPath

ForEach($siteUrl in $sharepointSitesList)
{
    ("Processing site: " + $siteUrl)
    Get-SPWeb -Identity $siteUrl | ForEach-Object {

        foreach($docLib in $_.Lists | where {$_.BaseTemplate -eq "DocumentLibrary"}) 
        {
            $results += ($docLib | Select-Object -Property @{Name="SiteUrl"; Expression = {$siteUrl}}, @{Name="Path"; Expression = {$_.RootFolder}})
            $folders = $docLib.Folders
            $results += ($folders | Select-Object -Property @{Name="SiteUrl"; Expression = {$siteUrl}}, @{Name="Path"; Expression = {$_.Url}})
        }
    }
}

$results | Export-Csv -Path $outputPath -NoTypeInformation

Stop-SPAssignment -global
