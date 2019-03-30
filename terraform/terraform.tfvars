app = "site"

environment = "prod"

internal = "true"

container_port = "80"

replicas = "1"

health_check = "/index.html"

region = "us-east-1"

aws_profile = "default"

saml_role = "ecs_containers"

vpc = "vpc-123"

private_subnets = "subnet-123,subnet-456"

public_subnets = "subnet-789,subnet-012"

tags = {
  application = "site"
  environment = "prod"
  team        = "MoleculerGo"
}
