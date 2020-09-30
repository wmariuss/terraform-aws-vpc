resource "aws_flow_log" "vpc_flow_log" {
  count                = var.create_vpc ? 1 : 0
  log_destination      = aws_cloudwatch_log_group.vpc_log_group.arn
  log_destination_type = "cloud-watch-logs"
  iam_role_arn         = aws_iam_role.FlowLog_Role.arn
  vpc_id               = join("", aws_vpc.vpc.*.id)
  traffic_type          = var.traffic_type
  depends_on           = [aws_vpc.vpc, aws_iam_role.FlowLog_Role, aws_iam_role_policy.FlowLog_policy]
}

resource "aws_cloudwatch_log_group" "vpc_log_group" {
  name              = format("%s-log-group", var.name)
  retention_in_days = var.logs_retention_in_days

  tags = merge(map("Name", format("%s-log-group", var.name)), var.tags)
}

resource "aws_iam_role" "FlowLog_Role" {
  name = format("%s-role-flow-log", var.name)

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "vpc-flow-logs.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = merge(map("Name", format("%s-role-flow-log", var.name)), var.tags)
}

resource "aws_iam_role_policy" "FlowLog_policy" {
  name = format("%s-policy-role-flow-log", var.name)
  role = aws_iam_role.FlowLog_Role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
