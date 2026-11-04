locals {
  # Prefix for all resource names, based on student ID and project name.
  name_prefix = "${var.student_id}-${var.project_name}"

  resource_group_name = "${local.name_prefix}-rg"

  # Added in part E of Module 7.
  common_tags = {
    owner      = var.student_id
    course     = "iac"
    module     = "module-07"
    managed_by = "pipeline"
  }
}