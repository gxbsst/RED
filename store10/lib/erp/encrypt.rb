module Encrypt
  require 'openssl'
  require 'base64'
  require 'digest/sha2'

  def self.aes_encrypt(key, content)
    c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    c.encrypt
    c.key = Base64.decode64(key)
    e = c.update(content)
    e << c.final
    return Base64.encode64(e)
  end

  def self.aes_decrypt(key, content)
    c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    c.decrypt
    c.key = Base64.decode64(key)
    d = c.update(Base64.decode64(content))
    d << c.final
    return d
  end

  def self.rsa_encrypt(content)
    public_key = OpenSSL::PKey::RSA.new(open(AppConfig.PUBLIC_KEY))
    cipher = public_key.public_encrypt(content)
    encode_cipher = Base64::encode64(cipher)
    return encode_cipher
  end

end
