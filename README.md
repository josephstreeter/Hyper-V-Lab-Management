# Hyper-V-Lab-Management
A collection of script used to configure and management a Hyper-V lab.


## Functions
### Copy-VM
Creates a VM in Hyper-V based on the setting provided to the function. A disk is copied from the "templates" folder into the virtual machine folder and attached to the VM. 
~~~Powershell
Copy-VM -VMName "FR-DH-02" -VMProc 1 -VMMem 2GB -VMTemplate "w2k16_gui" -VMNet "VLAN200" -VMStart $true
~~~

### Cleanup-VM
Takes the name of a single VM and deletes it from Hyper-V and deletes the files and folders associated with the VM
~~~PowerShell
Cleanup-VM server-01
~~~
