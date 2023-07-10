resource "aws_security_group" "dockersgnew" {

  name = "dockersgnew"

  ingress {

    from_port   = 80

    to_port     = 80

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

ingress {

    from_port   = 8084

    to_port     = 8084

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

ingress {

    from_port   = 8081

    to_port     = 8081

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }



  ingress {

    from_port   = 443

    to_port     = 443

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    from_port   = 22

    to_port     = 22

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port   = 0

    to_port     = 0

    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

}



resource "aws_key_pair" "sammykey" {

    key_name = "sambo-key"

    public_key = file("sambo-key.pub")

}



resource "aws_instance" "capstoneawsdocker" {

  ami           = "ami-02f3f602d23f1659d"

  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.dockersgnew.id]

  key_name      = aws_key_pair.sammykey.key_name



  tags = {

    Name = "capstone-aws-docker"

  }



  provisioner "file" {

      source      = "remotedocker.sh"

      destination = "/tmp/remotedocker.sh"

  }



  provisioner "remote-exec" {

    inline = [

      "chmod +x /tmp/remotedocker.sh",

      "sudo /tmp/remotedocker.sh",

    ]

  }



  connection {

    host        = self.public_ip

    type        = "ssh"

    user        = "ec2-user"

    private_key = file("sambo-key.pem")

    timeout = "4m"
  }

}


