resource "tls_private_key" "ansible_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "local_file" "tofu_ssh_key" {
    content     = tls_private_key.ansible_key.private_key_pem
    filename = "${path.module}/id_rsa_tofu.pem"
    file_permission = "0600"
}
