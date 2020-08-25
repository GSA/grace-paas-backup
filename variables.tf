variable "project_name" {
  type        = string
  description = "(required) The project name used when creating resources in the destination account (e.g. myproject)"
}

variable "env" {
  type        = string
  description = "(optional) The application environment name"
  default     = "development"
}

variable "region" {
  type        = string
  description = "(optional) The AWS Region to be used when deploying region-specific resources (default: us-east-1)"
  default     = "us-east-1"
}

variable "partial_backup_schedule" {
  type        = string
  description = "(optional) The cron backup schedule for partial backups"
  default     = "cron(0 0 0 ? * MON,TUE,WED,THU,FRI,SAT *)"
}

variable "full_backup_schedule" {
  type        = string
  description = "(optional) The cron backup schedule for full backups"
  default     = "cron(0 0 0 ? * 1/1 *)"
}

variable "backup_retention_days" {
  type        = string
  description = "(optional) The max number of days to retain backups"
  default     = "365"
}

variable "backup_cold_storage_days" {
  type        = string
  description = "(optional) The number of days to wait before moving backups to cold storage"
  default     = "90"
}