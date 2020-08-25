resource "aws_backup_vault" "backup_vault" {
  name        = "backup_vault"
  kms_key_arn = aws_kms_key.key.arn
}

resource "aws_backup_plan" "backup" {
  name = "backup_plan"

  rule {
    rule_name         = "tf_example_backup_rule"
    target_vault_name = aws_backup_vault.backup_vault.name
//    schedule          = "cron(0 0 0 ? * MON,TUE,WED,THU,FRI,SAT,SUN *)"
    schedule = "cron(0 0/5 0 ? * * *)"

    lifecycle {
      cold_storage_after = var.backup_cold_storage_days
      delete_after = var.backup_retention_days
    }
  }
}

resource "aws_backup_selection" "backup_selection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "tf_example_backup_selection"
  plan_id      = aws_backup_plan.backup.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backup"
    value = "true"
  }
}
