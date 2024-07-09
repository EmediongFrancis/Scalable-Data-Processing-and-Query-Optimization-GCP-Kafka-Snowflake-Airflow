resource "aws_redshift_cluster" "redshift" {
  cluster_identifier = "madhatter-redshift-cluster"
  database_name      = "madhatterdb"
  master_username    = "admin"
  master_password    = "YourPassword!123"
  node_type          = "dc2.large"
  cluster_type       = "single-node"

  # VPC and Security Group setup might be needed here
  # vpc_security_group_ids = [aws_security_group.redshift_sg.id]
  # subnet_group_name      = aws_redshift_subnet_group.default.name
}
