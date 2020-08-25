# kms key policy document
data "aws_iam_policy_document" "key" {
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

# kms key
resource "aws_kms_key" "key" {
  description             = "Key used for the backend bucket"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.key.json
}

# kms key alias
resource "aws_kms_alias" "key" {
  name          = "alias/${var.project_name}-${var.appenv}-backup"
  target_key_id = aws_kms_key.key.key_id
}
