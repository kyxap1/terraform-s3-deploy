locals {
  name   = "app-deploy"
  update = lookup(var.arg, "update", false)
}

resource "random_id" "bucket" {
  byte_length = 4
}

resource "random_pet" "bucket" {
  prefix = local.name
}

module "bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "1.17.0"

  bucket        = "${random_pet.bucket.id}-${random_id.bucket.hex}"
  acl           = "private"
  force_destroy = true
}

resource "random_id" "trigger" {
  count       = local.update ? 1 : 0
  byte_length = 4

  keepers = {
    uuid = uuid()
  }
}

resource "null_resource" "deploy" {
  provisioner "local-exec" {
    command = <<EOF
    aws s3 sync --delete files/ s3://${module.bucket.this_s3_bucket_id}
    EOF
  }

  triggers = {
    update = element(concat(random_id.trigger.*.hex, list("")), 0)
  }
}
