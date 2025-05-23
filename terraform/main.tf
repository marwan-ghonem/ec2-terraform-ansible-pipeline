provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2
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
