# ---------------------------------------------------------------------------------------------------------------------
# ECS Task Role
# 1) Grant logging to CloudWatch
# 2) Grant access to the Tasks Secrets in SSM ParameterStore
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "ecs-task-prpl" {
  name               = "${var.environment.resource_name_prefix}-ecs-task-prpl"
  assume_role_policy = data.aws_iam_policy_document.ecs-task-prpl.json
}
data "aws_iam_policy_document" "ecs-task-prpl" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# 1) Grant logging to CloudWatch
resource "aws_iam_policy" "ecs-task-prpl-cloudwatch" {
  name        = "${var.environment.resource_name_prefix}-ecs-task-prpl-cloudwatch"
  description = "Allow ECS Task to write its logs to Cloudwatch"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "ecs-task-prpl-cloudwatch" {
  role       = aws_iam_role.ecs-task-prpl.name
  policy_arn = aws_iam_policy.ecs-task-prpl-cloudwatch.arn
}

// # 2) Grant access to the Tasks Secrets in SSM ParameterStore
//resource "aws_iam_policy" "ecs-task-prpl-ssm" {
//  name        = "${var.environment.resource_name_prefix}-ecs-task-prpl-ssm"
//  description = "Allow ECS Agent to read SSM Parameter values for Secrets"
//  policy      = <<EOF
//{
//   "Version": "2012-10-17",
//   "Statement": [
//       {
//           "Effect": "Allow",
//           "Action": [
//               "ssm:DescribeParameters"
//           ],
//           "Resource": "*"
//       },
//       {
//           "Sid": "AllowSSMGetParams",
//           "Effect": "Allow",
//           "Action": [
//               "ssm:GetParameters"
//           ],
//           "Resource": [
//              "${aws_ssm_parameter.prpl-db-admin.arn}",
//              "${aws_ssm_parameter.prpl-db-user.arn}"
//           ]
//       },
//       {
//           "Sid": "AllowSSMDecryptParams",
//           "Effect": "Allow",
//           "Action": [
//               "kms:Decrypt"
//           ],
//           "Resource": [
//              "${aws_ssm_parameter.prpl-db-admin.arn}",
//              "${aws_ssm_parameter.prpl-db-user.arn}"
//           ]
//       }
//   ]
//}
//EOF
//}
//resource "aws_iam_role_policy_attachment" "ecs-task-prpl" {
//  role       = aws_iam_role.ecs-task-prpl.name
//  policy_arn = aws_iam_policy.ecs-task-prpl-ssm.arn
//}

# ---------------------------------------------------------------------------------------------------------------------
# ECS Container Agent  (as used on Task Execution role)
# 1) Grant Service Role AmazonECSTaskExecutionRolePolicy
# 2) Grant logging to CloudWatch
# 3) Grant access to the Tasks Secrets in SSM ParameterStore
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "ecs-task-execution-prpl" {
  name               =  "${var.environment.resource_name_prefix}-ecs-task-execution-prpl"
  assume_role_policy = data.aws_iam_policy_document.ecs-task-execution-prpl.json
}

# 1) Grant Service Role AmazonECSTaskExecutionRolePolicy
data "aws_iam_policy_document" "ecs-task-execution-prpl" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
resource "aws_iam_role_policy_attachment" "ecs-task-execution-prpl" {
  role       = aws_iam_role.ecs-task-execution-prpl.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# 2) Grant logging to CloudWatch
resource "aws_iam_policy" "ecs-task-execution-prpl-cloudwatch" {
  name        = "${var.environment.resource_name_prefix}-ecs-task-execution-prpl-cloudwatch"
  description = "Allow ECS Container Agent to write its logs to Cloudwatch"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "ecs-task-execution-prpl-cloudwatch" {
  role       = aws_iam_role.ecs-task-execution-prpl.name
  policy_arn = aws_iam_policy.ecs-task-execution-prpl-cloudwatch.arn
}

# 3) Grant access to the Tasks Secrets in SSM ParamaterStore
resource "aws_iam_policy" "ecs-task-execution-prpl-ssm" {
  name        = "${var.environment.resource_name_prefix}-ecs-task-execution-prpl-ssm"
  description = "Allow ECS Container Agent to read SSM Parameter values for Secrets"
  policy      = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": [
               "ssm:DescribeParameters"
           ],
           "Resource": "*"
       },
       {
           "Sid": "AllowSSMGetParams",
           "Effect": "Allow",
           "Action": [
               "ssm:GetParameters"
           ],
           "Resource": "*"
       },
       {
           "Sid": "AllowSSMDecryptParams",
           "Effect": "Allow",
           "Action": [
               "kms:Decrypt"
           ],
           "Resource": [
              "arn:aws:ssm:eu-west-1:597767386394:parameter/prpl/database/admin/prpl/password",
              "arn:aws:ssm:eu-west-1:597767386394:parameter/prpl/database/user/prpl/password"
           ]
       }
   ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "ecs-task-execution-prpl-ssm" {
  role       = aws_iam_role.ecs-task-execution-prpl.name
  policy_arn = aws_iam_policy.ecs-task-execution-prpl-ssm.arn
}


# ---------------------------------------------------------------------------------------------------------------------
# IAM for Task to access EFS access points
# ---------------------------------------------------------------------------------------------------------------------
//resource "aws_iam_policy" "ecs-iam-efs" {
//  name               = "${var.environment.resource_name_prefix}-ecs-efs"
//  policy =<<EOF
//{
//  "Version": "2012-10-17",
//  "Id": "ecs-task-efs",
//  "Statement": [
//    {
//      "Sid": "App1Access",
//      "Effect": "Allow",
//      "Principal": { "AWS": "arn:aws:iam::111122223333:role/app1" },
//      "Action": [
//        "elasticfilesystem:ClientMount",
//        "elasticfilesystem:ClientWrite"
//      ],
//      "Condition": {
//        "StringEquals": {
//          "elasticfilesystem:AccessPointArn" : "arn:aws:elasticfilesystem:us-east-1:222233334444:access-point/fsap-01234567"
//        }
//      }
//    },
//    {
//      "Sid": "App2Access",
//      "Effect": "Allow",
//      "Principal": { "AWS": "arn:aws:iam::111122223333:role/app2" },
//      "Action": [
//        "elasticfilesystem:ClientMount",
//        "elasticfilesystem:ClientWrite"
//      ],
//      "Condition": {
//        "StringEquals": {
//          "elasticfilesystem:AccessPointArn" : "arn:aws:elasticfilesystem:us-east-1:222233334444:access-point/fsap-89abcdef"
//        }
//      }
//    }
//  ]
//}
//EOF
//}

