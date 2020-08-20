variable "iname" {
    default = "centos7"
    type = string
    description = "image name"
}

variable "fname" {
    default = "flavor1"
    type = string
    
}

variable "sg_list" {
    default = ["default", "cccr-sg"]
}

