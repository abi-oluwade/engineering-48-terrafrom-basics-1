# Terraform Basics

In our stack we have:
- Terraform = orchestration tool that deploys the image into cloud (for example ec2 instance) and setups up infrastructure(vpc, networking etc), so has the image and does the networking as well
- Chef = configuration management tool and sets up the machine and can provision it (e.g recipes, metadata, berks_cookbook, unit and spec tests, kitchen.yml and more)
- Packer = creates an immutable image of that machine

Terraform plan = Validates the main.tf file to ensure the syntax is correct and no conflicts, as well as what it will try to do.
Terraform refresh = used when the terraform.rfstate file becomes out of sync.
Terraform apply = applies and creates the resources specified in the main.tf file in the defined infrastructure.
