# Hyper-V-Lab-Management
A collection of functions used to configure and management my Hyper-V lab.

## Lab Infrastructure
The lab consists of a number of Inel NUC computers. Each host has Microsoft Hyper-V 2016 server installed and are not configured to be a cluster, but simply individual hosts. Each NUC has a USB NIC adapter that provides two additional network interfaces in addition to the one built into the NUC. These additional network interfaces allow for placing VMs on separate VLANs from the builtin NIC used as the management interface. 

## Functions
### Copy-VM
Creates a VM in Hyper-V based on the setting provided to the function. A disk is copied from the "templates" folder into the virtual machine folder and attached to the VM. 
~~~Powershell
Copy-VM -VMName "FR-DH-02" -VMProc 1 -VMMem 2GB -VMTemplate "w2k16_gui" -VMNet "VLAN200" -VMStart $true
~~~

### Cleanup-VM
Takes the name of a single VM and deletes it from Hyper-V and deletes the files and folders associated with the VM
~~~PowerShell
Cleanup-VM "server-01"
~~~
