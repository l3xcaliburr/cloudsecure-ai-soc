output "target_instance_id" {
  description = "Target instance ID"
  value       = aws_instance.target.id
}

output "target_public_ip" {
  description = "Target instance public IP"
  value       = aws_instance.target.public_ip
}

output "target_private_ip" {
  description = "Target instance private IP"
  value       = aws_instance.target.private_ip
}

output "attacker_instance_id" {
  description = "Attacker instance ID"
  value       = var.create_attacker_instance ? aws_instance.attacker[0].id : null
}

output "attacker_public_ip" {
  description = "Attacker instance public IP"
  value       = var.create_attacker_instance ? aws_instance.attacker[0].public_ip : null
}

output "ssh_key_name" {
  description = "SSH key pair name"
  value       = aws_key_pair.demo.key_name
}

output "target_security_group_id" {
  description = "Target security group ID"
  value       = aws_security_group.target.id
}