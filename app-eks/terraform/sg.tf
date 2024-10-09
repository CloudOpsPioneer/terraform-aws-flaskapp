#-------------------------------------------------<EKS Cluster Security Group>--------------------------------------------------
resource "aws_security_group" "eks_sg" {
  name        = "webapp-eks-cluster-sg"
  description = "EKS Cluster Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["172.31.24.245/32"]
    description = "private ip of my ec2 instance hosted on same vpc as eks. I am running TF and kubectl commands from here"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webapp-eks-cluster-sg"
  }
}

#-------------------------------------------------<Flaskapp ALB Security Group>--------------------------------------------------
resource "aws_security_group" "eks_flask_alb_sg" {
  name        = "webapp-eks-flask-alb-sg"
  description = "flask-ingress alb security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["168.161.22.1/32"]
    description = "my public ip to access the ALB DNS from browser"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webapp-eks-flask-alb-sg"
  }

}

#-------------------------------------------------<Security Group rule - EKS Cluster SG>--------------------------------------------------
resource "aws_security_group_rule" "eks_flask_ingress_rule_1" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  security_group_id        = aws_eks_cluster.webapp_eks_cluster.vpc_config.0.cluster_security_group_id
  source_security_group_id = aws_security_group.eks_node_group_sg.id
  description              = "Adding security group of eks node group to eks cluster SG"
}

#------------------------------------------------------<EKS Node Group Security Group>-------------------------------------------------------
resource "aws_security_group" "eks_node_group_sg" {
  name        = "webapp-eks-node-group-sg"
  description = "Security Group of EKS node group.Passed to Launch Template"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_eks_cluster.webapp_eks_cluster.vpc_config.0.cluster_security_group_id]
    description     = "eks cluster security group"
  }

  ingress {
    from_port       = 8001
    to_port         = 8001
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_flask_alb_sg.id]
    description     = "flask-ingress security group"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webapp-eks-node-group-sg"
  }

}
