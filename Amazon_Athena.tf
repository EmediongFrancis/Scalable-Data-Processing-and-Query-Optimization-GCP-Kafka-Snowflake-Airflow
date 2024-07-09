resource "aws_athena_database" "database" {
  name   = "madhatter_athena_db"
  bucket = aws_s3_bucket.data_lake.bucket
}
