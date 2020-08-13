# Setup notes

```
1. Please run the playbook "gen_ssh_key.yaml" , "ansible-playbook ansible_templates/gen_ssh_key.yaml" 
   to generate SSH keypair(on local system) used in TF templates and Ansible for connecting to 
   remote EC2 instances.
   
2. If you still want to initialize directory via "terraform init", then use the "-backend=false" flag,
   like so "terraform init -backend=false"
```

## GENERAL NOTE:

```
The templates in this folder are meant to be used in the ACG Hands-on lab, however it should 
work in any AWS account, given that the above 3 conditions are met. However this has not been tested
extensively and author gives no guarantees for it.
```
