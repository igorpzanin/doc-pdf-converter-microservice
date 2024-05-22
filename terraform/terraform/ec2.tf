resource "aws_instance" "instance" {
  ami           = var.aws_ami
  instance_type = var.instance_type
  key_name      = var.key_pair
  tags = {
    Name       = var.instance_name
    managed-by = "terraform"
  }

  vpc_security_group_ids = [aws_security_group.sg.id]
  ebs_block_device {
    device_name           = var.device_name
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    delete_on_termination = true
  }
}
output "public_dns" {
  value = aws_instance.instance.public_dns
}

