
# ---------------------------------------------------------------------------------------------------------------------
# Data EFS filesystem
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_efs_file_system" "ecs-efs" {
  encrypted = true
  lifecycle {
    prevent_destroy = true # cant use var.environment.resource_deletion_protection
  }
  tags = merge(var.global_default_tags, var.environment.default_tags, {
    Name            = "${var.environment.resource_name_prefix}-ecs-efs"
    Application     = "ecs"
    ApplicationName = "prpl"
  })
}
resource "aws_efs_mount_target" "ecs-efs" {
  count           = length(var.vpc_private_subnet_ids)
  file_system_id  = aws_efs_file_system.ecs-efs.id
  subnet_id       = var.vpc_private_subnet_ids[count.index]
  security_groups = [var.ecs_cluster_efs_security_group_id]
}
//locals {
//  docker_user_uid = 5000
//  docker_user_gid = 5000
//}
//resource "aws_efs_access_point" "ecs-efs-prpl" {
//  file_system_id    = aws_efs_file_system.ecs-efs.id
//  posix_user {
//    gid             = local.docker_user_gid
//    uid             = local.docker_user_uid
//  }
//  root_directory {
//    path            =  "/prpl"
//    creation_info {
//      owner_gid = local.docker_user_gid
//      owner_uid = local.docker_user_uid
//      permissions = "770"
//    }
//  }
//  tags = merge(var.global_default_tags, var.environment.default_tags, {
//    Name            = "${var.environment.resource_name_prefix}-ecs-prpl"
//    Application     = "ecs"
//    ApplicationName = "prpl"
//  })
//}
//resource "aws_efs_access_point" "ecs-efs-prpl-mariadb" {
//  file_system_id    = aws_efs_file_system.ecs-efs.id
//  posix_user {
//    gid             = local.docker_user_gid
//    uid             = local.docker_user_uid
//  }
//  root_directory {
//    path            =  "/var/lib/mysql"
//    creation_info {
//      owner_gid = local.docker_user_gid
//      owner_uid = local.docker_user_uid
//      permissions = "770"
//    }
//  }
//  tags = merge(var.global_default_tags, var.environment.default_tags, {
//    Name            = "${var.environment.resource_name_prefix}-ecs-prpl-mariadb"
//    Application     = "ecs"
//    ApplicationName = "prpl"
//  })
//}