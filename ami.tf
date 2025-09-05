data "aws_ami" "selected" {
  most_recent = true
  owners      = var.ami_owners

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }

  filter {
    name   = "virtualization-type"
    ## Dificilmente você mudará de hvm para pv. Mas, fica a dica.
    values = ["hvm"]
  }
}