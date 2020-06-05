# Setup Notes and instructions


```
1. These templates are to be used only in a pre-configured A Cloud Guru hands-on lab environment
   for the Hands-on lab:
   "Creating Route53 records(Alias) to route traffic to an ALB using Terraform"
   Trying to deploy or set it up anywhere else would fail as there's info from bootstrapped files
   that this lab needs.

2. Once you SSH into TerraformController node as cloud_user, look for file resource_ids.txt,
   plug in the values for TF data variables from it into template import_resources.tf

3. Get the publicly hosted domain name(ending with a dot) by executing command in file
   aws_get_cp_hostedzone on the same TerraformController node and plug it into dns-name 
   variable in variables.tf
```

Execute terraform init, fmt, validate , plan and then finally apply!
