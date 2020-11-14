resource "aws_ecr_repository" "user_service" {
  name = "user-service"
  tags = var.tags
}
