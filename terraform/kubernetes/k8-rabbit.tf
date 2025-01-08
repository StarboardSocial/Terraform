locals {
  rabbitenv = { for tuple in regexall("(.*)=(.*)", file("./kubernetes/.env")) : tuple[0] => tuple[1] }
}

resource "kubernetes_deployment_v1" "k8-dp-prod-rabbit" {
    depends_on = [var.depends_on_azure_k8] 

  metadata {
    name = "dp-prod-rabbit"
    namespace = kubernetes_namespace.k8-ns-prod-starboardsocial.metadata[0].name
  }

  spec {
    template {
      metadata {
        name = "pod-prod-rabbit"
        namespace = kubernetes_namespace.k8-ns-prod-starboardsocial.metadata[0].name
        labels = {
          app = "prod-rabbit"
        }
      }

      spec {
        container {
          name = "cont-prod-rabbit"
          image = "rabbitmq:4.0-management"
          
          port {
            container_port = 5672
          }
          
          port {
            container_port = 15672
          }
          
          resources {
            requests = {
              memory = "64Mi"
              cpu    = "100m"
            }

            limits = {
              memory = "128Mi"
              cpu    = "200m"
            }
          }
          
          env_from {
            config_map_ref {
              name = "conf-prod-rabbit"
            }
          }
        }
      }
    }

    selector {
        match_labels = {
            app = "prod-rabbit"
        }
    }
  }
}


resource "kubernetes_service" "k8-sv-prod-rabbit" {
    depends_on = [var.depends_on_azure_k8] 
  metadata {
    name = "sv-prod-rabbit"
    namespace = kubernetes_namespace.k8-ns-prod-starboardsocial.metadata[0].name
  }

  spec {
    selector = {
      app = "prod-rabbit"
    }

    port {
      port       = 15672
      target_port = 15672
      name       = "management"
    }

    port {
      port       = 5672
      target_port = 5672
      name       = "bus"
    }
  }
}

resource "kubernetes_config_map" "k8-conf-prod-rabbit" {
    depends_on = [var.depends_on_azure_k8] 
  metadata {
    name = "conf-prod-rabbit"
    namespace = kubernetes_namespace.k8-ns-prod-starboardsocial.metadata[0].name
  }

  data = {
    "RABBITMQ_DEFAULT_USER" = local.rabbitenv["RABBIT_USERNAME"]
    "RABBITMQ_DEFAULT_PASS" = local.rabbitenv["RABBIT_PASSWORD"]
  }
}