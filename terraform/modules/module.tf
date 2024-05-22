module "microservice" {
  source         = "../terraform"
  instance_name  = "microservice"
  instance_type  = "t2.micro"
  key_pair = "aws-ec2-server"

  private_key   = "/your/path/aws-ec2-server.pem" # Change for your aws-ec2-server.pem

  device_name = "/dev/xvda"
  volume_size = 8
  volume_type = "gp2"
  vpc = "vpc-0b4b356398849ce24"
  aws_ami = "ami-080e1f13689e07408"
  description = "Microservice-ec2-server"
}