resource "aws_backup_vault" "backup_vault" {
  name        = "backup_vault"
  kms_key_arn = aws_kms_key.key.arn
}

resource "aws_backup_plan" "full_backup" {
  name = "full_backup_plan"

  rule {
    rule_name         = "tf_example_backup_rule"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = "cron(0 0 0 ? * 1/1 *)"
  }

  lifecycle {
    cold_storage_after = var.backup_cold_storage_days
    delete_after = var.backup_retention_days
  }
}

resource "aws_backup_selection" "full_backup_selection" {
  iam_role_arn = aws_iam_role.backup
  name         = "tf_example_backup_selection"
  plan_id      = aws_backup_plan.full_backup.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backup"
    value = "true"
  }
}

resource "aws_backup_plan" "partial_backup" {
  name = "partial_backup_plan"

  rule {
    rule_name         = "tf_example_backup_rule"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = "cron(0 0 0 ? * MON,TUE,WED,THU,FRI,SAT *)"
  }

  lifecycle {
    cold_storage_after = var.backup_cold_storage_days
    delete_after = var.backup_retention_days
  }
}

resource "aws_backup_selection" "partial_backup_selection" {
  iam_role_arn = aws_iam_role.backup
  name         = "tf_example_backup_selection"
  plan_id      = aws_backup_plan.partial_backup.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backup"
    value = "true"
  }
}
