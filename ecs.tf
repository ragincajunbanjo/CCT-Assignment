# Creates an ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.name}-ecs-cluster"
}

# Creates an ECS Task Definition with Fargate compatibilites
resource "aws_ecs_task_definition" "main" {
  family = "${var.name}-ecs-task"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = "256"
  memory = "512"

  container_definitions = jsonencode([
    {
      name = "${var.name}-nginx"
      image = "nginx:latest"
      portMappings = [
        {
          containerPort = 80
          hostPort = 80
          protocol = "tcp"
        }
      ]
    }
  ])
}

# Creates an ECS Service with the Fargate Launch Type
resource "aws_ecs_service" "main" {
  name = "${var.name}-ecs-service"
  cluster = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  launch_type = "FARGATE"
  desired_count = var.desired_count //This allows us to have multiple instances of the task running for availability and performance

  network_configuration {
    subnets = [for s in aws_subnet.private: s.id]
    security_groups = [aws_security_group.main.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name = "${var.name}-nginx"
    container_port = 80
  }

  lifecycle {
    create_before_destroy = true //This ensures that the new service is created before the old one is destroyed for consistency.
  }
}

# Creates a Target Group for the Load Balancer
resource "aws_lb_target_group" "main" {
  name = "${var.name}-target-group"
  port = 80
  protocol = "HTTP"
  
  vpc_id = aws_vpc.main.id

  health_check {
    path = "/"
    protocol = "HTTP"
    port = "traffic-port"
    interval = 30
    timeout = 5
    healthy_threshold = 5
    unhealthy_threshold = 2
  }
}

# Creates a Load Balancer and attaches the security groups and subnets
resource aws_lb "main" {
  name = "${var.name}-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.main.id]
  subnets = [for s in aws_subnet.public: s.id]
}

# Creates a Listener for the Load Balancer
resource aws_alb_listener "main" {
  load_balancer_arn = aws_lb.main.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}