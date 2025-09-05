#Aqui estão as saidas mais bonitinhas no terminal
output "instance_id" {
  description = "ID da instancia"
  value       = aws_instance.vini-server.id
}

output "public_ip" {
  description = "IP publico da instancia"
  value       = aws_instance.vini-server.public_ip
}

output "public_dns" {
  description = "dns publico"
  value       = aws_instance.vini-server.public_dns
}

output "ami_id" {
  description = "ami escolhida de forma dinamica"
  value       = data.aws_ami.selected
}

output "key_pair_name" {
  description = "nome da chave"
  value       = aws_key_pair.vini-key.key_name
}

output "security_group_id" {
  description = "id do SG"
  value       = aws_security_group.allow_ssh_http
}

output "userdata" {
  description = "file userdata"
  value       = data.template_file.userdata
}

output "extra_volume_devices" {
  value = var.ec2_mountpoint
}