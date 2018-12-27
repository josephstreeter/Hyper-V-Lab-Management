function Copy-VM()
    {
    Param(
    [Parameter(Mandatory=$True)][string]$VMName,
    [Parameter(Mandatory=$True)][int]$VMProc,
    [Parameter(Mandatory=$True)][int64]$VMMem,
    [Parameter(Mandatory=$True)][string]$VMTemplate,
    [Parameter(Mandatory=$True)][string]$VMNet,
    [Parameter(Mandatory=$False)][string]$VMStart
    )
    
    if (get-VM $VMName -ErrorAction SilentlyContinue){"VM already exists";pause}
    if (Get-Item $VMLoc$VMName -ErrorAction SilentlyContinue){"VM files already exists";pause}

    switch ($VMTemplate)
        {
        "w2k16_core" {$Template = "W2k16_Core.vhdx"}
        "w2k16_gui"  {$Template = "W2k16_Gui.vhdx"}
        }
    
    $VMHost="localhost"
    
    Write-Host "Creating Virtual Machine for $VMName"
    New-VM `
        -Name $VMName `
        -MemoryStartupBytes $VMMem `
        -ComputerName $VMHost `
        -NoVHD `
        -Path $VMLoc `
        -ea Stop
    
    Write-Host "Configure Virtual Machine CPU and Startup/Shutdown behavior"
    try {Set-VM -Name $VMName -AutomaticStartAction Start -AutomaticStopAction ShutDown -AutomaticStartDelay 5 -ProcessorCount $VMProc -Passthru} Catch {Break}
    
    Write-Host "Configure Virtual Machine Memory"
    try {Set-VMMemory -VMName $VMName -DynamicMemoryEnable $True -MinimumBytes 512MB -MaximumBytes $VMMem -Passthru} Catch {Break}
    
    Write-Host "Configure Virtual Machine Networking"
    try {Get-VMNetworkAdapter $VMName -ea Stop | Connect-VMNetworkAdapter -switchname $VMNet -Passthru} Catch {Break}
    
    Write-Host "Copy VHD and attach to Virtual Machine"
    try {New-Item -ItemType Directory "$VMLoc$VMName\Harddrive"} Catch {Break}
    try {copy-item "$TemplateDir$Template" "$VMLoc$VMName\Harddrive\$Template" -ea Stop -PassThru} Catch {Break}
    try {Add-VMHardDiskDrive -VMName $VMName -ControllerType IDE -Path "$VMLoc$VMName\Harddrive\$Template" -ea Stop -Passthru} Catch {Break}

    if ($VMStart)
        {
        Write-Host -ForegroundColor White -BackgroundColor Green "Starting $VMName"
        Start-VM $VMName
        }
    ""
    }

$VMLoc = "C:\VMs\VirtualMachines\"
$ISODir = "C:\ISO\"
$TemplateDir = "C:\ISO\Templates\"


function cleanup-VM($VMName)
    {
    $VM=Get-VM $VMName
    if ($VM.state -eq "running") {Stop-VM $VMName -TurnOff -Force -Passthru}
    Remove-VM $VMName -Force -Confirm:$false
    Remove-Item "C:\VMs\VirtualMachines\$VMname" -Recurse -Force -Confirm: $false
    }

<#
$vms='"Name","CPU","Memory","Template","Network"
"FR-DH-02","1",2GB,"w2k16_gui","VLAN200"
"FR-UT-01","1",4GB,"w2k16_gui","VLAN200"
"FR-TM-01","1",4GB,"w2k16_gui","VLAN200"' | ConvertFrom-Csv

foreach ($vm in $vms)
    {
    Copy-VM -VMName $vm.name -VMProc $VM.CPU -VMMem 2GB -VMTemplate $VM.Template -VMNet $VM.Network -VMStart $true
    }


$vms='"Name","CPU","Memory","Template","Network"
"FR-AP-01","1",2GB,"w2k16_core","VLAN200"
"FR-AP-02","1",2GB,"w2k16_core","VLAN200"
"FR-AP-03","1",2GB,"w2k16_core","VLAN200"
"FR-AP-04","1",2GB,"w2k16_core","VLAN200"
"FR-AP-05","1",2GB,"w2k16_core","VLAN200"
"FR-AP-06","1",2GB,"w2k16_core","VLAN200"
"FR-AP-07","1",2GB,"w2k16_core","VLAN200"
"FR-AP-08","1",2GB,"w2k16_core","VLAN200"
' | ConvertFrom-Csv
#>