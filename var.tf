variable "machineConfigs" {
  type = map(string)
  default = {
      "brokerImage" = "daviot1303/kafka-infrastructure"
      "cpu" = 1
      "memory" = 1
  }
}