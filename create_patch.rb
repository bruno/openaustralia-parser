#!/usr/bin/env ruby
# Create a patch easily for a particular date

$:.unshift "#{File.dirname(__FILE__)}/lib"

require 'environment'
require 'optparse'
require 'date'
require 'people_csv_reader'
require 'hansard_parser'

OptionParser.new do |opts|
  opts.banner = <<EOF
Usage: create-patch.rb <reps|senate> <year.month.day>
EOF
end.parse!

if ARGV.size != 2
  puts "Wrong number of parameters"
  exit
end
    
if ARGV[0] == "reps"
  house = House.representatives
elsif ARGV[0] == "senate"
  house = House.senate
else
  puts "Expected 'reps' or 'senate' for first parameter"
  exit
end

date = Date.parse(ARGV[1])

# For the time being just edit the representatives

people = PeopleCSVReader.read_members
parser = HansardParser.new(people)

# First check that there isn't already a patch file
patch_file_path = "#{File.dirname(__FILE__)}/data/patches/#{house}.#{date}.xml.patch"

if File.exists?(patch_file_path)
  puts "Patch file #{patch_file_path} already exists..."
  exit
end

File.open("original.xml", "w") {|f| f << parser.hansard_xml_source_data_on_date(date, house)}
FileUtils.cp("original.xml", "patched.xml")
system("mate --wait patched.xml")
system("diff -u original.xml patched.xml > #{patch_file_path}")
