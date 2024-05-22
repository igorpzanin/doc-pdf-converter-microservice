data "aws_iam_policy_document" "ec2-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

#-------------EC2 Role-----------

data "aws_iam_policy_document" "roles" {
  statement {
    sid       = "AllowEc2Actions"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:*"
    ]
  }

  statement {
    sid       = "AllowS3Actions"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:*"
    ]
  }

  statement {
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
    actions   = ["logs:CreateLogGroup"]
  }
}

resource "aws_iam_role" "roles" {
  name               = "${var.instance_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2-assume-role.json
}

resource "aws_iam_policy" "roles" {
  name   = "${var.instance_name}-ec2-execute-policy"
  policy = data.aws_iam_policy_document.roles.json
}

resource "aws_iam_role_policy_attachment" "role-execute" {
  policy_arn = aws_iam_policy.roles.arn
  role       = aws_iam_role.roles.name
}

