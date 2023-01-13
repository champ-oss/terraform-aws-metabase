module "aurora" {
  source                          = "github.com/champ-oss/terraform-aws-aurora.git?ref=v1.0.27-26f5fd1"
  backup_retention_period         = 5 # days
  cluster_identifier_prefix       = var.id
  cluster_instance_count          = var.cluster_instance_count
  database_name                   = "metabase"
  db_cluster_parameter_group_name = var.db_cluster_parameter_group_name
  enable_global_write_forwarding  = var.enable_global_write_forwarding
  git                             = var.id
  master_username                 = "root"
  max_capacity                    = var.max_capacity
  metric_alarms_enabled           = true
  protect                         = var.protect
  private_subnet_ids              = var.private_subnet_ids
  skip_final_snapshot             = false
  snapshot_identifier             = var.snapshot_identifier
  source_security_group_id        = aws_security_group.ecs.id
  tags                            = var.tags
  vpc_id                          = var.vpc_id
}