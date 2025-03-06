data "local_file" "hello_world" {
  filename = "${path.module}/demo.txt"
}

output "data" {
  value = data.local_file.hello_world.content
}
