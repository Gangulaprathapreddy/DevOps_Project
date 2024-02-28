
data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "dev_machine" {
  ami           = data.aws_ami.amazon-linux.id
  instance_type = "t2.micro"
  key_name      = "aws-exam-testing.pem"

  provisioner "local-exec" {
    command     = "ansible-playbook -i ${aws_instance.dev_machine.public_ip}, --private-key ./aws-exam-testing.pem nginx.yaml"
    working_dir = path.module  # Added to set the working directory
  }
}

resource "aws_key_pair" "exam_testing" {
  key_name = "aws-exam-testing.pem"
}

output "ip" {
  value = aws_instance.dev_machine.public_ip
}

output "publicName" {
  value = aws_instance.dev_machine.public_dns
}

output "public_key" {
  value = aws_key_pair.exam_testing.public_key
}

