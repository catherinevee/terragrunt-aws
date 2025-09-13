# RDS Aurora Module - Using official AWS RDS module from Terraform Registry

module "rds_aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 8.0"

  name = "${var.environment}-${var.name}"

  engine         = var.engine
  engine_version = var.engine_version
  engine_mode    = var.engine_mode

  # Database configuration
  database_name   = var.database_name
  master_username = var.master_username
  master_password = var.master_password

  # Instance configuration
  instance_class = var.instance_class
  instances      = var.instances

  # VPC configuration
  vpc_id               = var.vpc_id
  db_subnet_group_name = var.db_subnet_group_name
  subnet_ids           = var.subnet_ids
  security_group_rules = var.security_group_rules

  # Backup configuration
  backup_retention_period   = var.backup_retention_period
  preferred_backup_window   = var.preferred_backup_window
  copy_tags_to_snapshot     = var.copy_tags_to_snapshot
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier

  # Monitoring configuration
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_arn                   = var.monitoring_role_arn
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period

  # Encryption configuration
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id

  # Maintenance configuration
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  preferred_maintenance_window = var.preferred_maintenance_window

  # Deletion protection
  deletion_protection = var.deletion_protection

  # Global cluster configuration
  global_cluster_identifier        = var.global_cluster_identifier
  global_cluster_member_identifier = var.global_cluster_member_identifier

  # Serverless v2 configuration
  serverlessv2_scaling_configuration = var.serverlessv2_scaling_configuration

  # Tags
  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.name}"
      Type = "rds-aurora"
    }
  )

  # Cluster tags
  cluster_tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.name}-cluster"
      Type = "rds-aurora-cluster"
    }
  )

  # Instance tags
  instance_tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.name}-instance"
      Type = "rds-aurora-instance"
    }
  )
}

# Additional Aurora resources
resource "aws_rds_cluster_parameter_group" "additional" {
  for_each = var.additional_cluster_parameter_groups

  family = each.value.family
  name   = "${var.environment}-${var.name}-${each.key}"

  dynamic "parameter" {
    for_each = each.value.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.name}-${each.key}"
      Type = "rds-cluster-parameter-group"
    }
  )
}

resource "aws_rds_cluster_instance" "additional" {
  for_each = var.additional_instances

  cluster_identifier = module.rds_aurora.cluster_identifier
  instance_class     = each.value.instance_class
  engine             = each.value.engine
  engine_version     = each.value.engine_version

  identifier = "${var.environment}-${var.name}-${each.key}"

  monitoring_interval = each.value.monitoring_interval
  monitoring_role_arn = each.value.monitoring_role_arn

  performance_insights_enabled          = each.value.performance_insights_enabled
  performance_insights_retention_period = each.value.performance_insights_retention_period

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.name}-${each.key}"
      Type = "rds-cluster-instance"
    }
  )
}
