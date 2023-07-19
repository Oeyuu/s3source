module "my_connector" {
  source = "/projects/teclify/training/connector"

  msk_cluster_name          = var.msk_cluster_name
  s3_bucket_distributions   = var.s3_bucket_distributions
  region                    = var.region
  iam_role_name             = var.iam_role_name
  distribution_url          = var.distribution_url
  distribution_version      = var.distribution_version
  distribution_content_type = var.distribution_content_type
  connectors = [
    for connector in var.connectors : {

      name                 = connector.name
      kafkaconnect_version = connector.kafkaconnect_version
      connector_configuration = merge(connector.connector_configuration, {
        "connect.s3.kcql": "insert into test_source select * from ${data.aws_s3_bucket.s3sink.id} STOREAS `json`",
        "connect.s3.aws.region" = data.aws_s3_bucket.s3sink.region

      })
  }]
}
