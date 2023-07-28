locals {
  repository_name = [
    "sveltekit",
    "nginx"
  ]
}

resource "aws_ecr_repository" "main" {
  for_each = toset(local.repository_name)

  name                 = each.value
  image_tag_mutability = "IMMUTABLE"
}