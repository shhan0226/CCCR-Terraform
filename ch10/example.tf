provider "openstack" {
  user_name   = "user"
  tenant_name = "cccr"
  password    = "dkagh1."
  auth_url    = "http://192.168.122.250:5000"
  region      = "RegionOne"
}


resource "openstack_compute_instance_v2" "vm1" {
  name            = "vm1"
  image_name      = var.iname
  flavor_name     = var.fname
  key_pair        = "cccr-key"
  security_groups = var.sg_list
  network {
    name = "private1"
  }
}

