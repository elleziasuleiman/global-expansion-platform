variable "function_name" {
  type = string
}
variable "filename" {
  type = string
}
variable "handler" {
  type = string
}
variable "runtime" {
  type    = string
  default = "nodejs22.x"
}
variable "role_arn" {
  type = string
}
