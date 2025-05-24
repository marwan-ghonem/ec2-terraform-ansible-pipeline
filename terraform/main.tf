provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2" {
  ami           = "ami-05fa00d4c63e32376"  # ✅ Updated valid AMI
  instance_type = "t2.micro"
  key_name      = "terraform"

  tags = {
    Name = "JenkinsEC2"
  }

  associate_public_ip_address = true
}

output "public_ip" {
  value = aws_instance.ec2.public_ip
}
