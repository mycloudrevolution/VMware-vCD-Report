Function Get-vCDReport{
<# 
    .SYNOPSIS  
    Creates the HTML or CSV Output of VMware vCloud Director Ressources.

     .EXAMPLE 
    Get-vCDReport -NetworkName "MyExternalNetwork" -OutputFilePath "C:\Temp\" -OMMetrics:$True -OutputType "HTML"

#> 
  Param (
        [Parameter(Mandatory=$False, ValueFromPipeline=$False)]
        [ValidateNotNullorEmpty()]
           [String]$NetworkName = "NONE",
        [Parameter(Mandatory=$False, ValueFromPipeline=$False)]
        [ValidateNotNullorEmpty()]
           [String]$OutputFilePath = ".\",
        [Parameter(Mandatory=$False, ValueFromPipeline=$False)]
        [ValidateNotNullorEmpty()]
           [Switch]$OMMetrics = $true,
        [Parameter(Mandatory=$False, ValueFromPipeline=$False)]
        [ValidateNotNullorEmpty()]
        [ValidateSet("CSV","HTML")]
            [String]$OutputType = "HTML"
        )


$OrgViews = Search-Cloud -QueryType Organization | Get-CIView -Verbose:$false
if ($OMMetrics) {
    $OmHealthStati = Get-OMResource -ResourceKind ORG_VDC
}

$Report = @()
foreach ($OrgView in $OrgViews) {
    foreach ($OrgVdc in $OrgView.Vdcs.Vdc){
    $obj = "" | Select-Object Org, OrgVdc, OmHealth, "CpuUsed(GHz)", "RamUsed(GB)", VApps, VAppTemplates, VMs, VMsOff, `
    StorageProfiles, "StorageLimit(GB)", "StorageUsed(GB)", EdgeGateway, Ip, IpRangeCount
    $obj.Org = $OrgView.Name
    $obj.OrgVdc = $OrgVdc.Name
    if ($OMMetrics) {
        try {
            $obj.OmHealth = ($OmHealthStati | Where-Object {$_.Name -eq $OrgVdc.Name} ).Health    
        }
        catch {
            $obj.OrgVdc = "N/A"    
        }   
    }
    else {
        $obj.OrgVdc = "N/A"    
    }
        $OrgVdc = Search-Cloud -QueryType AdminOrgVdc -Name $OrgVdc.Name
        $OrgVdcView = $OrgVdc | Get-CIView -Verbose:$false
    #$obj."CpuAllocated(GHz)" = [Math]::Round(($OrgVdcView.ComputeCapacity.Cpu.Allocated / 1000), 2)
    $obj."CpuUsed(GHz)" = [Math]::Round(($OrgVdcView.ComputeCapacity.Cpu.Used / 1000), 2)
    #$obj."RamAllocated(GB)" = [Math]::Round(($OrgVdcView.ComputeCapacity.Memory.Allocated / 1024), 2)
    $obj."RamUsed(GB)" = [Math]::Round(($OrgVdcView.ComputeCapacity.Memory.Used / 1024), 2)
    $obj.VApps = $OrgVdc.NumberOfVApps
    $obj.VAppTemplates = $OrgVdc.NumberOfVAppTemplates
        [Array]$OrgVdcVMs = Search-Cloud -QueryType AdminVM -Filter "Vdc==$($OrgVDC.Id)"
    if ($OrgVdcVMs) {
      $obj.VMs = $OrgVdcVMs.Count
      [Array]$OrgVdcVMsOff = $OrgVdcVMs | where {$_.Status -eq "POWERED_OFF"}
      if ($OrgVdcVMsOff) {
        $obj.VMsOff = $OrgVdcVMsOff.Count   
      }
      else {
          $obj.VMsOff = 0  
      }
              
    }
    else{
        $obj.VMs = 0 
        $obj.VMsOff = 0    
    }

        [Array]$OrgVdcStorageView = Search-Cloud -QueryType AdminOrgVdcStorageProfile -Filter "VdcName==$($OrgVdc.Name)"
    $obj.StorageProfiles = $OrgVdcStorageView.Name -join ", "
        $StorageLimit = @()
        foreach ($StorageObject in $OrgVdcStorageView.StorageLimitMB) {
            $StorageLimit += [Math]::Round(($StorageObject / 1024), 2)    
        }
    $obj."StorageLimit(GB)" = $StorageLimit -join ", " 
        $StorageUsed = @()
        foreach ($StorageObject in $OrgVdcStorageView.StorageUsedMB) {
            $StorageUsed += [Math]::Round(($StorageObject / 1024), 2)    
        }
    $obj."StorageUsed(GB)" = $StorageUsed -join ", " 

        $EdgeView = Search-Cloud -QueryType EdgeGateway -Filter "Vdc==$($OrgVdcView.Id)" | Get-CIView
    if ($EdgeView) {
            $VcdEdgeReport = Get-EdgeReport -EdgeView $EdgeView | Where-Object {$_.NetworkName -like $NetworkName}
        if ($VcdEdgeReport) {
            $obj.EdgeGateway = $VcdEdgeReport.EdgeName
            $obj.Ip = $VcdEdgeReport.IP
            $obj.IpRangeCount = $VcdEdgeReport.IPRangeCount
        }
    }

    $Report += $obj 
    }    
}

if ($OutputType -eq "HTML") {
   $OutputFileName = $OutputFilePath + "HtmlReport.html"
   $InputObject =  @{Object = $Report}
   $trash = Export-HtmlReport -InputObject $InputObject -ReportTitle "vCD Ressource Usage Report" -OutputFileName $OutputFileName
}
elseif ($OutputType -eq "CSV") {
    $OutputFileName = $OutputFilePath + "CsvReport.csv"
    $Report | Export-Csv -Path $OutputFileName -Delimiter ";"       
}
"Output File: '$OutputFileName'`n"
}