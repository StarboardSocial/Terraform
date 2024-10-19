resource "docker_image" "auth-service" {
  name = var.registry_url+"/starboardsocial-authservice:latest"
}