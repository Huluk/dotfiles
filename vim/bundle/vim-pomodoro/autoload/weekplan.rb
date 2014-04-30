require_relative 'entry.rb'
require_relative 'entry_array.rb'

COMMAND_SEPARATOR = /[\n;]/

def weekplan_parse(lines)
  lines = lines.drop_while{|line| not line =~ TITLE_REGEX}
  exit if lines.empty? # TODO error message
  entry = Entry.new(lines.shift)
  entries = EntryArray.new
  lines.each do |line|
    if line =~ TITLE_REGEX
      entries.add(entry)
      entry = Entry.new(line)
    elsif line =~ /[[:print:]]/
      entry.add(line)
    end
  end
  entries.add(entry)
  return entries
end

def command_parse(command)
  result = ''
  current_esc = nil; backslash = false
  command.each_char do |c|
    if c =~ /[[:alnum:]]/ or (current_esc.nil? and c==' ') 
      result << c
    elsif c == current_esc && !backslash then current_esc=nil
    elsif c =~ /["']/ and current_esc.nil? then current_esc=c
    elsif c == '\\' then backslash=true; next
    end
    backslash = false
  end
  return result.split
end

TITLE_REGEX = Regexp.new(ARGV.shift)
commands = ARGV.shift
ARGV.clear

entries = weekplan_parse($stdin.readlines)

commands.split(COMMAND_SEPARATOR).each do |command|
  next if command.empty?
  entries.read_command(*command_parse(command))
end

entries.print($stdout)
