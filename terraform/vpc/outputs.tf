output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "public_subnets" {
  value = [
    for subnet in aws_subnet.public :
    "${subnet.id}"
  ]
}

output "private_subnets" {
  value = [
    for subnet in aws_subnet.private :
    "${subnet.id}"
  ]
}

output "ecs_sg" {
  value = "${aws_security_group.ecs_security_group.id}"
}

output "alb_sg" {
  value = "${aws_security_group.load_balancer_security_group.id}"
}

