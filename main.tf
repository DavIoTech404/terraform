terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"

  resource "aws_ecs_cluster" "kafkaCluster" {
    name = "kafka-cluster"


    resource "aws_ecs_service" "broker1" {
      name            = "broker1"
      task_definition = aws_ecs_task_definition.broker
      cluster         = aws_ecs_cluster.kafkaCluster.id
      desired_count   = 1
      depends_on      = [aws_ecs_cluster.kafkaCluster]
    }

    resource "aws_ecs_task_definition" "broker" {
      family = "broker"
      container_definitions = jsonencode([
        {
          name      = "broker"
          image     = var.machineConfigs["brokerImage"]
          cpu       = var.machineConfigs["cpu"]
          memory    = var.machineConfigs["memory"]
          essential = true
          portMappings = [
            {
              containerPort = 9092
              hostPort      = 9092
            }
          ]
        }
      ])
    }
  }
}

/*
resource "aws_ecs_service" "cluster_brokers" {
  count           = 2
  name            = "broker-${count.index}"
  cluster         = CRUSTER
  task_definition = "${count.index}"
  desired_count   = 1
  iam_role        = aws_iam_role.foo.arn
  depends_on      = [aws_iam_role_policy.foo]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.foo.arn
    container_name   = "broker${count.index}"
    container_port   = "${9091 + count.index}"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  } 
}

resource "aws_ecs_task_definition" "broker-container" {
  count = 2
  family = "${count.index}"
  container_definitions = {
      name         = "broker${count.index}"
      image        = var.machineConfigs["brokerImage"]
      cpu          = var.machineConfigs["cpu"]
      memory       = var.machineConfigs["memory"]
      essential    = true
      portMappings = [
        {
          containerPort = "${9091 + count.index}"
          hostPort      = "${9091 + count.index}"
        }
      ]
    }

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  } 

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  } 
} 

 resource "aws_ecs_service" "broker-1" {
  name            = "broker-1"
  task_definition = "1"
  desired_count   = 1
  iam_role        = aws_iam_role.foo.arn

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.foo.arn
    container_name   = "broker1"
    container_port   = "9092"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  } 
}


resource "aws_ecs_task_definition" "broker-1" {
  family = "broker"
  container_definitions = {
      name         = "broker1"
      image        = var.machineConfigs["brokerImage"]
      cpu          = var.machineConfigs["cpu"]
      memory       = var.machineConfigs["memory"]
      essential    = true
      portMappings = [
        {
          containerPort = "9092"
          hostPort      = "9092"
        }
      ]
    }

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  } 

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  } 
}
*/
