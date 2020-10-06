
<h1>Dynamic Ansible Inventory querying configuration</h1><br />

```
1. This configuration file is to be used in conjunction with enabling the dynamic inventory module in ansible.cfg file
2. Official documentation can be found here: https://docs.ansible.com/ansible/latest/collections/amazon/aws/aws_ec2_inventory.html
```

<h2>Notes and Instructions</h2><br />

*How it works*
Enabling the aws_ec2 inventory module as shown in the lesson "Configuring Terraform Provisioners and Config Mangagement via Ansible". This module once enabled uses this yaml configuration file to use the preconfigured aws credentials and poll for EC2 instances in the region(s) as set up in this YAML configuration file. So instead of hard-coding IP addresses in static inventory files, Ansible can get the IP addresses for EC2 instances on the fly using the tag names that we assigned to those instances when creating them via Terraform. How this Ansible module gets the tags you might ask, well that's also defined in this configuration file.

