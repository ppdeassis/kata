require 'cpf'

class User
  DEFAULT_HASHED_PASSWORD = '$2a$10$9NXNJ14hmUBlXkY8uNuQq.Yp6P8n2Xf7bsH8F9UR5XEYgRV8gSsJO'
  EMAIL_TEMPLATE = 'teste::n::@devolutivas.com'
  PERFIL = 6  # ESCOLA

  @@count = 0

  attr_accessor :cpf, :email, :name, :password, :perfil

  def initialize(attributes = {})
    @@count += 1

    attributes.each do |name, value|
      send("#{name}=", value) if respond_to?("#{name}=")
    end

    self.cpf = generate_cpf if cpf.nil?
    self.email = generate_email if email.nil?
    self.name = generate_name if name.nil?
    self.password = default_password if password.nil?
    self.perfil = default_perfil if perfil.nil?
  end


  def self.count
    @@count
  end


  def to_insert_sql
    <<-SQL.gsub(/\s{2,}/, ' ').strip
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
        '#{name}',
        '#{cpf}',
        '#{email}',
        '#{password}',
        #{perfil},
        1
      );
    SQL
  end


  private

  def default_password
    DEFAULT_HASHED_PASSWORD
  end

  def default_perfil
    PERFIL
  end

  def generate_cpf
    Cpf.generate(plain: true)
  end

  def generate_email
    EMAIL_TEMPLATE.gsub('::n::', @@count.to_s)
  end

  def generate_name
    "Teste #{@@count}"
  end

end
