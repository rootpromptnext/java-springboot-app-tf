# -------------------------------
# EKS CLUSTER CORE DETAILS
# -------------------------------

output "eks_cluster_name" {
  description = "EKS Cluster Name"
  value       = aws_eks_cluster.eks.name
}

output "eks_cluster_arn" {
  description = "EKS Cluster ARN"
  value       = aws_eks_cluster.eks.arn
}

output "eks_cluster_endpoint" {
  description = "EKS API Server Endpoint"
  value       = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_ca" {
  description = "EKS Cluster Certificate Authority Data"
  value       = aws_eks_cluster.eks.certificate_authority[0].data
  sensitive   = true
}

# -------------------------------
# OIDC (VERY IMPORTANT FOR IRSA)
# -------------------------------

output "eks_oidc_issuer" {
  description = "OIDC Issuer URL (for IRSA, ALB Controller, ExternalDNS)"
  value       = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

# -------------------------------
# NETWORKING
# -------------------------------

output "vpc_id" {
  description = "VPC ID used by EKS"
  value       = aws_vpc.eks_vpc.id
}

output "private_subnets" {
  description = "Private Subnet IDs"
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

output "public_subnets" {
  description = "Public Subnet IDs"
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

# -------------------------------
# NODE GROUP / IAM
# -------------------------------

output "node_group_name" {
  description = "EKS Node Group Name"
  value       = aws_eks_node_group.node_group.node_group_name
}

output "node_role_arn" {
  description = "IAM Role used by Worker Nodes"
  value       = aws_iam_role.eks_node_role.arn
}

output "cluster_role_arn" {
  description = "IAM Role used by EKS Cluster"
  value       = aws_iam_role.eks_cluster_role.arn
}

# -------------------------------
# ECR (if you added earlier)
# -------------------------------

output "ecr_repository_url" {
  description = "ECR Repository URL"
  value       = aws_ecr_repository.app_repo.repository_url
}

# -------------------------------
# KUBECONFIG (MOST USED)
# -------------------------------

output "kubeconfig_command" {
  description = "Run this to configure kubectl"
  value       = "aws eks --region us-east-1 update-kubeconfig --name ${aws_eks_cluster.eks.name}"
}

# -------------------------------
# JENKINS
# -------------------------------
#output "jenkins_ssh" {
#  description = "SSH command"
#  value       = "ssh ubuntu@${aws_instance.jenkins.public_ip}"
#}

#output "jenkins_url" {
#  description = "Jenkins UI"
#  value       = "http://${aws_instance.jenkins.public_ip}:8080"
#}

