data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_exec_iam_role" {
  name = "webapp-task-exec-iam-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json

}

resource "aws_iam_role_policy_attachment" "task_exec_policy" {
  role       = aws_iam_role.task_exec_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}



#------------------------



resource "aws_iam_role" "task_iam_role" {
  name = "webapp-task-iam-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

