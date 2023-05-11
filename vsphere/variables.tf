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

variable "vsphere_vm_default_num_cpu" {
  description = "The number of CPUs to allocate to each VM."
  type        = number
  default     = 8
}

variable "vsphere_vm_default_memory" {
  description = "The amount of memory, in megabytes, to allocate each VM."
  type        = number
  default     = 32000
}

variable "vsphere_vm_default_os_disk_size" {
  description = "The size, in gigabytes, for the OS disk of the VM"
  type        = number
  default     = 70
}

variable "vsphere_vm_default_data_disk_size" {
  description = "The size, in gigabytes, for the data disk of the VM. This disk is where the K8s storage class will write to."
  type        = number
  default     = 50
}


variable "vsphere_vm_multi_cluster" {
  description = "Value indicating whether to create one monolitc VM, or whether we are intending to have VM(s) for each cluster."
  type        = bool
  default     = false
}

variable "vsphere_vm_default_number_cluster" {
  description = "The number of VMs to create for each of the three clusters. Only applies when vsphere_vm_multi_cluster is true."
  type        = number
  default     = 1
}

variable "vsphere_vm_multi_cluster_customise_resources" {
  description = "Set to true to pass a customised resource definition for VMs in each group. Only applies when vsphere_vm_multi_cluster is true. If not set then every created VM will have resources defined in vsphere_vm_default_num_cpu, vsphere_vm_default_memory, vsphere_vm_default_os_disk_size, and vsphere_vm_default_data_disk_size."
  type        = bool
  default     = false
}

variable "vsphere_vm_multi_cluster_custom_resource_defs" {
  description = "The customised resource values for VMs in each of the VM groups. Only applies when vsphere_vm_multi_cluster is true and vsphere_vm_multi_cluster_customise_resources is true."
  type        = map(any)
  default = {
    "work" = {
      "num_vms"   = 3
      "cpu"       = 4
      "memory"    = 8000
      "os_disk"   = 70
      "data_disk" = 100
    }
    "mon" = {
      "num_vms"   = 1
      "cpu"       = 8
      "memory"    = 16000
      "os_disk"   = 70
      "data_disk" = 50
    }
    "mgmt" = {
      "num_vms"   = 1
      "cpu"       = 8
      "memory"    = 16000
      "os_disk"   = 70
      "data_disk" = 50
    }
  }
}
