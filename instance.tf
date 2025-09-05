locals {
  tags_name = {
    customer = "vini"
    protocolo = "fiap"
    ## no lugar deste comentário antes havia "snapshotdiario" que eu sei de onde vc tirou :) Isso só serve no contexto que estava, fora não faz muito uso.
  }
}

resource "aws_instance" "vini-server" {
  ami             = data.aws_ami.selected.id # Substitua pela AMI em owners e ami_name_pattern via variavel
  instance_type   = var.instance_type
  security_groups = [aws_security_group.allow_ssh_http.name] #Bonus 1 outros componentes (SG)

  #Bonus 4 colocar uma secrets (estou fazendo com ssh mais comlexo)
  key_name = aws_key_pair.vini-key.key_name # Substitua pela sua Chava ssh em key_pair via key_pair.tf

  #Não sei se vale bonus, mas aqui tem um template para rodar alguns comandos na hora do bot da maquina
  ## Substituindo o uso do template_file (depreciado) pelo uso de locals e templatefile()
  ## DE...
  #user_data = data.template_file.userdata.rendered
  ## PARA...
  user_data = local.template_userdata
  user_data_replace_on_change = true

  tags = {
    Name = var.instance_name
  }
}

resource "aws_ebs_volume" "vini-server" {
  type = "gp2"
  availability_zone = aws_instance.vini-server.availability_zone
  tags = merge(local.tags_name)
  size = 50
}

resource "aws_volume_attachment" "vini-server" {
  device_name = "/dev/sdd"
  volume_id = aws_ebs_volume.vini-server.id
  instance_id = aws_instance.vini-server.id
  depends_on = [ aws_instance.vini-server ]
}