resource "aws_iam_role" "ecs-task-execution-role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode(
    {
      "Version": "2008-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
              "Service": [
                "ecs-tasks.amazonaws.com",
                "ecs.amazonaws.com"
              ]
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
  )
}

data "aws_iam_policy" "AmazonECSTaskExecutionRolePolicy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role" {
  role       = aws_iam_role.ecs-task-execution-role.name
  policy_arn = data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn
}

resource "aws_iam_role" "ecs-task-role" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode(
    {
      "Version": "2008-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
              "Service": [
                "ecs-tasks.amazonaws.com",
                "ecs.amazonaws.com"
              ]
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_policy" "ecs-task-role" {
  name   = "ecs-task-role-policy"
  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
              "*"
          ],
          "Resource": "*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "ecs-task-role" {
  role       = aws_iam_role.ecs-task-role.name
  policy_arn = aws_iam_policy.ecs-task-role.arn
}

resource "aws_security_group" "practice-svelte-fargate" {
  name        = "practice-svelte-fargate"

  # セキュリティグループを配置するVPC
  vpc_id      = aws_vpc.main.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "practice-svelte-fargate" {
  security_group_id = aws_security_group.practice-svelte-fargate.id

  type = "ingress"

  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_cloudwatch_log_group" "main" {
  name = "practice-svelte-fargate"

  retention_in_days = 7
}

resource "aws_ecs_cluster" "main" {
  name = "practice-svelte-fargate"
}

resource "aws_lb" "main" {
  name = "practice-svelte-fargate"
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.practice-svelte-fargate.id
  ]
  subnets = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1c.id
  ]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_target_group" "main" {
  name                 = "practice-svelte-fargate-tg"
  vpc_id               = aws_vpc.main.id
  target_type          = "ip"
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 60
  health_check { path = "/" }
}
