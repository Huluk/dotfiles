class EntryArray
  def initialize
    @entries = []
    @entry = Hash.new
  end

  def add(entry)
    validate_is_entry(entry)
    validate_not_dup(entry)
    @entries << entry
    @entry[entry.title] = entry
  end

  def copy(source, destination)
    source = Entry.title_escape(source)
    destination = Entry.title_escape(destination)
    unless @entry[destination].nil? or @entry[source].nil?
      @entry[destination].append(@entry[source])
    end
  end

  def move(source, destination)
    copy(source, destination)
    clear(source)
  end

  def clear(target)
    target = Entry.title_escape(target)
    @entry[target].clear unless @entry[target].nil?
  end

  def print(io)
    @entries.each {|entry| entry.print(io)}
  end

  def read_command(command, src=nil, dest=nil)
    case command
    when 'copy' then self.copy(src,dest)
    when 'move' then self.move(src,dest)
    when 'clear' then self.clear(src)
    else warn("No such command `#{command}'")
    end
  end

  private

  def validate_is_entry(entry)
    unless entry.respond_to?(:print) && entry.respond_to?(:title)
      raise(ArgumentError,
            "expected entry, but was `#{entry.class}'", caller)
    end
  end

  def validate_not_dup(entry)
    unless @entry[entry.title].nil?
      raise(ArgumentError,
            "`#{entry}' is already member of `#{self}'", caller)
    end
  end
end
