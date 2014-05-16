# encoding: UTF-8

require_relative 'entry.rb'
require_relative 'entry_array.rb'

COMMAND_SEPARATOR = /[\n;]/
COUNT_STRING = "- counting result: " # TODO pass as command

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
  result = ['']
  current_esc = nil; backslash = false
  command.each_char do |c|
    if backslash
      result.last << '\\' unless c == current_esc or current_esc.nil?
      result.last << c
      backslash = false
    elsif c == '\\'
      backslash = true
    elsif current_esc.nil?
      case c
      when ' ' then result << ''
      when /["']/ then current_esc = c
      else result.last << c
      end
    elsif c == current_esc
      current_esc = nil
    else
      result.last << c
    end
  end
  unless current_esc.nil?
    raise(ArgumentError, "not correctly terminated: #{current_esc}")
  end
  return result
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
