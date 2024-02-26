# **API Sistema de Promissoria FBD**

## Sobre o Projeto
* **Instuição:** Universidade Federal Rural de Pernambuco - Unidade Acadêmica de Serra Talhada.

* **Curso:** Bacharelado em Sistemas de Informação

* **Cadeira:** Fundamentos de Banco de Dados

* **Dorcente:** Prof. Héldon José Oliveira Albuquerque

* **Descrição:** Trata-se de uma application programming interface (api) desenvolvido com o objetivo de ser um sistema de geração e controle de promissorias.

## Observações Importantes
### Endpoints de get:
* `http://localhost/cliente/?search={id/cpf/nome}`
* `http://localhost/produto/?search={id/nome}`
* `http://localhost/contrato/?search={id/cpf_cliente}`
### Sobre os parâmetros:
* **Busca por partes:** O cpf e o nome do cliente não precisam ser postos inteiros para que a busca execute corretamente. Isto também ocorre com o nome do produto.

### Sobres os Endpoints de PUT
* Onde houver ocorrencia de PUT, não é necessários alterar todos os itens dipostos de uma vez, apesar de isso ser possivel, ou seja, você é livre para alterar só o nome do produto ou só nome do cliente por exemplo. Isso não se aplica ao PUT presente na parcela onde você poderar alterar somente e apenas o booleano caso a parcela tenha sido paga.

### Sobre os Endpoints de POST
* **Produto:** No post de produto a chave porc_lucro tem como valor default *0.3* caso ele não seja referenciado no momento da criação do produto.
## Link para Documentação 
* [Link da Documentação em Swagger](http://localhost:8080/documentation/)

*<p>Obs: Essa é uma api local então você deve rodar a aplicação primeiro para que  o link acima funcione corretamente.</p>*

<img src="image\image_swagger.png" alt="swagger image">

## Autor
* Renan Nicolau Gomes
