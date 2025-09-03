resource "aws_instance" "vini-server" {
  ami           = data.aws_ami.selected.id # Substitua pela AMI em owners e ami_name_pattern via variavel
  instance_type = var.instance_type
  security_groups = [aws_security_group.allow_ssh_http.name]

  key_name = aws_key_pair.vini-key.key_name # Substitua pela sua Chava ssh em key_pair via key_pair.tf

  user_data = data.template_file.userdata.rendered
  user_data_replace_on_change = true

  tags = {
    Name = var.instance_name
  }
}