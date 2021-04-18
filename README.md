# terraform - Week4project

## Components:
* Virtual network with 2 subnets
* NSG for every subnet
* Two Avilabilty sets
* Two windows virtual machines
* Two linux virtual machines
* Public load balancer
* Internal load balancer

## Structure:
Vnet have public and private subnets, every subnet attched to NSG with compitible security rules.
The windows VM's are on the same subnet (Public) and availability set, they are connected to the backend public load balncer, the load balancer has a Public IP address.
The linux VM's are on the same subnet (Privte) and availability set, they are connected to the backend internal load balncer.

### Modules:
* \modules\linuxvm  -  Module for create Basic linux VM.
* \modules\windowsvm  -  Module for create Basic windows VM.
