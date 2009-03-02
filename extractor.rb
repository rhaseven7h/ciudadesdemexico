#!/usr/bin/env ruby

require 'rubygems'
require 'htmlentities'
require 'yaml'
require 'pp'

def fetch_line(str_line)
  if str_line && str_line.length > 0
    coder = HTMLEntities.new
    parts = coder.encode(str_line).split('|')
    if parts[3] && parts[4] && parts[3].class == String && parts[4].class == String
      {
        :city  => coder.encode(parts[3], :named),
        :state => coder.encode(parts[4], :named)
      }
    else
      nil
    end
  else
    nil
  end
end

STDERR.puts "Fetching Data ..."
locations = []
cnt=0
File.open('mexico.txt').each_line do |line|
  cnt += 1
  STDERR.puts "Extracting #{cnt} of 90747" if (cnt % 1000) == 0
  locations << fetch_line(line)
end

STDERR.puts "Compacting ..."
locations.compact!

STDERR.puts "Removing duplicate records ..."
locations.uniq!

STDERR.puts "#{locations.size} unique locations"

STDERR.puts "Extracting locations ..."
data = [ { :country => 'M&eacute;xico', :states => locations.map{ |location| { :state => location[:state], :cities => [] } }.compact.uniq } ]
STDERR.puts 
cnt = 0
locations.each do |location|
  cnt += 1
  STDERR.puts "Distributing #{cnt} of #{locations.size}" if (cnt % 100) == 0
  data[0][:states].select{ |state| state[:state] == location[:state] }[0][:cities] << location[:city]
end

STDERR.puts "Generating result database ..."
puts data.to_yaml
STDERR.puts "Compilation done."
STDERR.puts

