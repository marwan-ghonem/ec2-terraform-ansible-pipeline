provider "aws" {
  region = "us-east-1"  # Change only if you're using a different AWS region
}

# ✅ Use latest Amazon Linux 2 AMI automatically
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  key_name                    = "terraform"  # 🔐 Must match the key pair name in your AWS account
  associate_public_ip_address = true

  tags = {
    Name = "JenkinsEC2"
  }
}

output "public_ip" {
  value = aws_instance.ec2.public_ip
}
