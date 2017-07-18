Function Get-EdgeReport{
<# 
    .SYNOPSIS  
    Creates a Report of Edge Gateway Details. 

    .EXAMPLE 
    $EdgeView = Search-Cloud -QueryType EdgeGateway | Get-CIView
    Get-EdgeReport -EdgeView $EdgeView | Format-Table -Autosize

#> 
    Param (
        [Parameter(Mandatory=$True, ValueFromPipeline=$False)]
        [ValidateNotNullorEmpty()]
            $EdgeView
        )


    $EdgeReport = @()
    foreach ($Edge in $EdgeView) {

        [Array]$GatewayInterfaces = $Edge.Configuration.GatewayInterfaces
        foreach($GatewayInterface in $GatewayInterfaces.GatewayInterface){ 
            $obj = "" | Select-Object EdgeName, NetworkName, IP, IPRangeCount            
            $obj.EdgeName = $Edge.Name
            $obj.NetworkName = $GatewayInterface.Name
            $obj.IP = $GatewayInterface.SubnetParticipation.IpAddress
            [Array] $RangeReport = @()
            if ($GatewayInterface.SubnetParticipation.IpRanges){
                foreach ($IPRange in $GatewayInterface.SubnetParticipation.IpRanges.IpRange) {
                    [Array] $Range = Get-IPrange -start $IPRange.StartAddress -end $IPRange.EndAddress
                    foreach($IP in $Range){  
                        $RangeReport += $IP
                        }
                    }
                }
            $obj.IPRangeCount = $RangeReport.Count 
            $EdgeReport += $obj     
            }
                    
                
        }

    $EdgeReport
    }