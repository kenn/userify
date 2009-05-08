require 'securerandom'

# Usage:
# 
# UID.new.to_s => "aWgEPTl1tmebfsQzFP4bxwgy80V"
# UID.new(5).to_s => "8FsD5"
# UID.new.to_i => 838068072552051698674007079806269848286804777409
# 1000000000.base62 => "15ftgG"
# "123abcABC".base62 => 225587272106046
# 
# By default, UIDs generates random BASE62 string of 27 characters, which is safer than 160bit SHA-1.
# 
# >> ('f'*40).hex
# => 1461501637330902918203684832716283019655932542975
# >> ('z'*27).base62
# => 2480707824361381849652170924082266893544595652607

class UID
  def initialize(n=27)
    max = ("Z"*n).base62
    @value = SecureRandom.random_number(max)
  end
  
  def to_s
    @value.base62
  end
  
  def to_i
    @value
  end
  
  def to_hex
    @value.to_s(16)
  end
end

class String
  BASE62_PRIMITIVES = {}.tap do |h|
    (('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a).each_with_index {|e, i| h[e] = i }
  end
  
  def base62
    i = 0
    i_out = 0
    self.split(//).reverse.each do |c|
      place = BASE62_PRIMITIVES.size ** i
      i_out += BASE62_PRIMITIVES[c] * place
      i += 1
    end
    i_out
  end
end


class Integer
  BASE62_PRIMITIVES = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a
  
  def base62
     number = self
     result = ''
     while(number != 0)
        result = BASE62_PRIMITIVES[number % BASE62_PRIMITIVES.size ].to_s + result
        number /= BASE62_PRIMITIVES.size
     end
    result
  end
end