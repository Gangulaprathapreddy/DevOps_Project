
resource "aws_instance" "r100c96" {
  ami               = "ami-0a9d27a9f4f5c0efc"
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1b"
  key_name          = aws_key_pair.exam_testing.key_name

  tags = {
    Name = "Terraform-diff-linux"
  }

  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname cloudEc2.technix.com"]
    connection {
      host        = self.public_dns
      type        = "ssh"
      user        = "ec2-user"
      private_key = aws_key_pair.exam_testing.private_key_pem
    }
  }

  provisioner "local-exec" {
    command = "echo ${self.public_dns} > inventory"
  }

  provisioner "local-exec" {
    command     = "ansible-playbook -i ${aws_instance.r100c96.public_ip}, --private-key ./aws-exam-testing.pem nginx.yaml"
    working_dir = path.module  # Added to set the working directory
  }
}

resource "aws_key_pair" "exam_testing" {
  key_name   = "aws-exam-testing"
  public_key = file("aws-exam-testing.pub")
}

output "ip" {
  value = aws_instance.r100c96.public_ip
}

output "publicName" {
  value = aws_instance.r100c96.public_dns
}
