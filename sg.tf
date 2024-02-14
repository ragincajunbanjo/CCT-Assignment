# Creates a security group with inbound on port 80 from any ip and outbound to any ip
resource "aws_security_group" "main" {
  name = "${var.name}-sg"
  vpc_id = aws_vpc.main.id

  ingress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] //This allows traffic from any IP, but can be restricted to a specific IP or range and can be used to block access from certain IPs
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] //This allows traffic to any IP, but can be restricted to a specific IP or range
  }
}
