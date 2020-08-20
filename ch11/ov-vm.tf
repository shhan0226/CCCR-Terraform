provider "openstack" {
  user_name   = "user"
  tenant_name = "cccr"
  password    = "dkagh1."
  auth_url    = "http://192.168.122.250:5000"
  region      = "RegionOne"
}

module "network" {
    source     = "./module/os-network"

    CIDR_BLOCK = "192.168.122.0/24"
}

resource "openstack_compute_instance_v2" "vm1" {
  name            = "vm1"
  image_name      = "centos7"
  flavor_name     = "flavor1"
  key_pair        = "cccr-key"
  security_groups = ["default", "cccr-sg"]
  network {
    name        = module.network.network_name
    # module.MODULE_NAME.모듈의output.tf에정의된이름
  }

  depends_on = [module.network]
}
