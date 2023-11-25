# Projeto Pousadaria

A Pousadaria é uma aplicação web de reserva de quartos em pousadas.

### Principais Funcionalidades
<details>
<summary>Criar Conta como Dono de Pousada</summary>

- [X] Permitir que donos de pousadas criem uma conta fornecendo seu e-mail e senha.
</details>

<details>
<summary>Cadastrar Pousada</summary>

- [X] Permitir que donos de pousadas cadastrem sua pousada fornecendo nome fantasia,
 razão social, CNPJ, telefone para contato, e-mail para contato e endereço completo
 com endereço, bairro, estado, cidade e CEP.
- [X] Permitir que donos de pousadas cadastrem uma descrição de sua pousada, os
 meios de pagamentos aceitos, informar se a pousada aceita ou não pets e cadastrar 
 um texto com políticas de uso da pousada.
- [X] Permitir que donos de pousadas cadastrem um horário padrão para check-in e check-out.
- [X] Permitir que somente os donos de pousadas editem os dados de sua própria pousada.
- [X] Não permitir que donos de pousadas excluam sua pousada.
- [X] Permitir que cada dono de pousada possua somente uma pousada cadastrada.
- [X] Permitir que donos de pousadas indiquem se sua pousada está ativa ou não na plataforma.
- [X] Não permitir que pousadas desativadas sejam listadas nas buscas para visitantes.
- [X] Não permitir que pousadas desativadas aceitem novas reservas.
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

<details>
<summary>Cadastrar Preços Personalizados</summary>

- [X] Permitir que donos de pousadas cadastrem preços personalizados para um quarto de sua pousada fornecendo uma data início, uma data fim e o valor a ser cobrado por diária durante este período.
- [X] Não permitir que donos de pousadas cadastrem preços personalizados com datas que se sobreponham.
- [X] Permitir que cada quarto possua quantos preços personalizados desejar.
- [X] Permitir que somente os donos de pousadas editem os preços personalizados de um quarto de sua própria pousada.
- [X] Permitir que donos de pousadas excluam preços personalizados de um quarto de sua pousada.
- [X] Exibir a lista de preços personalizados dentro da tela de detalhes de um quarto.
- [ ] Permitir que donos de pousadas indiquem se um preço personalizado está ativo ou não.

</details>

<details>
<summary>Listagem de Pousadas</summary>

- [X] Um visitante, não autenticado, deve ser capaz de ver todas as pousadas cadastradas no site. As pousadas devem ser exibidas na tela inicial da aplicação e devem ser separadas em 2 blocos: primeiro uma lista com as 3 pousadas mais recentes e, abaixo, o restante das pousadas cadastradas e ativas.
- [X] Para cada pousada, deve ser exibido seu nome e a cidade. Ao clicar no nome da pousada, devem ser exibidos todos os demais detalhes cadastrados pelos donos de cada estabelecimento, exceto o CNPJ e a razão social.
</details>

<details>
<summary>Pousadas por cidade</summary>

- [X] Um visitante, não autenticado, deve ter acesso, na tela inicial, a um menu de cidades onde, ao clicar em uma das cidades listadas, deve ser direcionado para uma tela onde são listadas todas as pousadas daquela cidade.
- [X] A lista de pousadas de uma cidade deve ser exibida em ordem alfabética, considerando seu nome fantasia. Ao clicar no nome de uma das pousadas, o usuário deve ter acesso à mesma tela de detalhes descrita no item anterior.
</details>

<details>
<summary>Busca de Pousadas</summary>

- [X] Um visitante, não autenticado, deve ter acesso, a partir de qualquer tela da aplicação, a um campo de busca de pousadas. O usuário deve poder buscar uma pousada pelo seu nome fantasia, pelo bairro ou pela cidade.
- [X] A tela de resultados da busca deve listar o termo informado para busca, a quantidade de registros encontrados e, caso exista, uma listagem com as pousadas encontradas.
- [X] A lista de pousadas deve ser exibida em ordem alfabética, considerando seu nome fantasia. Ao clicar no nome de uma das pousadas, o usuário deve ter acesso à mesma tela de detalhes descrita anteriormente.
- [ ] Além da busca por texto, você pode tentar criar uma página separada de busca avançada que inclua opções como: aceita pets, acessível para PcD, ar-condicionado no quarto, TV no quarto etc. Você pode usar a mesma página de resultados detalhada anteriormente para exibir as pousadas encontradas após a busca.
</details>

<details>
<summary>Ver quartos</summary>

- [X] Um visitante, não autenticado, deve poder ver todos os quartos disponíveis para uma pousada. A listagem de quartos deve ser exibida na mesma tela de detalhes de uma pousada. Para cada quarto, devem ser exibidas todas as informações cadastradas pelo dono da pousada exceto a tabela de preços por período.
</details>

<details>
<summary>Disponibilidade de quartos</summary>

- [X] Um visitante pode escolher um quarto de uma pousada e clicar em um botão para reservar. Ao tomar esta ação, o usuário será redirecionado para uma tela onde deve ver os detalhes do quarto selecionado e um formulário que solicita a data de entrada, a data de saída e a quantidade de hóspedes. Os três campos são obrigatórios. Após preenchê-los e submeter o formulário, a aplicacão deve consultar se existe disponibilidade para o período selecionado. Caso sim, deve ser informado o valor total das diárias, mas a reserva ainda não deve ser efetuada.
- [X] Caso não haja disponibilidade, uma mensagem deve ser exibida para o usuário e ele deve voltar para o formulário inicial. A quantidade de hóspedes informada deve ser usada para validar se o quarto selecionado atende à solicitacão. Em caso negativo, uma mensagem de erro deve ser exibida.
- [ ] A consulta de disponibilidade deve considerar as reservas feitas para um quarto, tanto as pendentes quanto aquelas que já estão em andamento. As reservas canceladas no entanto devem ser desconsideradas.
</details>

<details>
<summary>Reservar quarto</summary>

- [X] Um visitante pode, após verificar a disponibilidade de um quarto e obter retorno positivo, prosseguir com a reserva. Para isto, o visitante deve primeiro criar uma conta como usuário informando seu nome completo, email, CPF e senha. Este usuário é um usuário regular ou um cliente, escolha o termo que preferir, mas lembre-se de que este tipo de usuário é diferente dos donos de pousadas, com ações diferentes dentro do sistema.
- [X] Um usuário, agora autenticado, a partir do resultado positivo de disponibilidade, pode prosseguir com a reserva. Deve ser exibido um resumo com data de entrada e horário de check-in (conforme padrão da pousada), data de saída e horário de check-out (conforme padrão da pousada), o quarto escolhido e o valor total. Devem ser exibidos também os meios de pagamentos aceitos pela pousada e, por último, um botão para confirmar a reserva.
- [X] Ao confirmar sua reserva, ela deve ser armazenada no banco de dados e passa a ficar disponível tanto para o usuário, em um menu "Minhas Reservas". Cada reserva deve ser identificada por um código de 8 caracteres aleatórios, o código deve ser sempre único.
- [X] Um usuário autenticado e que já efetivou uma reserva pode cancelar esta reserva até 7 dias antes da data agendada para o check-in.
</details>

<details>
<summary>Check-in</summary>

- [X] Os usuários donos de pousadas devem ser capazes de ver as reservas agendadas através de uma opção "Reservas" no menu. Deve haver uma listagem com todas reservas de sua pousada e para cada reserva o dono da pousada deve poder ver o quarto escolhido, a data de entrada e saída, a quantidade de hóspedes e o código da reserva.
- [X] Ao acessar uma reserva, o dono da pousada deve ter a opção de realizar o check-in caso o dia atual seja igual ou maior do que o dia definido para entrada na reserva. O check-in deve alterar o status da reserva, que agora passa a ser uma estadia ativa. Devem ser registrados também o dia e a hora exatos do check-in. Todas reservas que já passaram pelo check-in devem aparecer em uma opção separada do menu chamada "Estadias Ativas".
- [X] Caso tenham se passado 2 dias desde o dia previsto para o check-in e os hóspedes não tenham feito o check-in, o dono da pousada pode cancelar a reserva, deixando o quarto disponível para novas reservas.
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