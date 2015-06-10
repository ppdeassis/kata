# encoding: utf-8
# based on: https://gist.github.com/bpinto/2920803
# based on: https://github.com/sobrinho/cpf_validator
module Cpf

  def self.generate(options = {})
    number = 9.times.map { rand(9) }
    2.times { number << verification_digit_for(number) }

    cpf = number.join
    cpf = format(cpf) unless options[:plain]

    cpf
  end

  def self.format(number)
    n = number.to_s
    unless formatted?(n)
      n = plain(n)
      n = n.gsub(/^(\d{3})(\d{3})(\d{3})(\d{2})$/, "\\1.\\2.\\3-\\4")
    end
    n
  end
  class << self
    alias_method :mask, :format
  end

  def self.formatted?(number)
    number =~ /^\d{3}\.\d{3}\.\d{3}-\d{2}$/
  end
  class << self
    alias_method :masked?, :formatted?
  end

  def self.plain(string)
    s = string.to_s
    s.gsub(/\D/, '').rjust(11, "0")
  end
  class << self
    alias_method :unmask, :plain
  end

  def self.valid?(number)
    formatted?(number) && !black_listed?(number) && digits_matches?(number)
  end


  private

  # ignore same digit numbers
  def self.black_listed?(number)
    plain(number) =~ /^12345678909|(\d)\1{10}$/
  end

  def self.digit_matches?(number, digit)
    sum = 0
    digits = number.to_s.scan(/\d/).map(&:to_i)

    digit.times do |i|
      sum += digits[i] * (digit + 1 - i)
    end

    result = sum % 11
    result = result < 2 ? 0 : 11 - result

    result == digits[digit]
  end

  def self.digits_matches?(number)
    digit_matches?(number, 9) && digit_matches?(number, 10)
  end

  def self.verification_digit_for(number)
    i = 1
    sums = number.reverse.collect do |digit|
      i = i + 1
      digit * i
    end

    verification_digit = 11 - sums.inject(0) { |sum, item| sum + item } % 11
    verification_digit < 10 ? verification_digit : 0
  end

end
