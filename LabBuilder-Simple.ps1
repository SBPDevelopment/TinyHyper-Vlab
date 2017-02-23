<#
.Synopsis
   Creates a Test Lab
.DESCRIPTION
   Creates the VHDX and VM for the following:
   - SBPTESTDC01
   - SBPTESTFS1
.EXAMPLE
   .\Set-TestLab.ps1
#>

[CmdletBinding()]
[OutputType([int])]
Param()

Begin{
    Write-Verbose "Importing modules..."
    $Modules = @("Hyper-V")
    $Modules | Import-Module
    $VirtualMachines = @("SBPTESTDC01","SBPTESTFS1")
    $VHDPath = "C:\Hyper-V Systems\SBPTESTLAB01\Virtual Drives"
    $VMPath =  "C:\Hyper-V Systems\SBPTESTLAB01\Virtual Machines"
}

Process{
    ForEach ($VM in $VirtualMachines) {
        Write-Verbose "Virtual Machine clean up for $VM"
        If (Get-VM -Name $VM -ErrorAction SilentlyContinue) {
            Remove-VM -Name $VM
        }
        If (Test-path -Path "$VHDPath\$VM") {
            Remove-Item "$VHDPath\$VM" -Force -Recurse
        }

        Write-Verbose "Create VHDX for $VM"
        New-VHD -Dynamic -Path "$VHDPath\$VM\$VM-C.vhdx" -SizeBytes 100GB
        Write-Verbose "Create Virtual Machine"
        New-VM -VHDPath "$VHDPath\$VM\$VM-C.vhdx" -Generation 2 -MemoryStartupBytes 1024MB -Name $VM -Path "$VMPath\$VM"
        Set-VM -Name $VM -ProcessorCount 2
	}
    }
}
End
{
}