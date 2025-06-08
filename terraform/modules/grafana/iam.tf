# ECS Execution Role
resource "aws_iam_role" "ecs_execution" {
  name = "${var.name_prefix}-grafana-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-grafana-ecs-execution-role"
  })
}

# ECS Task Role
resource "aws_iam_role" "ecs_task" {
  name = "${var.name_prefix}-grafana-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-grafana-ecs-task-role"
  })
}

# Attach AWS managed policy for ECS execution
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# CloudWatch policy for ECS task
resource "aws_iam_role_policy_attachment" "ecs_task_cloudwatch_policy" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# Additional policy for Grafana to access CloudWatch metrics
resource "aws_iam_role_policy" "grafana_cloudwatch" {
  name = "${var.name_prefix}-grafana-cloudwatch-policy"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:GetMetricData",
          "cloudwatch:ListMetrics",
          "ec2:DescribeTags",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "tag:GetResources"
        ]
        Resource = "*"
      }
    ]
  })
} 