class << Hash
  def create(keys, values)
    self[*keys.zip(values).flatten]
  end
end

class Hash
  
  # Stolen from rails 
  def symbolize_keys
    self.inject({}){|result, (key, value)|
      new_key = case key  
                when String then key.to_sym  
                else key  
                end  
      new_value = case value
                  when Hash then value.symbolize_keys
                  else value
                  end  
      result[new_key] = new_value  
      result
    }  
  end  
  
end