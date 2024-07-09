resource "aws_appautoscaling_target" "kinesis_scaling_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "stream/${aws_kinesis_stream.data_stream.name}"
  scalable_dimension = "kinesis:stream:WriteCapacityUnits"
  service_namespace  = "kinesis"
}

resource "aws_appautoscaling_policy" "kinesis_scaling_policy" {
  name               = "kinesis-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.kinesis_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.kinesis_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.kinesis_scaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 50.0

    predefined_metric_specification {
      predefined_metric_type = "KinesisWriteProvisionedThroughputExceeded"
    }
  }
}
