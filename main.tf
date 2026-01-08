terraform {
  required_providers {
    hyperstack = {
      source  = "NexGenCloud/hyperstack"
      version = "0.2.2-alpha"
    }
  }
}

provider "hyperstack" {
  # Spacelift will inject your API key automatically
}

resource "hyperstack_core_virtual_machine" "ai_server" {
  name             = "signcraft-ai-l40"
  region           = "CANADA-1"
  flavor_name      = "n3-L40x1" # The specific NVIDIA L40 Flavor
  image_name       = "Ubuntu Server 22.04 LTS R535 CUDA 12.2"
  assign_floating_ip = true
}
