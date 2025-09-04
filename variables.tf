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
  default = "vini-key" #pode ser qualquer nome, coloquei o meu como exemplo
}

/***********************
 * EBS
 ***********************/
variable "ebs_volumes" {
  description = "Volumes EBS extras a anexar à instância"
  type = list(object({
    device_name = string            # ex.: /dev/sdb, /dev/sdc
    volume_size = number
    volume_type = string            # gp3/gp2/io2/io1
    encrypted   = optional(bool, true)
    iops        = optional(number)  # p/ io1/io2
    throughput  = optional(number)  # p/ gp3
  }))
  default = [
    { device_name = "/dev/sdb", volume_size = 10, volume_type = "gp3" },
    { device_name = "/dev/sdc", volume_size = 20, volume_type = "gp3" }
  ]
}

variable "enable_auto_mount" {
  description = "Formata e monta automaticamente os discos extras"
  type        = bool
  default     = true
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