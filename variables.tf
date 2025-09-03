variable "aws_region" {
  description = "Region AWs"
  type = string
  default = "us-east-1"
}

variable "vpc_id" {
  description = "id da VPC onde o SG vai ser criado..."
  type = string
  default = "vpc-090bb017b83684ae6"
}

variable "instance_type" {
  description = "tipo de instancia EC2"
  type = string
  default = "t2.micro"
}

variable "instance_name" {
  description = "Tag Name da instancia"
  type = string
  default = "vini-server"
}

variable "key_name" {
  description = "Nome do Key Pair a ser criado/usado no server"
  default = "vini-key"
}

variable "public_key_path" {
  description = "caminho da key.pub"
  type = string
  default = "~/.ssh/id_rsa.pub"
}

/***********************
 * AMI dinâmica (Ubuntu)
 ***********************/
 variable "ami_owners" {
   description = "canonical (ubuntu)"
   type = list(string)
   default = [ "099720109477" ]
 }

 variable "ami_name_pattern" {
   description = "nome padrão"
   type = string
   default = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
 }

 variable "ami_virtualization" {
   description = "tipo de virtualização"
   type = string
   default = "hvm"
 }