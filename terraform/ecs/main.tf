resource "aws_ecs_cluster" "cluster" {
  name = "testing-cluster"
  tags = var.tags
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "nodejs-starter-service"
  container_definitions    = <<DEFINITION
  [{
    "name": "nodejs-starter-service",
    "image": "${var.image}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ],
    "secrets": [
        {
          "name": "MONGO_URI",
          "valueFrom": "arn:aws:secretsmanager:ap-southeast-1:621567429603:secret:MONGO_URI-SdrBAW"
        }
    ],
    "environment": [
      {
        "name": "NODE_ENV",
        "value": "staging"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/nodejs-starter",
        "awslogs-region": "ap-southeast-1",
        "awslogs-stream-prefix": "nodejs-starter"
      }
    },
    "memory": 512,
    "cpu": 256
  }]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = var.execution_role
}

resource "aws_ecs_service" "service" {
  name            = "nodejs-starter-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = false
    security_groups  = [var.security_group]
  }

  load_balancer {
    target_group_arn = var.target_group
    container_name   = aws_ecs_task_definition.task_definition.family
    container_port   = 3000
  }
}
