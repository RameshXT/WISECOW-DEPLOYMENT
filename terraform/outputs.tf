output "wise_cow_public_ip" {
  value = aws_instance.wise_cow.public_ip
}

output "wise_cow_instance_id" {
  value = aws_instance.wise_cow.id
}
