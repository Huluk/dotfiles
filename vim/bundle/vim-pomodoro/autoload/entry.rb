class Entry
  attr_reader :lines

  def self.title_escape(title)
    title.gsub(/[^[:alnum:]]/,'').downcase
  end

  def initialize(title)
    @title = title
    @lines = []
  end

  def add(line)
    @lines << line
  end

  def append(entry)
    entry.lines.each do |line|
      self.add(line)
    end
  end

  def clear
    @lines.clear
  end

  def count(regex)
    result = 0
    @lines.each do |line|
      match = line.match(regex)
      result += match['result'].to_f unless match.nil?
    end
    return result
  end

  def title
    self.class.title_escape(@title)
  end

  def print(io)
    io.print(@title)
    @lines.each do |line|
      io.print(line)
    end
    io.puts
  end
end

