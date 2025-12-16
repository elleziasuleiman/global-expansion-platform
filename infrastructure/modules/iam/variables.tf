variable "service_name" {
  type = string
}
variable "service_principal" {
  type    = string
  default = "lambda.amazonaws.com"
}
variable "tags" {
  type    = map(string)
  default = {}
}
