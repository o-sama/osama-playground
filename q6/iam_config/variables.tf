variable "resource_prefix" {
  type = string
  description = "A prefix to identify the resources by, usually project name."
}

variable "env" {
  type = string
  description = "The environment in which the resources are running."
}

variable "tags" {
  type = map(string)
  description = "tags to be added to the variable"
}