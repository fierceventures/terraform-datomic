resource "aws_iam_role" "transactor" {
  name = "${terraform.workspace}-transactors"

  assume_role_policy = <<EOF
{"Version": "2012-10-17",
 "Statement":
 [{"Action": "sts:AssumeRole",
   "Principal": {"Service": "ec2.amazonaws.com"},
   "Effect": "Allow",
   "Sid": ""}]}
EOF
}

resource "aws_iam_role_policy" "transactor" {
  name = "dynamo_access"
  role = "${aws_iam_role.transactor.id}"

  policy = <<EOF
{"Statement":
 [{"Effect":"Allow",
   "Action":["dynamodb:*"],
   "Resource":"arn:aws:dynamodb:*:${var.aws_account}:table/${aws_dynamodb_table.datomic.name}"}]}
EOF
}

resource "aws_iam_role_policy" "transactor_cloudwatch" {
  name = "cloudwatch_access"
  role = "${aws_iam_role.transactor.id}"

  policy = <<EOF
{"Statement":
 [{"Effect":"Allow",
   "Resource":"*",
   "Condition":{"Bool":{"aws:SecureTransport":"true"}},
   "Action": ["cloudwatch:PutMetricData", "cloudwatch:PutMetricDataBatch"]}]}
EOF
}

resource "aws_s3_bucket" "transactor_logs" {
  bucket = "${terraform.workspace}-transactor-logs"
  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_role_policy" "transactor_logs" {
  name = "s3_logs_access"
  role = "${aws_iam_role.transactor.id}"

  policy = <<EOF
{"Statement":
 [{"Effect": "Allow",
   "Action": ["s3:PutObject"],
   "Resource": ["arn:aws:s3:::${aws_s3_bucket.transactor_logs.id}",
                "arn:aws:s3:::${aws_s3_bucket.transactor_logs.id}/*"]}]}
EOF
}

resource "aws_iam_instance_profile" "transactor" {
  name = "${terraform.workspace}_datomic_transactor"
  role = "${aws_iam_role.transactor.name}"
}

resource "aws_security_group" "datomic" {
  vpc_id = "${var.vpc_id}"
  name = "${terraform.workspace}-datomic-access"
  description = "Allow access to the database from the default vpc"

  ingress {
    from_port = 4334
    to_port = 4334
    protocol = "tcp"
    self = true
    cidr_blocks = [
      "${var.vpc_ip_block}",
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

data "aws_ami" "transactor" {
  most_recent = true
  owners = [
    "754685078599"]

  filter {
    name = "name"
    values = [
      "datomic-transactor-*"]
  }

  filter {
    name = "virtualization-type"
    values = [
      "${var.transactor_instance_virtualization_type}"]
  }
}

data "template_file" "transactor_user_data" {
  template = "${file("${path.module}/scripts/transactor.sh")}"

  vars {
    xmx = "${var.transactor_xmx}"
    java_opts = "${var.transactor_java_opts}"
    datomic_bucket = "${var.transactor_deploy_bucket}"
    datomic_version = "${var.datomic_version}"
    aws_region = "${var.region}"
    transactor_role = "${aws_iam_role.transactor.name}"
    peer_role = "${var.peer_role_name}"
    memory_index_max = "${var.transactor_memory_index_max}"
    s3_log_bucket = "${aws_s3_bucket.transactor_logs.id}"
    memory_index_threshold = "${var.transactor_memory_index_threshold}"
    cloudwatch_dimension = "${terraform.workspace}"
    object_cache_max = "${var.transactor_object_cache_max}"
    license-key = "${var.datomic_license}"
    dynamo_table = "${aws_dynamodb_table.datomic.name}"
  }
}

resource "aws_launch_configuration" "transactor" {
  name_prefix = "${terraform.workspace}-transactor-"
  image_id = "${data.aws_ami.transactor.id}"
  instance_type = "${var.transactor_instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.transactor.name}"
  associate_public_ip_address = true
  security_groups = [
    "${aws_security_group.datomic.id}"
  ]
  user_data = "${data.template_file.transactor_user_data.rendered}"

  ephemeral_block_device {
    device_name = "/dev/sdb"
    virtual_name = "ephemeral0"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "transactors" {
  vpc_zone_identifier = [
    "${var.subnet}"
  ]
  name = "${terraform.workspace}_transactors"
  max_size = "${var.transactors}"
  min_size = "${var.transactors}"
  launch_configuration = "${aws_launch_configuration.transactor.name}"

  tag {
    key = "Name"
    value = "${terraform.workspace}-transactor"
    propagate_at_launch = true
  }
}

