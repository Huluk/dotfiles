#!/usr/bin/env ruby

HOME = ENV['HOME']
TEXT = "/Volumes/Huluk/Documents"
IMG = "/Volumes/Huluk/Pictures"
IOTA = "i" # proper iota doesn't work :(

def strip_prefix(str, prefix=/^\w+\-/)
  str.sub(prefix, '')
end

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
    when /^CI_NEWS/
      "#{TEXT}/Adulting/Versicherung/Cryonics/Newsletter/"
    when /^FLT_/, /^FLIX-/
      "#{TEXT}/Travel/Tickets/"
    when /^Esperanto_aktuell.*\.pdf/, /EA\d.\d{4}.reta/
      "#{TEXT}/Esperanto/Magazine/Esperanto Aktuell/"
    when /^Kontakto[_\d]+\.pdf/
      "#{TEXT}/Esperanto/Magazine/Kontakto/"
    when /^t23\-/
      "#{TEXT}/Travel/Tickets/2023/#{strip_prefix name}"
    when /^n\-/
      "#{TEXT}/Howto/Nähen/#{strip_prefix name}"
    when /^Screenshot/
      "#{HOME}/Pictures/"
    when /^#{IOTA}\-/
      "#{IMG}/Internetz/#{strip_prefix name}"
    when /^#{IOTA}m\-/
      "#{IMG}/Internetz/Maps/#{strip_prefix name}"
    when /^#{IOTA}c\-/
      "#{IMG}/Internetz/Compasses/#{strip_prefix name}"
    when /^#{IOTA}l\-/
      "#{IMG}/Internetz/Learn/#{strip_prefix name}"
    when /^#{IOTA}r\-/
      "#{IMG}/Internetz/Random/#{strip_prefix name}"
    when /^news\-/
      "#{TEXT}/About/Current Affairs/News Articles/#{strip_prefix name}"
    when /^zsz\-/
      "#{TEXT}/About/Current Affairs/News Articles/ZSZ/#{strip_prefix name}"
    when /^nzz\-/
      "#{TEXT}/About/Current Affairs/News Articles/NZZ/#{strip_prefix name}"
    when /^economist\-/
      "#{TEXT}/About/Current Affairs/News Articles/Economist/#{strip_prefix name}"
    else
      nil
    end
  if not destination.nil?
    system "[[ -e '#{filepath}' ]] && mv '#{filepath}' '#{destination}'"
  end
end
