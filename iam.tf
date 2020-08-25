resource "aws_iam_role" "backup_role" {
  name               = "aws-backup-plan-${var.project_name}-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "backup_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_role.name
}

resource "aws_iam_policy" "backup_tag_policy" {
  description = "AWS Backup Tag policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "backup:TagResource",
            "backup:ListTags",
            "backup:UntagResource",
            "tag:GetResources"
        ],
        "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "backup_tag_policy_attach" {
  policy_arn = aws_iam_policy.backup_tag_policy.arn
  role       = aws_iam_role.backup_role.name
}

















# full-admin role
resource "aws_iam_role" "backup" {
  name               = "grace-backup"
  assume_role_policy = data.aws_iam_policy_document.saml_assume.json
}

resource "aws_iam_role" "ab_role" {
  count              = var.enabled ? 1 : 0
  name               = "aws-backup-plan-${var.plan_name}-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY

  tags = var.tags
}

data "aws_iam_policy_document" "backup_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "backup" {
  name               = "${var.project_name}-${var.env}-backup"
  description        = "Role is used by aws backup"
  assume_role_policy = data.aws_iam_policy_document.backup_role.json
}

data "aws_iam_policy_document" "hub_policy" {
  count = var.is_hub ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "ec2:"
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [aws_kms_key.lambda[0].arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = ["arn:aws:secretsmanager:${var.region}:${local.account_id}:secret:${var.prefix}*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:ListSecrets"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups",
      "logs:CreateLogStream",
      "logs:CreateLogGroup"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      "arn:aws:iam::${var.org_account_id}:role/${var.org_account_role_name}",
      "arn:aws:iam::*:role/${var.spoke_account_role_name}"
    ]
  }
}

resource "aws_iam_policy" "hub_policy" {
  count       = var.is_hub ? 1 : 0
  name        = local.app_name
  description = "Policy to allow lambda permissions for ${local.app_name}"
  policy      = data.aws_iam_policy_document.hub_policy[0].json
}

resource "aws_iam_role_policy_attachment" "hub_policy" {
  count      = var.is_hub ? 1 : 0
  role       = aws_iam_role.hub_role[0].name
  policy_arn = aws_iam_policy.hub_policy[0].arn
}