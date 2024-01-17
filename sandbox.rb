# Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].each do |file|
#   require file unless file == './lib/runner.rb'
# end

# require 'pry-byebug'; binding.pry
# puts 'exit'

module TestModule

  def output_instance_variable
    puts @instance_variable
  end

end

class TestClass
  include TestModule

  def initialize
    @instance_variable = 'test'
  end

end

require 'pry-byebug'; binding.pry
put "done"
