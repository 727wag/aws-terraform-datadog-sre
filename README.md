# 🐕 Meu lab de Terraform + Datadog na AWS

Fala! Esse repositório é o resultado de algumas horas batendo cabeça para entender como juntar Terraform, AWS e Datadog sem fazer as coisas na mão.

A ideia aqui foi criar uma automação que sobe uma máquina EC2 na AWS e já instala o Agente do Datadog no momento que ela nasce (usando `user_data`). A máquina liga e já começa a cuspir gráfico de CPU e memória no painel.

## 🛠️ O que tem aqui?
* **AWS EC2:** Nossa maquininha de testes (t3.micro).
* **Terraform:** Pra não ter que ficar clicando em botão no painel da AWS.
* **Datadog:** Onde a mágica da observabilidade acontece.

## 😅 Os perrengues (e como eu resolvi)

Se você rodar esse código de primeira, ele vai funcionar liso. Mas até chegar aqui, eu trombei em alguns problemas clássicos de quem tá aprendendo SRE:

1. **A bolinha não aparecia no painel (O erro da Região)**
   * A máquina subia, o agente instalava, mas o painel do Datadog ficava vazio ("No matches"). 
   * Fui fuçar os logs dentro do Linux e descobri o motivo: o script padrão manda os dados pro servidor dos EUA (`datadoghq.com`), mas a minha conta caiu no servidor novo (`us5.datadoghq.com`). Ajustei a variável `DD_SITE` no Terraform e a mágica aconteceu.

2. **Segurança (O famoso 0.0.0.0/0)**
   * No começo, pra conseguir testar se o agente tava rodando, eu deixei a porta SSH aberta pro mundo todo. Depois que vi que tava funcionando, fechei a porta 22 só pro meu IP dinâmico usando uma variável no Terraform. Regra básica, mas que salva.

3. **Como atualizar máquina sem fazer SSH?**
   * Quando eu percebi o erro do `us5`, a máquina já tava ligada. Em vez de entrar nela e arrumar o arquivo na mão, aprendi a usar o `-replace` (antigo `taint`) do Terraform. Eu matei a máquina "burra" e fiz ele subir uma nova já com o script certo do zero. Infraestrutura imutável na veia.

## 🏆 O resultado

Aqui está a prova do crime, a máquina reportando o uso de CPU bonitinho no mapa de hosts:

<img width="1919" height="926" alt="datadog" src="https://github.com/user-attachments/assets/e77a2da7-ca99-4865-be7f-9b9055a76f73" />
<img width="1919" height="926" alt="dashboard-datadog" src="https://github.com/user-attachments/assets/613661e6-5611-42c9-aa78-cdabd26730fb" />


## 🚀 Como testar aí na sua máquina

Se quiser rodar esse lab, você vai precisar do Terraform instalado e de uma conta na AWS e no Datadog.

1. Clona o repo.
2. Cria um arquivo chamado `secret.tfvars` na raiz (ele tá no `.gitignore` pra você não vazar suas chaves no GitHub).
3. Joga isso dentro do arquivo e preenche com os seus dados:
   ```hcl
   datadog_api_key = "SUA_API_KEY"
   datadog_app_key = "SUA_APP_KEY"
   meu_ip          = "SEU_IP_AQUI"
