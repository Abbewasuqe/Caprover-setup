
# Define required providers
terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.48.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {}

# Create a router
resource "openstack_networking_router_v2" "caprover-router" {
 name                = "caprover_router"
 admin_state_up      = true
 external_network_id = "[enter external_network_id]"
}

# Network and subnet
resource "openstack_networking_network_v2" "caprover-net" {
  name           = "caprover-net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "caprover-subn1" {
  name       = "caprover-subn"
  network_id = "${openstack_networking_network_v2.caprover-net.id}"
  cidr       = "192.168.199.0/24"
  ip_version = 4
  dns_nameservers = ["1.1.1.1"]
}

#Router interface 
resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = "${openstack_networking_router_v2.caprover-router.id}"
  subnet_id = "${openstack_networking_subnet_v2.caprover-subn1.id}"
}

#"Import key"
resource "openstack_compute_keypair_v2" "my-keypair" {
  name       = "my-keypair"
  public_key = "[Enter in your key]"
}

#Security group
resource "openstack_networking_secgroup_v2" "secgroup_1" {
  name        = "secgroup_1"
  description = "security group for caprover"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_1_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_1.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_1_httpd" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_1.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_1_443" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_1.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_1_3000" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3000
  port_range_max    = 3000
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_1.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_1_996" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 996
  port_range_max    = 996
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_1.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_1_7946" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 7946
  port_range_max    = 7946
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_1.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_1_4789" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 4789
  port_range_max    = 4789
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_1.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_1_2377" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 2377
  port_range_max    = 2377
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_1.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_1_7946_udp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 7946
  port_range_max    = 7946
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_1.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_1_4789_udp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 4789
  port_range_max    = 4789
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_1.id}"
}


resource "openstack_networking_secgroup_rule_v2" "secgroup_1_2377_udp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 2377
  port_range_max    = 2377
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_1.id}"
}


resource "openstack_networking_floatingip_v2" "caprover-server-floatip" {
  pool = "elx-public1"
}

resource "openstack_networking_floatingip_v2" "caprover-worker-floatip" {
  pool = "elx-public1"
}

# Create Instances
resource "openstack_compute_instance_v2" "caprover-server" {
  name            = "caprover-server"
  image_name      = "ubuntu-22.04-server-latest"
  flavor_name       = "v1-c2-m4-d60"
  key_pair        = "my-keypair"
  security_groups = ["secgroup_1"]
  depends_on = [
    openstack_networking_network_v2.caprover-net,
    openstack_networking_subnet_v2.caprover-subn1,
  ]

  network {
    name = "caprover-net"
    fixed_ip_v4 = "192.168.199.5"
  }
}

resource "openstack_compute_instance_v2" "caprover-worker" {
  name            = "caprover-worker"
  image_name      = "ubuntu-22.04-server-latest"
  flavor_name       = "v1-c2-m4-d60"
  key_pair        = "my-keypair"
  security_groups = ["secgroup_1"]
  depends_on = [
    openstack_networking_network_v2.caprover-net,
    openstack_networking_subnet_v2.caprover-subn1,
  ]

  network {
    name = "caprover-net"
    fixed_ip_v4 = "192.168.199.6"
  }
}

#Floating ip asscociatin

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.caprover-server-floatip.address}"
  instance_id = "${openstack_compute_instance_v2.caprover-server.id}"
}


resource "openstack_compute_floatingip_associate_v2" "fip_2" {
  floating_ip = "${openstack_networking_floatingip_v2.caprover-worker-floatip.address}"
  instance_id = "${openstack_compute_instance_v2.caprover-worker.id}"
}
