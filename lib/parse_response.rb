require 'yajl'

class ParseResponse
  attr_reader :hash

  def initialize(file)
    json = File.new("#{file}", 'r')
    parser = Yajl::Parser.new
    
    puts "Parsing #{file}"
    @hash = parser.parse(json)
  end

end
