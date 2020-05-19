#Set S3 backend for persisting TF state file remotely, ensure bucket already exits
# And that AWS user being used by TF has read/write perms
terraform {
  backend "s3" {
    region  = "us-east-1"
    profile = "default"
    key     = "terraform-state-file/mystatefile.tfstate"
    bucket  = "<already-existing-buckets-name-here"
  }
}

#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.region-master
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Get Linux AMI ID using SSM Parameter endpoint in us-west-2
data "aws_ssm_parameter" "linuxAmiOregon" {
  provider = aws.region-worker
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "master-key" {
  provider   = aws.region-master
  key_name   = "jenkins"
  public_key = file("~/.ssh/id_rsa.pub")
}

#Create key-pair for logging into EC2 in us-west-2
resource "aws_key_pair" "worker-key" {
  provider   = aws.region-worker
  key_name   = "jenkins"
  public_key = file("~/.ssh/id_rsa.pub")
}

#Create and bootstrap EC2 in us-east-1
resource "aws_instance" "jenkins-master" {
  provider                    = aws.region-master
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  subnet_id                   = aws_subnet.subnet_1.id
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ansible_templates/inventory"
  }
  provisioner "local-exec" {
    command = <<EOD
cat <<EOF >> ansible_templates/inventory
${self.public_ip} ansible_user=ec2-user
EOF
EOD
  }

  provisioner "local-exec" {
    command = "aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-master} --instance-ids ${self.id} && ansible-playbook -i ansible_templates/inventory ansible_templates/install_jenkins.yaml"
  }
  tags = {
    Name = "jenkins-master-tf"
  }
}

#Create EC2 in us-west-2
resource "aws_instance" "jenkins-worker-oregon" {
  provider                    = aws.region-worker
  count                       = var.workers-count
  ami                         = data.aws_ssm_parameter.linuxAmiOregon.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.worker-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg-oregon.id]
  subnet_id                   = aws_subnet.subnet_1_oregon.id
  provisioner "local-exec" {
    command = <<EOD
cat <<EOF >> ansible_templates/inventory_worker
${self.public_ip} ansible_user=ec2-user
EOF
EOD
  }
  provisioner "local-exec" {
    when = destroy
    command = "sed -i '/${self.public_ip}/d' ansible_templates/inventory_worker &> /dev/null || echo"
  }
  provisioner "local-exec" {
    command = "aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-worker} --instance-ids ${self.id} && ansible-playbook --extra-vars 'master_ip=${aws_instance.jenkins-master.private_ip} worker_priv_ip=${self.private_ip}' -i ansible_templates/inventory_worker -l ${self.public_ip} ansible_templates/install_worker.yaml"
  }
  tags = {
    Name = join("-", ["jenkins-worker-tf", count.index + 1])
  }
}
