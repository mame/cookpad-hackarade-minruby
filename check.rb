#!/usr/bin/env ruby

require 'minruby'
require 'colorize'
require 'pp'

MY_PROGRAM = 'interp.rb'

Dir.glob("test#{ARGV[0]}*.rb").sort.each do |f|
  correct = `ruby #{f}`
  answer = `ruby #{MY_PROGRAM} #{f}`

  print "#{f} => "
  if correct == answer
    puts "OK!".green
  else
    puts "NG".red

    puts "=== Expect ==="
    puts correct
    puts "=== Actual ==="
    puts answer
    code = File.read(f)
    puts "=== Test Program ==="
    puts code
    puts "=== AST ==="
    pp minruby_parse(code)

    exit(1)
  end
end
