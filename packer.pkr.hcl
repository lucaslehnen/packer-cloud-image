packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/qemu"
    }
  }  
}

source "qemu" "debian" {
  accelerator                  = "kvm"
  boot_command                 = [
      "<wait><wait><wait><esc><wait><wait><wait>", 
      "/install.amd/vmlinuz ", 
      "initrd=/install.amd/initrd.gz ", 
      "auto=true ", 
      "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks ", 
      "hostname=${var.vm_name} ", 
      "domain=${var.domain} ", 
      "interface=auto ", 
      "vga=788 noprompt quiet --<enter>"
  ]
  boot_wait                    = "3s" 
  communicator                 = "ssh"
  cpus                         = var.cpus
  disk_cache                   = "writeback"
  disk_compression             = false
  disk_discard                 = "ignore"
  disk_image                   = false
  disk_interface               = "virtio-scsi"
  disk_size                    = var.disk_size
  format                       = "qcow2"
  headless                     = true
  http_content                 = {
      "/ks" = templatefile("${path.root}/preseeds/${var.preseed_file}", 
        {          
          hostname = "${var.vm_name}",
          ssh_fullname = "${var.ssh_fullname}",
          ssh_username = "${var.ssh_username}",
          ssh_password = "${var.ssh_password}",
        })
  }  
  iso_checksum                 = var.iso_checksum
  iso_skip_cache               = false
  iso_target_extension         = "iso"
  iso_urls                     = ["${var.iso_path}/${var.iso_file}"]
  machine_type                 = "pc"
  memory                       = var.memory
  net_device                   = "virtio-net"  
  qemu_binary                  = var.qemu_binary
  shutdown_command             = "sudo shutdown 0"
  shutdown_timeout             = var.shutdown_timeout
  skip_compaction              = true
  skip_nat_mapping             = false  
  ssh_clear_authorized_keys    = var.ssh_clear_authorized_keys  
  ssh_password                 = var.ssh_password  
  ssh_timeout                  = var.ssh_timeout
  ssh_username                 = var.ssh_username
  use_default_display          = false
  vm_name                      = var.vm_name
  vnc_bind_address             = var.vnc_vrdp_bind_address  
  output_directory             = "build"
}

build {
  sources = [    
    "source.qemu.debian"
  ]

  provisioner "shell" {
    binary              = false
    execute_command     = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S '{{ .Path }}'"
    expect_disconnect   = true
    inline              = ["echo '${var.ssh_username} ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/99${var.ssh_username}", "chmod 0440 /etc/sudoers.d/99${var.ssh_username}"]
    inline_shebang      = "/bin/sh -e"    
    skip_clean          = false
    start_retry_timeout = var.start_retry_timeout
  }

  provisioner "shell" {
    binary              = false
    execute_command     = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S '{{ .Path }}'"
    expect_disconnect   = true
    inline              = [
        "apt-get update",
        "apt-get --yes dist-upgrade",
        "apt-get clean",
    ]
    inline_shebang      = "/bin/sh -e"    
    skip_clean          = false
    start_retry_timeout = var.start_retry_timeout
  } 

  provisioner "shell" {
    binary              = false
    execute_command     = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S '{{ .Path }}'"
    expect_disconnect   = true
    inline              = [
        "apt-get install cloud-init --yes",
        "rm -Rf /etc/network/interfaces.d/50-cloud-init",
        "cloud-init init --local",
        "echo \"source /etc/network/interfaces.d/*\" > /etc/network/interfaces",
        "apt-get clean",
        "rm -Rf /var/lib/cloud",
    ]
    inline_shebang      = "/bin/sh -e"    
    skip_clean          = false
    start_retry_timeout = var.start_retry_timeout
  } 
  
}