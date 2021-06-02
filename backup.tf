resource "aws_backup_vault" "backup_vault" {
  name        = "backup_vault"
  kms_key_arn = aws_kms_key.key.arn
}

resource "aws_backup_plan" "daily_backup" {
  name = "daily_backup"

  rule {
    rule_name         = "daily_backup_rule"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = var.daily_backup_schedule
    lifecycle {
      cold_storage_after = var.daily_backup_cold_storage_days
      delete_after       = var.daily_backup_retention_days
    }
  }
}

resource "aws_backup_selection" "daily_backup_selection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "daily_backup_selection"
  plan_id      = aws_backup_plan.daily_backup.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backup"
    value = "daily"
  }
}

resource "aws_backup_plan" "monthly_backup" {
  name = "monthly_backup_plan"

  rule {
    rule_name         = "monthly_backup_rule"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = var.monthly_backup_schedule
    lifecycle {
      cold_storage_after = var.monthly_backup_cold_storage_days
      delete_after       = var.monthly_backup_retention_days
    }
  }
}

resource "aws_backup_selection" "monthly_backup_selection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "monthly_backup_selection"
  plan_id      = aws_backup_plan.monthly_backup.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "backup"
    value = "monthly"
  }
}