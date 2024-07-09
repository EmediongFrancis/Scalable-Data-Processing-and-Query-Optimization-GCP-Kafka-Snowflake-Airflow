resource "aws_kinesis_stream" "data_stream" {
  name             = "madhatter_data_stream"
  shard_count      = 1
  retention_period = 24
}
