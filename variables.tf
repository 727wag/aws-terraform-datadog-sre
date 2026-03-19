variable "datadog_api_key" {
    description = "Chave da API do Datadog"
    type = string
    sensitive = true
}

variable "datadog_app_key" {
    description = "Chave da Aplicação do Datadog"
  type = string
  sensitive = true  
}

variable "meu_ip" {
    description = "Meu IP Público para acessar o SSH"
    type = string
}