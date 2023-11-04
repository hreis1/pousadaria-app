# Projeto Pousadaria

A Pousadaria é uma aplicação web de reserva de quartos em pousadas.

### Principais Funcionalidades
<details>
<summary>Criar Conta como Dono de Pousada</summary>

- [X] Permitir que donos de pousadas criem uma conta fornecendo seu e-mail e senha.
</details>

<details>
<summary>Cadastrar Pousada</summary>

- [X] Permitir que donos de pousadas cadastrem sua pousada fornecendo nome fantasia, razão social, CNPJ, telefone para contato, e-mail para contato e endereço completo com endereço, bairro, estado, cidade e CEP.
- [X] Permitir que donos de pousadas cadastrem uma descrição de sua pousada, os meios de pagamentos aceitos, informar se a pousada aceita ou não pets e cadastrar um texto com políticas de uso da pousada.
- [X] Permitir que donos de pousadas cadastrem um horário padrão para check-in e check-out.
- [X] Permitir que somente os donos de pousadas editem os dados de sua própria pousada.
- [X] Não permitir que donos de pousadas excluam sua pousada.
- [X] Permitir que cada dono de pousada possua somente uma pousada cadastrada.
- [X] Permitir que donos de pousadas indiquem se sua pousada está ativa ou não na plataforma.
- [X] Não permitir que pousadas desativadas sejam listadas nas buscas para visitantes.
- [ ] Não permitir que pousadas desativadas aceitem novas reservas.
</details>

<details>
<summary>Cadastrar Quartos</summary>

- [X] Permitir que donos de pousadas cadastrem quartos em sua pousada fornecendo nome, descrição, dimensão, quantidade máxima de pessoas, valor da diária, indicação se possui banheiro próprio, indicação se possui varanda, indicação se possui ar condicionado, indicação se possui TV, indicação se possui guarda-roupas, indicação se possui cofre e indicação se é acessível para pessoas com deficiência.
- [X] Permitir que somente os donos de pousadas editem os dados dos quartos de sua própria pousada.
- [X] Não permitir que donos de pousadas excluam quartos de sua pousada.
- [X] Permitir que cada dono de pousada possua quantos quartos desejar.
- [X] Permitir que donos de pousadas indiquem se um quarto está disponível ou não para reservas.
- [X] Não permitir que quartos indisponíveis sejam listados nas buscas para visitantes.
</details>

### Diagrama de Entidade e Relacionamento
<details>
<summary>Banco de Dados</summary>

![Diagrama de Entidade e Relacionamento](/assets/pousadaria_der.png)
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