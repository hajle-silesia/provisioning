project = "brewing-system"

k3s_version = "v1.25.11+k3s1"

servers = {
  europe-west4 = {
    region = "europe-west4"
    zones  = [
      "europe-west4-a",
      "europe-west4-b",
    ]
    cidr_range   = "10.20.0.0/17"
    machine_type = "t2a-standard-1"
    target_size  = 2
  },
}

agents = {
  europe-west4 = {
    region = "europe-west4"
    zones  = [
      "europe-west4-a",
      "europe-west4-b",
    ]
    cidr_range   = "10.20.128.0/17"
    machine_type = "t2a-standard-1"
    target_size  = 2
  },
}
