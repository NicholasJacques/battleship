Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].each do |file|
  require file unless file == './lib/runner.rb'
end

require 'pry-byebug'; binding.pry
puts 'exit'