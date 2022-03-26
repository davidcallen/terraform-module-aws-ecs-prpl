locals {
  name_suffix                        = (length(var.name_suffix) == 0) ? "" : "-${var.name_suffix}"
  name                               = "${var.environment.resource_name_prefix}-prpl${local.name_suffix}"
}