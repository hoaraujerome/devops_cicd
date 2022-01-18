resource "aws_instance" "instance" {
  ami             = var.instance_ami
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  security_groups = var.security_group_ids

  tags = {
    Name      = "${var.project}-${var.environment}-${var.role}"
    ManagedBy = "${var.iac_tool}"
  }
}