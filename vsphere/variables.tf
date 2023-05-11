variable "vsphere_user" {
  description = "Username of VSphere account"
  type        = string
  sensitive   = true
}

variable "vsphere_password" {
  description = "Password of VSphere account"
  type        = string
  sensitive   = true
}

variable "vsphere_server" {
  description = "Address of VSphere hypervisor"
  type        = string
  sensitive   = true
}

variable "vsphere_datacenter" {
  description = "Name of VSphere DC"
  type        = string
  default     = ""
}

variable "vsphere_datastore" {
  description = "Name of VSphere DS"
  type        = string
  default     = ""
}

variable "vsphere_compute_cluster" {
  description = "Name of VSphere compute cluster"
  type        = string
  default     = ""
}

variable "vsphere_network" {
  description = "Name of VSphere network"
  type        = string
  default     = ""
}

variable "vsphere_vm_name" {
  description = "Name of VSphere VM to create"
  type        = string
  default     = "TeleportTestVM"
}

variable "vsphere_vm_folder" {
  description = "The path to the virtual machine folder in which to place the virtual machine, relative to the datacenter path "
  type        = string
  default     = ""
}

variable "vsphere_vm_multi_cluster" {
  description = "Value indicating whether to create one monolitc VM, or whether we are intending to have VM(s) for each cluster."
  type        = bool
  default     = false
}

variable "vsphere_vm_number_cluster" {
  description = "The number of VMs to create for each of the three clusters. Only applies when vsphere_vm_multi_cluster is true."
  type        = number
  default     = 1
}
