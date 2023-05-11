# VSphere

This Terraform is for use with VMWare vSphere, notably vCenter Server and ESXi.

It will create a given number of VMs for the Teleport project to run on top of. The Terraform is flexible and can create a single monolithic VM for all services to run on, or can create a given number of VMs for each of the 3 necessary K8s clusters -- one for work, one for management, and one for monitoring.

## Pre-requsites
