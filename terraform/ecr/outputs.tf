output "user_image_url" {
  value = "${aws_ecr_repository.user_service.repository_url}"
}