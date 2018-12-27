# Hyper-V-VM-Management-Script
~~~Powershell
Copy-VM -VMName "FR-DH-02" -VMProc 1 -VMMem 2GB -VMTemplate "w2k16_gui" -VMNet "VLAN200" -VMStart $true
~~~
