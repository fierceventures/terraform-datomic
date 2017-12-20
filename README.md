# AWS Datomic

This module can be used to deploy AWS datomic transactor and dynamodb.

Module Input Variables
----------------------

- `aws_account` - The AWS account id 
- `datomic_licence` - The datomic licence key
- `datomic_version` - The datomic version. Defaults to `0.9.5530`
- `dynamo_read_capacity` - One read capacity unit represents one strongly consistent read per second, or two eventually consistent reads per second, for items up to 4 KB in size. Defaults to `50`.
- `dynamo_write_capactiy` - One write capacity unit represents one write per second for items up to 1 KB in size. Defaults to 50
- `peer_role_id` - The elastic beanstalk role id
- `peer_role_name` - The elastic beanstalk role name
- `region` - The region to deploy into
- `transactor_instance_type` - The transactor instance type. Defaults to t2.micro
- `transactor_instance_virtualization_type` - Visualization type for the instance. Defaults to `hvm`
- `transactors` - The number of transactors to run. Defaults to `1`.
- `subnet` - The subnet id
- `transactor_deploy_bucket` - The bucket containing datomic and startup script. Defaults to `deploy-a0dbc565-faf2-4760-9b7e-29a8e45f428e`
- `transactor_xmx` - The maximum size, in bytes, of the memory allocation pool. This value must a multiple of 1024 greater than 2MB. Defaults to `512m`.
- `transactor_java_opts` - JAVA_OPTS to pass to Datomic (It's unclear what this actually does). Defaults to empty string.
- `transactor_memory_index_max` - Apply back pressure to let indexing catch up. Defaults to `64m`.
- `transactor_memory_index_threshold` - Start building index when this is reached. Defaults to `16m`.
- `transactor_object_cache_max` - Size of the object cache. Defaults to `128m`.
- `vpc_id` - The vpc id to deploy into
- `vpc_ip_block` - VPC internal IP cidr block for ec2 machines

Usage 
-----

```hcl
module datomic {
  source = "github.com/fierceventures/terraform-datomic"
  aws_account = "${var.aws_account}"
  datomic_license = "${var.datomic_license}"
  peer_role_id = "${module.server.eb_role_id}"
  peer_role_name = "${module.server.eb_role_name}"
  region = "${var.region}"
  subnet = "${module.vpc.private_subnet_2_id}"
  vpc_id = "${module.vpc.id}"
  vpc_ip_block = "${module.vpc.datomic_cidr_block}"
}
```

Outputs
-------
- 

Author
------
Created and maintained by [Fierce Ventures](https://github.com/fierceventures/)
