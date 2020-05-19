resource "null_resource" "inventory_master" {
  triggers = {
    my_value1 = join(",", [aws_key_pair.master-key.key_name])
  }
  provisioner "local-exec" {
    command = <<EOD
cat <<EOF > ansible_templates/inventory
localhost ansible_connection=local
[jenkins-master]
EOF
EOD
  }
}

resource "null_resource" "inventory_worker" {
  triggers = {
    my_value2 = join(",", [aws_key_pair.worker-key.key_name])
  }
  provisioner "local-exec" {
    command = <<EOD
cat <<EOF > ansible_templates/inventory_worker
localhost ansible_connection=local
[worker]
EOF
EOD
  }
}

resource "null_resource" "del_inventory_master" {
  triggers = {
    my_value1 = join(",", [aws_key_pair.master-key.key_name])
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ansible_templates/inventory"
  }
}

resource "null_resource" "del_inventory_worker" {
  triggers = {
    my_value2 = join(",", [aws_key_pair.worker-key.key_name])
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f  ansible_templates/inventory_worker"
  }
}
