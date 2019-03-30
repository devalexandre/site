app = "site"

environment = "prod"

internal = "true"

container_port = "80"

replicas = "1"

health_check = "/index.html"

region = "us-east-1"

aws_profile = "default"

saml_role = "ecs_containers"

vpc = "vpc-045c9e2b70bd4fd3a"

private_subnets = "subnet-02bb4c611781e8dc5,subnet-085ea3ef26f6a5e42"

public_subnets = "subnet-09d5e327feb07d249,subnet-06e16dd43ce6b4b91"

logz_token = "rDMOOKbboNmRqaJhshRIdimDOLuUPgFa"

secrets_saml_users = ["moleculergo@gmail.com"]

default_backend_image = "moleculergo/site:latest"

tags = {
  application = "site"
  environment = "prod"
  team        = "MoleculerGo"
}
