terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.4.0"
    }
  }
}

locals {
  create_groups = (var.vsphere_vm_multi_cluster == true ? toset(["mgmt", "mon", "work"]) : toset(["all"]))
  num_vms       = (var.vsphere_vm_multi_cluster == true ? range(1, var.vsphere_vm_number_cluster + 1) : [1])

  vm_list = distinct(flatten([
    for group in local.create_groups : [
      for vmn in local.num_vms : {
        group  = group
        vm_ref = vmn
      }
    ]
  ]))
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_compute_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "vm" {
  for_each             = { for item in local.vm_list : "${item.group}.${item.vm_ref}" => item }
  name                 = "${var.vsphere_vm_name}-${each.value.group}-${each.value.vm_ref}"
  folder               = var.vsphere_vm_folder
  resource_pool_id     = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id         = data.vsphere_datastore.datastore.id
  num_cpus             = 32
  memory               = 64000
  guest_id             = "ubuntu64Guest"
  sync_time_with_host  = true
  tools_upgrade_policy = upgradeAtPowerCycle

  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label            = "disk0"
    size             = 70
    thin_provisioned = false
  }
  # disk {
  #   label            = "disk1"
  #   size             = 100
  #   unit_number      = 1
  #   thin_provisioned = true
  # }
  # need this so it can install vmware tools
  cdrom {
    client_device = true
  }

}

