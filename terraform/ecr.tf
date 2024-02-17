locals {
  repository_name = [
    "sveltekit",
    "nginx"
  ]
}

resource "aws_ecr_repository" "main" {
  for_each = toset(local.repository_name)

  name                 = each.value
}

resource "aws_ecr_lifecycle_policy" "main" {
  for_each = aws_ecr_repository.main

  policy = jsonencode(
    {
      rules = [
        {
          action = {
            type = "expire"
          }
          description  = "最新の2つを残してイメージを削除する"
          rulePriority = 1
          selection = {
            countNumber = 2
            countType   = "imageCountMoreThan"
            tagStatus   = "any"
          }
        },
      ]
    }
  )
  repository = each.value.name
}
