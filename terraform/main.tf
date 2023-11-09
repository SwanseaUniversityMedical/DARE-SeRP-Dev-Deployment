terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.4.3"
    }
  }
}

locals {
  create_groups = (var.vsphere_vm_multi_cluster == true ? toset(["mgmt", "mon", "work"]) : toset(["all"]))
  num_vms       = (var.vsphere_vm_multi_cluster == true ? range(1, var.vsphere_vm_default_number_cluster + 1) : [1])

  num_ips = (range(1, (length(local.create_groups) * length(local.num_vms)) + 1))
  ip_list_def = distinct(flatten([
    for incr in local.num_ips : [
      (199 + incr)
    ]
  ]))


  vm_list_def = distinct(flatten([
    for group in local.create_groups : [
      for vmn in local.num_vms : {
        group     = group
        vm_ref    = vmn
        cpu       = var.vsphere_vm_default_num_cpu
        memory    = var.vsphere_vm_default_memory
        os_disk   = var.vsphere_vm_default_os_disk_size
        data_disk = var.vsphere_vm_default_data_disk_size
      }
    ]
  ]))

  vm_list_cr = flatten([
    for group, group_data in var.vsphere_vm_multi_cluster_custom_resource_defs : [
      for vmn in range(1, group_data["num_vms"] + 1) : {
        group     = group
        vm_ref    = vmn
        cpu       = group_data["cpu"]
        memory    = group_data["memory"]
        os_disk   = group_data["os_disk"]
        data_disk = group_data["data_disk"]
      }
    ]
  ])

  vm_list = (var.vsphere_vm_multi_cluster == true && var.vsphere_vm_multi_cluster_customise_resources == true ? local.vm_list_cr : local.vm_list_def)

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

data "vsphere_virtual_machine" "template" {
  name          = "Templates/Current/Ubuntu-22"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "template_cloudinit_config" "example" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content      = <<-EOF
      #cloud-config
      users:
        - name: ${var.ssh_username}
          lock_passwd: false
          passwd: $6$2tyQG31rGuOvd2B3$1Dh84m6EUbV33.DQkIW.co1FqpuN7znzh907bgsBVOkQW7a8qnfXGjiwe0n9mOiODhxVZElFLa.6zifW0eVtf/
          ssh-authorized-keys:
            - ${var.public_key_1}
            - ${var.public_key_2}
          sudo: ['ALL=(ALL) NOPASSWD:ALL']
          groups: sudo
          shell: /bin/bash
      apt:
        primary:
          - arches: [default]
            search:
              - http://archive.ubuntu.com
      EOF
  }
}

resource "vsphere_virtual_machine" "vm" {
  for_each            = { for item in local.vm_list : "${item.group}.${item.vm_ref}" => item }
  name                = "${var.vsphere_vm_name}-${each.value.group}-${each.value.vm_ref}"
  folder              = var.vsphere_vm_folder
  resource_pool_id    = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id        = data.vsphere_datastore.datastore.id
  num_cpus            = each.value.cpu
  memory              = each.value.memory
  guest_id            = data.vsphere_virtual_machine.template.guest_id
  scsi_type           = data.vsphere_virtual_machine.template.scsi_type
  sync_time_with_host = true

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  disk {
    label            = "disk0"
    size             = each.value.os_disk
    thin_provisioned = false
  }
  # disk {
  #   label            = "disk1"
  #   size             = each.value.data_disk
  #   unit_number      = 1
  #   thin_provisioned = true
  # }
  # need this so it can install vmware tools
  cdrom {
    client_device = true
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "${var.vsphere_vm_name}-${each.value.group}-${each.value.vm_ref}"
        domain    = "chi.swan.ac.uk"
      }
      network_interface {
        ipv4_address = "192.168.69.${local.ip_list_def[index(local.vm_list, each.value)]}"
        ipv4_netmask = 24
      }
      ipv4_gateway    = "192.168.69.254"
      dns_server_list = ["192.168.10.169"]
    }
  }
  extra_config = {
    "guestinfo.userdata"          = data.template_cloudinit_config.example.rendered
    "guestinfo.userdata.encoding" = "gzip+base64"
  }

}

