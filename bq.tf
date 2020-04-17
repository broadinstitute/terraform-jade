resource "google_bigquery_table" "logs" {
  dataset_id = module.user-activity-sinks.dataset_id[0]
  table_id   = "all_user_requests"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = var.project
  }

  view {
    query = <<EOF
SELECT timestamp,
  REGEXP_EXTRACT(textPayload, r"userId: ([^,]+)") AS user_id,
  REGEXP_EXTRACT(textPayload, r"email: ([^,]+)") AS email,
  REGEXP_EXTRACT(textPayload, r"status: ([^,]+)") AS status,
  REGEXP_EXTRACT(textPayload, r"method: ([^,]+)") AS method,
  REGEXP_EXTRACT(textPayload, r"url: ([^,]+)") AS url
FROM `${var.project}.${module.user-activity-sinks.dataset_id[0]}.stdout_*`;
EOF
    use_legacy_sql = false
  }

  schema = <<EOF
[
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "email",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "status",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "method",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": ""
  },
  {
    "name": "url",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": ""
  }
]
EOF
}
