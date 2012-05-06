class << Hash
  def create(keys, values)
    self[*keys.zip(values).flatten]
  end
end

class Hash
  
  def recursive_symbolize_keys
    self.inject({}){|result, (key, value)|
      new_key = case key  
                when String then key.to_sym  
                else key  
                end  
      new_value = case value
                  when Hash then value.recursive_symbolize_keys
                  else value
                  end  
      result[new_key] = new_value  
      result
    }  
  end  
  
end