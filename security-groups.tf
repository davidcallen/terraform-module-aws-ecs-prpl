# ---------------------------------------------------------------------------------------------------------------------
# Security Group for access to EFS for Volumes
# ---------------------------------------------------------------------------------------------------------------------
# Allow both ingress and egress for port 2049 (NFS) for our EC2 instances
# Restrict the traffic to within the VPC (and not outside).
//data "aws_security_group" "ecs-efs" {
//  name = "${var.environment.resource_name_prefix}-ecs-efs"
//}

//# ---------------------------------------------------------------------------------------------------------------------
//# Security Group rules for this docker service
//# ---------------------------------------------------------------------------------------------------------------------
//# All ingress to port 80 (http)
//resource "aws_security_group_rule" "allow-ingress-http" {
//  type            = "ingress"
//  description     = "http"
//  from_port       = 80
//  to_port         = 80
//  protocol        = "tcp"
//  cidr_blocks     = ["0.0.0.0/0"]             # TODO - change to var.allowed_ingress_cidrs.ssh
//  security_group_id = aws_security_group.ecs.id
//}
//# All ingress to port 80 (https)
//resource "aws_security_group_rule" "allow-ingress-https" {
//  type            = "ingress"
//  description     = " https"
//  from_port       = 443
//  to_port         = 443
//  protocol        = "tcp"
//  cidr_blocks     = ["0.0.0.0/0"]             # TODO - change to var.allowed_ingress_cidrs.ssh
//  security_group_id = aws_security_group.ecs.id
//}
//
//# -----------------------------------------------   egress  -----------------------------------------------------------
//# All egress to http
//resource "aws_security_group_rule" "allow-egress-http" {
//  type            = "egress"
//  description     = "egress http"
//  from_port       = 80
//  to_port         = 80
//  protocol        = "tcp"
//  cidr_blocks     = var.allowed_egress_cidrs.http
//  security_group_id = aws_security_group.ecs.id
//}
//resource "aws_security_group_rule" "allow-egress-https" {
//  type            = "egress"
//  description     = "egress https"
//  from_port       = 443
//  to_port         = 443
//  protocol        = "tcp"
//  cidr_blocks     = ["0.0.0.0/0"]     # allow egress to yum repos for updates
//  security_group_id = aws_security_group.ecs.id
//}
