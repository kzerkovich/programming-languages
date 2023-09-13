require_relative './task23-weather'
require_relative './task23-3'

def runGlassHouse
  Glasshouse.new.start
end

def runMyGlassHouse
  MyGlasshouse.new.start
end

if ARGV.count == 0
  runMyGlassHouse
elsif ARGV.count != 1
  puts "usage: task23-runner.rb [my | original]"
elsif ARGV[0] == "my"
  runMyGlassHouse
elsif ARGV[0] == "original"
  runGlassHouse
else
  puts "usage: task23-runner.rb [my | original]"
end

