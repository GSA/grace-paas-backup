variable "project_name" {
  type        = string
  description = "(required) The project name used when creating resources in the destination account (e.g. myproject)"
}

variable "appenv" {
  type        = string
  description = "(optional) The application environment name"
  default     = "development"
}

variable "region" {
  type        = string
  description = "(optional) The AWS Region to be used when deploying region-specific resources (default: us-east-1)"
  default     = "us-east-1"
}

variable "daily_backup_schedule" {
  type        = string
  description = "(optional) The cron backup schedule for full backups"
  default     = "cron(0 2 * * ? *)"
}

variable "daily_backup_retention_days" {
  type        = string
  description = "(optional) The max number of days to retain backups"
  default     = "365"
}

variable "daily_backup_cold_storage_days" {
  type        = string
  description = "(optional) The number of days to wait before moving backups to cold storage"
  default     = "30"
}

variable "monthly_backup_schedule" {
  type        = string
  description = "(optional) The cron backup schedule for full backups"
  default     = "cron(0 2 1 * ? *)"
}

variable "monthly_backup_retention_days" {
  type        = string
  description = "(optional) The max number of days to retain backups"
  default     = "365"
}

variable "monthly_backup_cold_storage_days" {
  type        = string
  description = "(optional) The number of days to wait before moving backups to cold storage"
  default     = "1"
}