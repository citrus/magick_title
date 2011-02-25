require 'benchmark'

puts "Benchmark Hash to Attribtes"
puts " string vs array"
puts "-" * 50

# Converts a hash to a string of html style key="value" pairs
def hash_to_attributes_using_string(hash)
  attributes = ""
  return attributes unless hash.is_a?(Hash)
  hash.each { |key, value| attributes << key.to_s << "=\"" << value.strip << "\" " if value and 0 < value.length }
  attributes.strip
end

def hash_to_attributes_using_array(hash)
  attributes = []
  return attributes unless hash.is_a?(Hash)
  hash.each { |key, value| attributes << %(#{key}="#{value.strip}") if value and 0 < value.length }
  attributes.join(" ")
end


@hash = { :id => "some-html-id", :class => "a-css-class-that-is-long ", :href => "http://google.com   ", :title => "Visit Google!", :rel => "that-related-thing" }

using_string = hash_to_attributes_using_string(@hash)
using_array  = hash_to_attributes_using_array(@hash)

raise "Strings don't match!" unless using_string == using_array

n = 999999999999999999999
Benchmark.bm do |x|
  x.report { hash_to_attributes_using_string(@hash) }
  x.report { hash_to_attributes_using_array(@hash) }
end