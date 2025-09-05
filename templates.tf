data "template_file" "userdata" {
  template = file("files/userdata.sh.tpl")

  vars = {
    mountpoint  = var.ec2_mountpoint
  }
}