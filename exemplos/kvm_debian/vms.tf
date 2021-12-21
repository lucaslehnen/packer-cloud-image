locals {
  instances = { for vm in var.vms : (substr(vm.name, 0, 3) == "tf-" ? vm.name : "tf-${vm.name}") => vm }
}

data "template_file" "user_data" {
  for_each = local.instances
  template = file("${path.module}/cloud_init.cfg")

  vars = {
    hostname = each.key
    password = each.value.password    
  }
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  for_each       = local.instances
  name           = "cloudinit-${each.key}.iso"
  user_data      = data.template_file.user_data[each.key].rendered  
  network_config = file("${path.module}/network_config.cfg")
  pool           = libvirt_volume.volume[each.key].pool
}

resource "libvirt_volume" "volume" {
  for_each = local.instances  
  name     = "${each.key}.qcow2"
  pool     = "default"
  base_volume_name = "debian-bullseye.qcow2"
  base_volume_pool = "default"  
}

resource "libvirt_domain" "vm" {
  for_each   = local.instances
  name       = each.key
  memory     = each.value.memory == null ? 640 : each.value.memory
  vcpu       = each.value.vcpu   == null ? 2   : each.value.vcpu
  qemu_agent = true
  autostart  = true
  cloudinit  = libvirt_cloudinit_disk.cloudinit[each.key].id
  depends_on = [libvirt_volume.volume]

  cpu {
    mode = "host-model"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  network_interface {
    network_name = "test_debian"    
    // wait_for_lease = true    https://github.com/dmacvicar/terraform-provider-libvirt/issues/891
  }

  disk {
    volume_id = libvirt_volume.volume[each.key].id
    scsi      = true    
  }

  graphics {
    type        = "spice"
    listen_type = "address"
  }  
}