variable "aws_region" {
  description = "Région AWS"
  type        = string
  default     = "eu-west-3"
}

variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "ID de l'AMI Ubuntu 22.04"
  type        = string
  default     = "ami-0e14b4aa2ea79f39f"  # Ubuntu 22.04 LTS (eu-west-3)
}
