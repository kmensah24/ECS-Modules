output "region"{
    value = var.region 
}

output "project_name"{
    value = var.project_name
}

output "vpc_id"{
    value = aws_vpc.ecommerce_vpc.id
}

output "public_subnet_az1_id"{
    value = aws_subnet.public_subnet_az1.id
}

output "public_subnet_az2_id"{
    value = aws_subnet.public_subnet_az2.id
}

output "private_subnet_az1_id"{
    value = aws_subnet.private_subnet_az1.id
}

output "private_subnet_az2_id"{
    value = aws_subnet.private_subnet_az2.id
}

output "alb_hostname" {
  value = aws_alb.ecs_alb.dns_name
}