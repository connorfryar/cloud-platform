#
terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
    time = {
      source = "hashicorp/time"
      version = "0.7.2"
    }
  }
}

resource "null_resource" "test" {
  count = 1

  provisioner "local-exec" {
    command = "echo 'Count: ${count.index}'"
  }
}

resource "null_resource" "previous" {}

resource "time_sleep" "wait_3_seconds" {
  depends_on = [null_resource.previous]

  create_duration = "3s"
}

# This resource will create (at least) 30 seconds after null_resource.previous
resource "null_resource" "next" {
  depends_on = [time_sleep.wait_3_seconds]
}

resource "null_resource" "print_env" {
  count = 1

  provisioner "local-exec" {
    command = "env"
  }
}

output "test" {
  value     = null_resource.test
}
