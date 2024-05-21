resource "random_uuid" "root_flag" {
  count = var.subnet_count
}
resource "random_uuid" "user_flag" {
  count = var.subnet_count
}

resource "random_uuid" "web_flag" {
  count = var.subnet_count
}

resource "local_file" "flags" {
  filename = "${path.module}/output/flags.txt"
  content = join("\n\n", [for i in range(var.subnet_count) :
    join("\n", [
      "Root ${i + 1}: ${random_uuid.root_flag[i].result}",
      "User ${i + 1}: ${random_uuid.user_flag[i].result}",
      "Web ${i + 1}: ${random_uuid.web_flag[i].result}"
    ])
  ])
}