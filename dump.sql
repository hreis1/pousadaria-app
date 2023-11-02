Cadastrar Pousada Pendente
Com sua conta criada, o usuário deve, obrigatoriamente, cadastrar sua pousada informando nome fantasia, razão social, CNPJ, telefone para contato, e-mail para contato e endereço completo com endereço, bairro, estado, cidade e CEP. Além destes dados, o dono da pousada deve poder adicionar uma descrição de sua pousada, os meios de pagamentos aceitos, informar se a pousada aceita ou não pets e cadastrar um texto com políticas de uso da pousada. Cada pousada deve possuir também um horário padrão cadastrado para check-in e check-out.

Cada usuário deve possuir somente uma pousada cadastrada. E a pousada deve estar diretamente vinculada ao usuário.

O dono da pousada deve ser capaz de indicar se sua pousada está ativa ou não na plataforma. Caso a pousada esteja desativada, ela não deve ser listada nas buscas para visitantes e também não deve aceitar novas reservas.

Table owner {
  id int [pk, increment] // auto-increment
  email varchar
  password varchar
  created_at timestamp
  updated_at timestamp
}

Table inn {
  id int [pk, increment] // auto-increment
  owner_id int [ref: - owner.id]
  name varchar
  trade_name varchar
  corporate_name varchar
  cnpj varchar
  phone varchar
  email varchar
  address varchar
  address_number varchar
  neighborhood varchar
  state varchar
  city varchar
  cep varchar
  description varchar
  payment_methods varchar
  pets_allowed boolean
  policies varchar
  checkin_time time
  checkout_time time
  status boolean
  created_at timestamp
  updated_at timestamp
}
