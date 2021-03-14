#!/usr/bin/env ruby

HOME = ENV['HOME']
PICS = "/Volumes/Huluk/Pictures"
TEXT = "/Volumes/Huluk/Documents"

ARGV.each do |filepath|
  destination =
    case File.basename(filepath)
    when /^\w{3}_P_CH.*\.pdf/
      "#{TEXT}/Konto/PostFinance/"
    when /^Revolut.*\.pdf/
      "#{TEXT}/Konto/Revolut/"
    when /^(Girok|Extra_K)onto_(5419513690|5559012820)_Kontoauszug_\d*\.pdf/
      "#{TEXT}/Konto/DiBa/"
    when /^\d{8}_.*_Payslip_\d{6}\.pdf/
      "#{TEXT}/Arbeit/Google/Salary/"
    when /^Esperanto_aktuell.*\.pdf/
      "#{TEXT}/Esperanto/Magazine/Esperanto Aktuell/"
    when /^Kontakto[_\d]+\.pdf/
      "#{TEXT}/Esperanto/Magazine/Kontakto/"
    when /^pic-(.+)/
      "#{PICS}/Internetz/#{$1}"
    else
      nil
    end
  if not destination.nil?
    system "[[ -e '#{filepath}' ]] && rsync -a --remove-source-files '#{filepath}' '#{destination}'"
  end
end
