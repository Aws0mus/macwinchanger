param (
    [switch]$random = $false,
    [switch]$help = $false
)

if ($help -eq $true) {
    Write-Output "macchanger [-random]"
    Exit
}

function random-mac {
	$start = "02","06","0A","0E" 
    $mac = "{$(get-random -min 0 -max 4),2}" -f $start
    while ($mac.length -lt 12) 
    { 
        $mac += "{0:X}" -f $(get-random -min 0 -max 16) 
    } 
        
    $Delimiter = "-"
    for ($i = 0 ; $i -le 10 ; $i += 2) 
        { $newmac += $mac.substring($i,2) + $Delimiter }
    $setmac = $newmac.substring(0,$($newmac.length - $Delimiter.length)) 
 $setmac
}

$original = "XX-XX-XX-XX-XX-XX"

$oldmac = (Get-NetAdapter | where Name -EQ "Wi-Fi").MacAddress
Write-Output "OLD MAC Address: $oldmac" 

if ($random -eq $true) {
    $newmac = $(random-mac)    
}
else {
    $newmac = $original
}
Write-Output "NEW MAC Address: $newmac" 

Get-NetAdapter -Name "Wi-Fi" | Set-NetAdapter -MACAddress $newmac -Confirm:$false