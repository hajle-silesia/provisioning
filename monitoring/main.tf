resource "google_monitoring_alert_policy" "disk_utilization" {
  display_name = "VM instance - high disk utilization"
  combiner     = "OR"
  conditions {
    display_name = "VM instance - high disk utilization"
    condition_threshold {
      threshold_value = 70
      filter          = join(" AND ",
        [
          "resource.type=\"gce_instance\"",
          "metric.type=\"agent.googleapis.com/disk/percent_used\"",
          "metric.labels.state = \"used\"",
          "metric.labels.device != has_substring(\"dev/loop\")",
        ]
      )
      duration   = "0s"
      comparison = "COMPARISON_GT"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period     = "300s"
        cross_series_reducer = "REDUCE_NONE"
        per_series_aligner   = "ALIGN_MEAN"
      }
    }
  }
}
