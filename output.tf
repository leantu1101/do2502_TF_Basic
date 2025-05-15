output "public_ec2_ip" {
  value = aws_instance.devops2502-ec2-public.public_ip
}

output "private_key_forPublic" {
  value     = tls_private_key.key_forPublic.private_key_pem
  sensitive = true
}

output "private_key_forPrivate" {
  value     = tls_private_key.key_forPrivate.private_key_pem
  sensitive = true
}