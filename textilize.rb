#!/usr/bin/env ruby

require 'rubygems'
require 'redcloth'

if ARGV.size != 1
  STDERR.puts
  STDERR.puts "\t#{$0}"
  STDERR.puts "\t\tConverts textile markup files to html files and outputs to standard out."
  STDERR.puts
  STDERR.puts "\tUSAGE:"
  STDERR.puts "\t\t#{$0} <file to convert>"
  STDERR.puts
  exit
end

begin
  puts RedCloth.new(File.open(ARGV[0]).read).to_html
rescue Exception => e
  STDERR.puts
  STDERR.puts "An error occurred while processing file:"
  STDERR.puts "ERROR: #{e.message}"
  STDERR.puts
end
