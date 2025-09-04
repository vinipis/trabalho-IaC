resource "aws_instance" "vini-server" {
  ami             = data.aws_ami.selected.id # Substitua pela AMI em owners e ami_name_pattern via variavel
  instance_type   = var.instance_type
  security_groups = [aws_security_group.allow_ssh_http.name] #Bonus 1 outros componentes (SG)

  #Bonus 4 colocar uma secrets (estou fazendo com ssh mais comlexo)
  key_name = aws_key_pair.vini-key.key_name # Substitua pela sua Chava ssh em key_pair via key_pair.tf

  #Não sei se vale bonus, mas aqui tem um template para rodar alguns comandos na hora do bot da maquina
  #  user_data = data.template_file.userdata.rendered
  #  user_data_replace_on_change = true

  tags = {
    Name = var.instance_name
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_volumes
    content {
      device_name           = ebs_block_device.value.device_name
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = ebs_block_device.value.volume_type
      delete_on_termination = true
      encrypted             = try(ebs_block_device.value.encrypted, true)
      iops                  = try(ebs_block_device.value.iops, null)
      throughput            = try(ebs_block_device.value.throughput, null)
    }
  }
  user_data = data.template_file.userdata.rendered
  user_data_replace_on_change = true
}