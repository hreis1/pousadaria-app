# Projeto Pousadaria

A Pousadaria é uma aplicação web de reserva de quartos em pousadas.

### Principais Funcionalidades
<details>
<summary>Criar Conta como Dono de Pousada</summary>

- [ ] Permitir que donos de pousadas criem uma conta fornecendo seu e-mail e senha.
</details>

### Depêndencias para rodar o projeto
- Ruby 3.2.2
- Rails 7.0.0

### Como rodar o projeto
faça o clone do projeto e entre na pasta do projeto
```
git clone https://github.com/hreis1/ProjetoPousadaria
cd ProjetoPousadaria
```
rode o comando para instalar as dependências
```
bundle install
```
rode o comando para criar o banco de dados e popular o banco de dados
```
rails db:create db:migrate db:seed
```
rode o comando para iniciar o servidor
```
rails s
```
acesse o projeto em http://localhost:3000

### Como rodar os testes
Para rodar os testes basta digitar o comando: 
```
rspec
```