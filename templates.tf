## O módulo template_file está deprecado em versões mais recentes do terraform.
## Use "locals" com a função templatefile() conforme abaixo como substituição para modelos mais recentes.
# data "template_file" "userdata" {
#   template = file("files/userdata.sh.tpl")

#   vars = {
#     mountpoint  = var.ec2_mountpoint
#   }
# }

locals {
  template_userdata = templatefile("${path.module}/files/userdata.sh.tpl", {
    mountpoint        = var.ec2_mountpoint
  })
}