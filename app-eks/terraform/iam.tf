#------------------------------------------------<EKS CLUSTER IAM ROLE>------------------------------------------------#
data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "amz_eks_cluster_policy" {
  name = "AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks_cluster_iam_role" {
  name                = "webapp-eks-cluster-iam-role"
  assume_role_policy  = data.aws_iam_policy_document.eks_assume_role_policy.json
  managed_policy_arns = [data.aws_iam_policy.amz_eks_cluster_policy.arn]
}

#------------------------------------------------<EKS NODE GROUP IAM ROLE>------------------------------------------------#
data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


data "aws_iam_policy" "AmazonEKSWorkerNodePolicy" {
  name = "AmazonEKSWorkerNodePolicy"
}

data "aws_iam_policy" "AmazonEC2ContainerRegistryReadOnly" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}


data "aws_iam_policy" "AmazonEKS_CNI_Policy" { # was not able to create node group without this policy
  name = "AmazonEKS_CNI_Policy"
}

resource "aws_iam_role" "eks_node_group_iam_role" {
  name = "webapp-eks-node-group-iam-role"

  assume_role_policy  = data.aws_iam_policy_document.ec2_assume_role_policy.json
  managed_policy_arns = [data.aws_iam_policy.AmazonEKSWorkerNodePolicy.arn, data.aws_iam_policy.AmazonEC2ContainerRegistryReadOnly.arn, data.aws_iam_policy.AmazonEKS_CNI_Policy.arn]
}

resource "aws_iam_instance_profile" "eks_node_group_ins_profile" {
  name = aws_iam_role.eks_node_group_iam_role.name
  role = aws_iam_role.eks_node_group_iam_role.name
}
#------------------------------------------------<EKS ALB CONTROLLER ROLE IAM ROLE>------------------------------------------------#

locals {
  oidc_issuer_url = aws_eks_cluster.webapp_eks_cluster.identity.0.oidc.0.issuer
}


data "external" "thumbprint" {
  program = ["bash", "-c", "echo | openssl s_client -connect oidc.eks.us-east-1.amazonaws.com:443 2>&- | openssl x509 -fingerprint -noout | sed 's/://g' | awk -F= '{print tolower($2)}' | jq -R '{thumbprint: .}'"]
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.thumbprint.result["thumbprint"]]
  url             = local.oidc_issuer_url
}


# https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html#lbc-helm-install
resource "aws_iam_policy" "AWSLoadBalancerControllerIAMPolicy" {
  name = "webapp-eks-AWSLoadBalancerControllerIAMPolicy"

  policy = file("${path.module}/iam_policy/iam_AWSLoadBalancerControllerIAMPolicy_policy.json")
}


data "aws_iam_policy_document" "eks_alb_controller_assume" {

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.oidc_provider.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(local.oidc_issuer_url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:kube-system:aws-load-balancer-controller",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(local.oidc_issuer_url, "https://", "")}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "eks_lb_iam_role" {
  name                = "webapp-eks-load-balancer-iam-role"
  assume_role_policy  = data.aws_iam_policy_document.eks_alb_controller_assume.json
  managed_policy_arns = [aws_iam_policy.AWSLoadBalancerControllerIAMPolicy.arn]
}
