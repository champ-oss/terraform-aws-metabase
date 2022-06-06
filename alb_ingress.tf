resource "aws_security_group_rule" "alb_ingress_http_sg" {
  for_each                 = var.ingress_source_security_group_ids
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = each.value
}

resource "aws_security_group_rule" "alb_ingress_http_cidr" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = var.ingress_cidr_blocks
}

resource "aws_security_group_rule" "alb_ingress_https_sg" {
  for_each                 = var.ingress_source_security_group_ids
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = each.value
}

resource "aws_security_group_rule" "alb_ingress_https_cidr" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = var.ingress_cidr_blocks
}
