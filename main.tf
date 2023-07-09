provider "aws" {

region     = "us-east-1" 
access_key = "ASIAXTTGYA7GHW6EBWMV" 
secret_key = "ctMhOW84aJUJMXNsMRrYZfQCOS7bFjNf/4rxmDU2" 
token = "FwoGZXIvYXdzECkaDHhNzYjvXkvwecEUPSKyAejQT28YYpSont9agDGiv2RTcF6Hd8nQrlZKyZIQnJ85ibCKq0sYbU68s4H9/0L0kdqXJuLF9qm9h5ElNe956SdxpBUDFOdjx4m7IyEVjuR4LfJGl5iYjnyzIwQ3jDuhje6/HJRcZnNzwNXe2z6245/4ei8DAwmpejKDBNeP8+WX2fuxrj00hy69zA0cBdcMcVpPvLu2Anx1qwY5IlK7rEWFLfmD30X3C5d6c5DmJio1pewooaqrpQYyLXVq6nnAONBQFSFlSHyBpAnEvFkcvprztY3MRQ/K/XMRk10kGDxHFbdG85h7Qg=="

}

resource "aws_key_pair" "sam-key" {

    key_name = "sam-key"

    public_key = file("sam-key.pub")

}

resource "aws_security_group" "web-sg" {

  name = "web-sg"

  ingress {

    from_port   = 80

    to_port     = 80

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

resource "aws_instance" "CapstoneDocker" {

	ami           = "ami-02f3f602d23f1659d"
	instance_type = "t2.micro"
	key_name      = aws_key_pair.sam-key.key_name
        vpc_security_group_ids = [aws_security_group.web-sg.id]
	tags = {

		Name = "CapstoneRemoteDocker"

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

		type        = "ssh"

		host        = self.public_ip

		user        = "ec2-user"

		private_key = file("sam-key")

		# Default timeout is 5 minutes

		

	}



	

} 
