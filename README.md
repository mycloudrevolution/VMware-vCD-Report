VMware-vCD-Module PowerShell Module
===================================

![Get-vCDReport](/media/Get-vCDReport.png)

# About

## Project Owner:

Markus Kraus [@vMarkus_K](https://twitter.com/vMarkus_K)

MY CLOUD-(R)EVOLUTION [mycloudrevolution.com](http://mycloudrevolution.com/)

## Project WebSite:
[vCloud Director PowerCLI Ressource Usage Report](https://mycloudrevolution.com/2017/07/19/vcloud-director-powercli-ressource-usage-report/)


## Project Description:

The 'VMware-vCD-Report' PowerShell Module creates a HTML or CSV Report of VMware vCloud Director Ressources.

# Functions

## Get-vCDReport

Creates the HTML or CSV Output of VMware vCloud Director Ressources.

PS Console Outpot is only the Export Path.

**Note:**

VMware vCloud Director must be connected!

If '-OMMetrics:$True ', VMware vRealize Operations Manager must be connected!

**Usage:**
```powershell
Connect-CIServer MyVcdServer
Connect-OMServer MyVropsServer
Get-vCDReport -NetworkName "MyExternalNetwork" -OutputFilePath "C:\Temp\" -OMMetrics:$True -OutputType "HTML"
```

**Third Party Code used:**
https://www.sepago.de/blog/2014/01/20/powershell-daten-als-html-report-ausgeben

## Get-EdgeReport

Creates a Report of Edge Gateway Details. 

**Usage:**
```powershell
$EdgeView = Search-Cloud -QueryType EdgeGateway | Get-CIView
Get-EdgeReport -EdgeView $EdgeView | Format-Table -Autosize
```

**Third Party Code used:**
https://gallery.technet.microsoft.com/scriptcenter/List-the-IP-addresses-in-a-60c5bb6b