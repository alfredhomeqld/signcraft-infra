terraform {
  required_providers {
    # Provider for your AI GPU (Canada)
    hyperstack = {
      source  = "registry.terraform.io/NexGenCloud/hyperstack"
      version = "1.46.4-alpha" 
    }
    # Provider for your Main Server (Helsinki)
    hcloud = {
      source  = "registry.terraform.io/hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

# Variable for Hetzner Auth
variable "hcloud_token" {
  type      = string
  sensitive = true
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "hyperstack" {
  # Uses HYPERSTACK_API_KEY from your Spacelift Context
}

# 1. Your Hetzner Server (The "Office")
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

# 2. Your AI Vision Engine (The "Muscle")
resource "hyperstack_core_virtual_machine" "ai_vision" {
  name             = "signcraft-vision-l40"
  environment_name = "default-CANADA-1" 
  flavor_name      = "n3-L40x1"         
  image_name       = "Ubuntu Server 22.04 LTS R535 CUDA 12.2"
  key_name         = "signcraft-key"
  assign_floating_ip = true

  # FIX: Tells OpenTofu to ignore the bug-prone 'user_data' field
  lifecycle {
    ignore_changes = [user_data]
  }
}
