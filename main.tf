terraform {
  required_providers {
    hyperstack = {
      source  = "registry.terraform.io/NexGenCloud/hyperstack"
      version = "1.46.4-alpha" 
    }
    hcloud = {
      source  = "registry.terraform.io/hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

variable "hcloud_token" {
  type      = string
  sensitive = true
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "hyperstack" {}

resource "hcloud_server" "main_server" {
  name        = "SignCraft-Main-Helsinki"
  server_type = "cx43"
  image       = "ubuntu-22.04"
  location    = "hel1"
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

resource "hyperstack_core_virtual_machine" "ai_vision" {
  name             = "signcraft-vision-l40"
  environment_name = "default-CANADA-1" 
  flavor_name      = "n3-L40x1"         
  image_name       = "Ubuntu Server 22.04 LTS R535 CUDA 12.2"
  key_name         = "signcraft-key"
  assign_floating_ip = true

  lifecycle {
    # This is the 'Nuclear Option' to stop the crash. 
    # It tells Spacelift: "Just build it and leave it alone."
    ignore_changes = all
  }
}
