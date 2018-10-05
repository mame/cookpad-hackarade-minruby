#!/usr/bin/env ruby

require "open3"

Dir.glob("test*.rb").sort.each do |rb|
  ruby_result, _status = Open3.capture2e("ruby #{rb}")
  interp_result, _status = Open3.capture2e("./interp.rb #{rb}")
  if ruby_result == interp_result
    puts ". #{rb}"
  else
    puts "x #{rb}"
    puts "#{interp_result}\n"
  end
end