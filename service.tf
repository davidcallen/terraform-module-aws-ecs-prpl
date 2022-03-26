# A combined service containing application and database backend in a single Task.
# The containers in the Task communicate using docker links.
# These are not very secure since share env vars between containers and so should only be used in Dev/QA.
resource "aws_ecs_service" "ecs" {
  count           = (var.combined_service_enabled) ? 1 : 0
  name            = local.name
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.ecs[0].arn
  //  load_balancer {
  //    target_group_arn = var.load_balancer_target_group_arn_smtp
  //    container_name = local.name
  //    container_port = 25
  //  }
  # iam_role        = ""
  desired_count = 1
  //  # Net config required for awsvpc network mode
  //  network_configuration {
  //    subnets = var.vpc_private_subnet_ids
  //  }
  //  service_registries {
  //    registry_arn = var.ecs_cluster_service_registry_arn
  //  }
}
resource "aws_ecs_task_definition" "ecs" {
  count              = (var.combined_service_enabled) ? 1 : 0
  family             = var.environment.resource_name_prefix
  network_mode       = "bridge"
  task_role_arn      = aws_iam_role.ecs-task-prpl.arn
  execution_role_arn = aws_iam_role.ecs-task-execution-prpl.arn # For the ECS container agent
  container_definitions = templatefile("${path.module}/service-task-definition.template.json", {
    aws_region             = var.aws_region
    task_name_prefix       = local.name
    image_repository_url   = data.aws_ecr_repository.prpl.repository_url
    image_tag              = var.ecr_image_tag
    secrets_param_base_uri = "arn:aws:ssm:${var.aws_region}:${var.environment.account_id}:parameter"
  })
  volume {
    name = "prpl-db"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.ecs-efs.id
      # root_directory = "/docker-volumes/prpl-db" # note will be mounted inside the container at /var/lib/mysql
      root_directory = "/"
    }
  }
}
data "aws_ecr_repository" "prpl" {
  name = var.ecr_repository_name
}
