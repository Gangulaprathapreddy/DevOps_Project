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
  key_name      = "terraform"  # Corrected key name

  provisioner "local-exec" {
    command     = "ansible-playbook -i ${aws_instance.dev_machine.public_ip}, --private-key ./path/to/your/private/key.pem nginx.yaml"  # Update private key path
    working_dir = path.module  # Added to set the working directory
  }
}

data "aws_key_pair" "exam_testing" {
  key_name = "terraform"  # Corrected key name
}

output "ip" {
  value = aws_instance.dev_machine.public_ip
}

output "publicName" {
  value = aws_instance.dev_machine.public_dns
}

output "public_key" {
  value = data.aws_key_pair.exam_testing.public_key
}

