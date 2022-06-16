#!/usr/bin/env ruby

HOME = ENV['HOME']
TEXT = "/Volumes/Huluk/Documents"
IMG = "/Volumes/Huluk/Pictures"
IOTA = "i" # proper iota doesn't work :(

ARGV.each do |filepath|
  name = File.basename(filepath)
  destination =
    case name
    when /^\w{3}_P_CH.*\.pdf/
      "#{TEXT}/Adulting/Konto/PostFinance/"
    when /^Revolut.*\.pdf/
      "#{TEXT}/Adulting/Konto/Revolut/"
    when /^(Girok|Extra_K)onto_(5419513690|5559012820)_Kontoauszug_\d*\.pdf/
      "#{TEXT}/Adulting/Konto/DiBa/"
    when /^\d{8}_.*_Payslip_\d{6}\.pdf/
      "#{TEXT}/Adulting/Arbeit/Google/Payslips/"
    when /^FLT_/, /^FLIX-/
      "#{TEXT}/Travel/Tickets/"
    when /^Esperanto_aktuell.*\.pdf/
      "#{TEXT}/Esperanto/Magazine/Esperanto Aktuell/"
    when /^Kontakto[_\d]+\.pdf/
      "#{TEXT}/Esperanto/Magazine/Kontakto/"
    when /^Screenshot/
      "#{HOME}/Pictures/"
    when /^#{IOTA}\-/
      "#{IMG}/Internetz/#{name.sub(/\w+\-/, '')}"
    when /^#{IOTA}m\-/
      "#{IMG}/Internetz/Maps/#{name.sub(/\w+\-/, '')}"
    when /^#{IOTA}c\-/
      "#{IMG}/Internetz/Compasses/#{name.sub(/\w+\-/, '')}"
    when /^#{IOTA}l\-/
      "#{IMG}/Internetz/Learn/#{name.sub(/\w+\-/, '')}"
    # when /^#{IOTA}s\-/
    #   "#{IMG}/Internetz/Stuff/#{name.sub(/\w+\-/, '')}"
    else
      nil
    end
  if not destination.nil?
    system "[[ -e '#{filepath}' ]] && mv '#{filepath}' '#{destination}'"
  end
end
