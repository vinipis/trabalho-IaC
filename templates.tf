  data "template_file" "userdata" {
    template = file("files/userdata.sh.tpl")
  }