variable "set_A" {
  type    = set(string)
  default = ["hello", "world", "hello"]
}

output "set_A" {
  value = var.set_A
}

variable "list_A" {
  type    = list(any)
  default = ["a", "b", "a"]
}

output "list_A" {
  value = var.list_A[0]
}