output "public_ip" {

  value = aws_instance.capstoneawsdocker.public_ip 

}



output "public_dns" {

  value = aws_instance.capstoneawsdocker.public_dns

}
