# terraform-s3-deploy
Deploy code to S3 with terraform

### One-time deploy

###### terraform.tfvars
```hcl
arg = {
  force-update = false
}
```

Code will be deployed to S3 bucket only once with default settings.

### Every-time deploy

###### terraform.tfvars
```hcl
arg = {
  force-update = true
}
```

Setting variable `arg.force-update` to `true` will run `local-exec` every time you make an apply.
