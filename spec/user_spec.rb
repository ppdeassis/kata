require 'spec_helper'

describe User do
  let(:user) { User.new }

  it "password defaults to 'devolutivas' hashed" do
    expect(user.password).to eq('$2a$10$9NXNJ14hmUBlXkY8uNuQq.Yp6P8n2Xf7bsH8F9UR5XEYgRV8gSsJO')
  end

  it "cpf defaults to a valid number" do
    formatted_cpf = Cpf.format(user.cpf)
    expect(Cpf.valid?(formatted_cpf)).to eq true
  end

  it "cpf is plain string, without punctuation" do
    expect(user.cpf).to match /^\d+$/
  end


  it "email defaults to testeN@devolutivas.com" do
    expect(user.email).to match /^teste\d+\@devolutivas\.com$/
  end

  it "emails defaults are generated using a sequential number" do
    users = 5.times.collect { User.new }

    first_user = users[0]
    initial_seq = first_user.email.scan(/(\d+)\@/).flatten.first.to_i

    users.each do |user|
      expect(user.email).to eq "teste#{initial_seq}@devolutivas.com"
      initial_seq += 1
    end
  end


  it "name defaults to 'Teste N'" do
    expect(user.name).to match /^Teste \d+$/
  end

  it "name defaults are generated using a sequential number" do
    initial = User.count

    expect(User.new.email).to eq("teste#{initial + 1}@devolutivas.com")
    expect(User.new.email).to eq("teste#{initial + 2}@devolutivas.com")
    expect(User.new.email).to eq("teste#{initial + 3}@devolutivas.com")
    expect(User.new.email).to eq("teste#{initial + 4}@devolutivas.com")
    expect(User.new.email).to eq("teste#{initial + 5}@devolutivas.com")
  end


  it "perfil defaults to 6" do
    expect(user.perfil).to eq(6)
  end



  it "#to_insert_sql generates a valid SQL" do
    attributes = {
      name: "Peter the Great",
      cpf: "37375645230",
      email: "peter@great.com",
      password: "s3cr37",
      perfil: 3
    }

    user = User.new(attributes)

    expect(user.to_insert_sql).to eq(<<-SQL.gsub(/\s{2,}/, ' ').strip)
      INSERT INTO TB_USUARIO
      (
        NO_USUARIO,
        NU_CPF,
        TX_EMAIL,
        TX_SENHA,
        NU_PERFIL,
        ID_USUARIO_INCLUSAO
      )
    VALUES
      (
        'Peter the Great',
        '37375645230',
        'peter@great.com',
        's3cr37',
        3,
        1
      );
    SQL

  end


end
