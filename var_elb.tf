/*
 * Module: TF_ELB_mod
 */

#
#
variable "sec_group" {}
variable "ami_id" {
  description = "The AMI to use with the launch configuration"
}
variable "instance_type" {}
variable "iam_instance_profile" {
  description = "The IAM role the launched instance will use"
}
variable "key_name" {
  description = "The SSH public key name (in EC2 key-pairs) to be injected into instances"
}
variable "security_group" {
  description = "ID of SG the launched instance will use"
}
