resource "aws_security_group" "jenkins_server" {
  name        = "${var.project}-${var.environment}-jenkins_server-sg"
  description = "Security Group For Jenkins Server"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name      = "${var.project}-${var.environment}-jenkins_server-sg"
    ManagedBy = "${var.iac_tool}"
  }
}

resource "aws_security_group_rule" "ec2-instance-connect_in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["35.183.92.176/29"]
  description       = "Allow SSH for EC2InstanceConnect from Canada central region"
  security_group_id = aws_security_group.jenkins_server.id
}

resource "aws_security_group_rule" "everywhere_in_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_server.id
}

resource "aws_security_group_rule" "everywhere_in_8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_server.id
}

resource "aws_security_group_rule" "everywhere_out_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_server.id
}

resource "aws_security_group_rule" "everywhere_out_http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_server.id
}