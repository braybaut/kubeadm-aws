variable "owner" {
  type = string
}

variable "worker_type" {
  type    = string
  default = "t3.medium"
}

variable "key_name" {
  type = string
}


variable "public_subnet" {
  type = list(object({
    subnet_name       = string
    cidr              = string
    availability_zone = string
  }))
  default = [
    {
      subnet_name       = "public_1"
      cidr              = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    },
    {
      subnet_name       = "public_2"
      cidr              = "10.0.2.0/24"
      availability_zone = "us-east-1b"
    },
    {
      subnet_name       = "public_3"
      cidr              = "10.0.3.0/24"
      availability_zone = "us-east-1c"
    },
  ]
}

variable "private_subnet" {
  type = list(object({
    subnet_name       = string
    cidr              = string
    availability_zone = string
  }))
  default = [
    {
      subnet_name       = "private_1"
      cidr              = "10.0.4.0/24"
      availability_zone = "us-east-1a"
    },
    {
      subnet_name       = "private_2"
      cidr              = "10.0.5.0/24"
      availability_zone = "us-east-1b"
    },
    {
      subnet_name       = "private_3"
      cidr              = "10.0.6.0/24"
      availability_zone = "us-east-1c"
    }
  ]
}


variable "kubernetes_nodes" {
  type = list(object({
    name        = string
    subnet_name = string
  }))
  default = [{
    name        = "master_node_1"
    subnet_name = "private_1"
    },
    {
      name        = "worker_node_1"
      subnet_name = "private_2"
    },
    {
      name        = "worker_node_2"
      subnet_name = "private_3"
    }
  ]

}
