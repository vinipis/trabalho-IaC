#Aqui estão as saidas mais bonitinhas no terminal
output "instance_id" {
  description = "ID da instancia"
  value       = aws_instance.vidaefuturo.id
}

output "public_ip" {
  description = "IP publico da instancia"
  value       = aws_instance.vidaefuturo.public_ip
}

output "public_dns" {
  description = "dns publico"
  value       = aws_instance.vidaefuturo.public_dns
}

output "ami_id" {
  description = "ami escolhida de forma dinamica"
  value       = data.aws_ami.selected
}

output "key_pair_name" {
  description = "nome da chave"
  value       = aws_key_pair.vidaefuturo-key.key_name
}

output "security_group_id" {
  description = "id do SG"
  value       = aws_security_group.allow_ssh_http
}

## O módulo template_file está deprecado em versões mais recentes do terraform.
## Use "locals" com a função templatefile() conforme abaixo como substituição para modelos mais recentes.
## De toda forma, você também não precisa expor isso, já que o userdata é aplicado na instancia.
# output "userdata" {
#   description = "file userdata"
#   value       = data.template_file.userdata
# }

output "extra_volume_devices" {
  value = var.ec2_mountpoint
}