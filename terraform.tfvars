project = "brewing-system-4"

servers = {
  us-central1 = {
    region = "us-central1"
    zones  = [
      "us-central1-a",
      "us-central1-b",
    ]
    cidr_range   = "10.20.0.0/17"
    machine_type = "t2a-standard-1"
    target_size  = 2
  },
}

agents = {
  us-central1 = {
    region = "us-central1"
    zones  = [
      "us-central1-a",
      "us-central1-b",
    ]
    cidr_range   = "10.20.128.0/17"
    machine_type = "t2a-standard-1"
    target_size  = 2
  },
}
