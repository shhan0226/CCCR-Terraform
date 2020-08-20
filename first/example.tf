provider "openstack" {
  user_name   = "user"
  tenant_name = "cccr"
  password    = "dkagh1."
  auth_url    = "http://192.168.122.250:5000"
  region      = "RegionOne"
}


resource "openstack_compute_instance_v2" "vm1" {
  name            = "vm_with_terraform2"
  image_name      = "centos7"
  flavor_name     = "flavor1"
  key_pair        = "cccr-key"
  security_groups = ["default"]
  network {
    name = "private1"
  }
}

