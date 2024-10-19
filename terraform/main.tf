terraform {
  required_providers {
    docker = {
        source = "kreuzwerker/docker"
    }
  }
}

variable "registry_url" {
  type = string
}

variable "registry_username" {
  type = string
  sensitive = true
}

variable "registry_password" {
  type = string
  sensitive = true
}


provider "docker" {
  host = "unix:///var/run/docker.sock"

  registry_auth {
    address  = var.registry_url
    username = var.registry_username
    password = var.registry_password
  }
}

