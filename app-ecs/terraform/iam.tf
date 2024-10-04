data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

#------------------------------------------------<EXECUTION IAM ROLE>------------------------------------------------#

data "aws_iam_policy_document" "task_exec_policy" {
  statement {
    actions = [
      "s3:List*",
    ]

    resources = ["*"]
  }
}



data "aws_iam_policy" "amz_ecs_exec_policy" {
  name = "AmazonECSTaskExecutionRolePolicy"
}


resource "aws_iam_policy" "task_exec_policy" {
  name   = "webapp-task-exec-iam-role-policy"
  policy = data.aws_iam_policy_document.task_exec_policy.json
}


resource "aws_iam_role" "task_exec_iam_role" {
  name = "webapp-task-exec-iam-role"

  assume_role_policy  = data.aws_iam_policy_document.ecs_assume_role_policy.json
  managed_policy_arns = [data.aws_iam_policy.amz_ecs_exec_policy.arn, aws_iam_policy.task_exec_policy.arn]
}





#------------------------------------------------<TASK IAM ROLE>------------------------------------------------#



resource "aws_iam_role" "task_iam_role" {
  name = "webapp-task-iam-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

