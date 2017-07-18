VMware-vCD-Module PowerShell Module
===================================

![Get-vCDReport](/media/Get-vCDReport.png)

# About

## Project Owner:

Markus Kraus [@vMarkus_K](https://twitter.com/vMarkus_K)

## Project WebSite:
[mycloudrevolution.com](http://mycloudrevolution.com/)

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

## Get-EdgeReport

Creates a Report of Edge Gateway Details. 

**Usage:**
```powershell
$EdgeView = Search-Cloud -QueryType EdgeGateway | Get-CIView
Get-EdgeReport -EdgeView $EdgeView | Format-Table -Autosize
```

