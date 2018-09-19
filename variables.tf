variable "namespace" {
  default = "default"
  description = "The namespace to prevent name clashes"
}

variable "aws_account" {
  description = "AWS account id"
}

variable "datomic_license" {
  description = "Datomic license key"
}

variable "datomic_version" {
  default = "0.9.5530"
}

variable "dynamo_read_capacity" {
  description = "One read capacity unit represents one strongly consistent read per second, or two eventually consistent reads per second, for items up to 4 KB in size."
  default = 50
}

variable "dynamo_write_capacity" {
  description = "One write capacity unit represents one write per second for items up to 1 KB in size."
  default = 50
}

variable "peer_role_id" {
  description = "A list of the peer role ids"
}

variable "peer_role_name" {
  description = "A list of the peer role names"
}

variable "region" {
  description = "The region to deploy into"
}

variable "transactor_instance_type" {
  description = "Instance type and size"
  default = "t2.micro"
}

variable "transactor_instance_virtualization_type" {
  description = "Virtualization type for the instance."
  default = "hvm"
}

variable "transactors" {
  description = "Number of transactors to run"
  default = "1"
}

variable "subnet" {}

variable "transactor_deploy_bucket" {
  default = "deploy-a0dbc565-faf2-4760-9b7e-29a8e45f428e"
}

variable "transactor_xmx" {
  description = "The maximum size, in bytes, of the memory allocation pool. This value must a multiple of 1024 greater than 2MB."
  default = "512m"
}

variable "transactor_java_opts" {
  description = "JAVA_OPTS to pass to Datomic (It's unclear what this actually does)"
  default = ""
}

variable "transactor_memory_index_max" {
  description = "Apply back pressure to let indexing catch up"
  default = "64m"
}

variable "transactor_memory_index_threshold" {
  description = "Start building index when this is reached"
  default = "16m"
}

variable "transactor_object_cache_max" {
  description = "Size of the object cache"
  default = "128m"
}

variable "vpc_id" {
  description = "The id of the VPC to deploy into"
}

variable "vpc_ip_block" {
  description = "VPC internal IP cidr block for ec2 machines"
}
