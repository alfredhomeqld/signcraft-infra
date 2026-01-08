terraform {
  required_providers {
    # FIX: Corrected capitalization to NexGenCloud
    hyperstack = {
      source  = "NexGenCloud/hyperstack"
      version = "1.46.4-alpha" 
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.58"
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
  # This uses the HYPERSTACK_API_KEY from your Spacelift Context
}

# 1. Your Hetzner Server (Permanent Office/Dashboard)
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

# 2. Your AI Vision Engine (L40 GPU Muscle)
resource "hyperstack_core_virtual_machine" "ai_vision" {
  name             = "signcraft-vision-l40"
  environment_name = "default-CANADA-1" 
  flavor_name      = "n3-L40x1"         
  image_name       = "Ubuntu Server 22.04 LTS R535 CUDA 12.2"
  key_name         = "signcraft-key"
  assign_floating_ip = true

  # CRITICAL FIX: Stops the 'unknown value' bug from crashing your run
  lifecycle {
    ignore_changes = all
  }
}
