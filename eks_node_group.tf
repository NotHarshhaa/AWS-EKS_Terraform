resource "aws_instance" "kubectl_server" {
  ami                         = "ami-06ca3ca175f37dd66"
  key_name                    = "EKS_KEY_PAIR"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public-1.id
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]

  tags = {
    Name = "kubectl-server"
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "pc-node-group"
  node_role_arn   = aws_iam_role.eks_worker_role.arn
  subnet_ids      = [aws_subnet.public-1.id, aws_subnet.public-2.id]
  capacity_type   = "ON_DEMAND"
  disk_size       = 20
  instance_types  = ["t2.small"]

  remote_access {
    ec2_ssh_key               = "EKS_KEY_PAIR"
    source_security_group_ids = [aws_security_group.allow_tls.id]
  }

  labels = {
    env = "dev"
  }

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_read_only
  ]
}
