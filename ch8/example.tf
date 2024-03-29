provider "openstack" {
  user_name   = "user"
  tenant_name = "cccr"
  password    = "dkagh1."
  auth_url    = "http://192.168.122.250:5000"
  region      = "RegionOne"
}

resource "openstack_compute_instance_v2" "vm1" {
  name            = "vm1"
  image_name      = "centos7"
  flavor_name     = "flavor1"
  key_pair        = "cccr-key"
  security_groups = ["default", "${openstack_compute_secgroup_v2.secgroup_1.name}"]
  network {
    name = "private1"
  }
  depends_on = [
    openstack_networking_floatingip_v2.fip1,
    openstack_compute_secgroup_v2.secgroup_1,
  ]

}

resource "openstack_compute_secgroup_v2" "secgroup_1" {
  name        = "my_secgroup"
  description = "my security group"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }


  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
  from_port   = -1
  to_port     = -1
  ip_protocol = "icmp"
  cidr        = "0.0.0.0/0"

  }
}

resource "openstack_networking_floatingip_v2" "fip1" {
  pool = "external"
}

resource "openstack_compute_floatingip_associate_v2" "myip" {
  floating_ip = openstack_networking_floatingip_v2.fip1.address
  instance_id = openstack_compute_instance_v2.vm1.id

  connection {
    type = "ssh"
    user = "centos"
    private_key = file("~/Downloads/cccr-key.pem")
    host = openstack_networking_floatingip_v2.fip1.address
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
      "echo ${self.floating_ip} | sudo tee /var/www/html/index.html"
    ]
  }
  
  provisioner "local-exec" {
    command = "echo ${self.instance_id} > ./instance_id.txt"
  }

  provisioner "file" {
    source      = "filea.txt"
    destination = "/home/centos/filea.txt"
  }
}
