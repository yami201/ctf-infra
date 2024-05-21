output "public_target_ips" {
  value = aws_instance.ctf-target.*.public_ip
}
output "public_attack_ips" {
  value = aws_instance.ctf-attack.*.public_ip
}

resource "local_file" "write_ips" {
  content = join("\n\n", [for i in range(var.subnet_count) :
    join("\n", [
      "Target ${i + 1}: ${aws_instance.ctf-target[i].public_ip}",
      "Attack ${i + 1}: ${aws_instance.ctf-attack[i].public_ip}"
    ])
  ])
  filename = "${path.module}/output/ips"

  depends_on = [
    aws_instance.ctf-target,
    aws_instance.ctf-attack
  ]

}