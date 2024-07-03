# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
data "aws_caller_identity" "current" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "assume_role_policy_document" {
  statement {
    sid = "1"
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    principals {
      type = "*"
      identifiers = ["*"]
    }
    condition {
      test = "ArnEquals"
      variable = "aws:PrincipalArn"
      values = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/*"]
    }
  }
}

data "aws_iam_policy_document" "group_policy_document" {
  statement {
    sid = "1"
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    resources = [aws_iam_role.role.arn]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "role" {
  name = "${var.resource_prefix}_${var.env}_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_document.json
  tags = merge(var.tags, {"env" = var.env})
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group
resource "aws_iam_group" "group" {
  name = "${var.env}_group"
  path = "/${var.resource_prefix}/groups/"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy
resource "aws_iam_group_policy" "group_policy" {
  name = "${var.resource_prefix}_${var.env}_group_policy"
  group = aws_iam_group.group.name
  policy = data.aws_iam_policy_document.group_policy_document.json
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user
resource "aws_iam_user" "user" {
  name = "${var.env}_user"
  path = "/${var.resource_prefix}/users/"
  tags = merge(var.tags, {"env" = var.env})
  # Should also use a permissions boundary
}

resource "aws_iam_group_membership" "group_membership" {
  name = "${var.resource_prefix}_${var.env}_group_membership"
  users = [aws_iam_user.user.name] # Could add more users here and have it be a single source of truth for this group's membership
  group = aws_iam_group.group.name
}