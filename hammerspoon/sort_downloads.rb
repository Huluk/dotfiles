#!/usr/bin/env ruby

HOME = ENV['HOME']
TEXT = "#{HOME}/Documents/Text und Schrift"

ok = true

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
		when /^Screenshot/
			"#{HOME}/Pictures/"
		else
			nil
		end
	if not destination.nil?
		ok &= system "[[ -e '#{filepath}' ]] && mv '#{filepath}' '#{destination}'"
	end
end

exit(ok ? 0 : 1)