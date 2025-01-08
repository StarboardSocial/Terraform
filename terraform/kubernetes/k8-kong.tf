resource "helm_release" "helm-kong-ingress-controller" {
  name       = "kong"

  repository = "https://charts.konghq.com"
  chart      = "ingress"
    namespace = kubernetes_namespace.k8-ns-prod-starboardsocial.metadata[0].name

  set {
    name  = "controller.service.loadBalancerIP"
    value = "[service.beta.kubernetes.io/azure-load-balancer-ipv4: ${var.external_ip}]"
  }
}

resource "kubernetes_ingress_v1" "k8-ingrs-prod-authservice" {
  metadata {
    name = "ingrs-prod-authservice"
    annotations = {
        "konghq.com/strip-path" = "false"
    }
  }

  spec {
    ingress_class_name = "kong"

    rule {
      http {
        path {
          path = "/auth"
          backend {
            service {
                name = "sv-prod-authservice"
                port {
                    number = 9000
                }
          }
        }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "k8-ingrs-prod-userservice" {
  metadata {
    name = "ingrs-prod-userservice"
    annotations = {
        "konghq.com/strip-path" = "false"
    }
  }

  spec {
    ingress_class_name = "kong"

    rule {
      http {
        path {
          path = "/user"
          backend {
            service {
                name = "sv-prod-userservice"
                port {
                    number = 9001
                }
            }
        }
        }
      }
    }
  }
}
