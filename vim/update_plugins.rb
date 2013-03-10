#!/usr/bin/env ruby

exclude = [
  "snipmate.vim",
  "eclim",
  "vim-peepopen",
]

git_bundles = [ 
  "git://github.com/tpope/vim-surround.git",
  "git://github.com/ervandew/supertab.git",
  "git://github.com/godlygeek/tabular.git",
  "git://github.com/tpope/vim-markdown.git",
  "git://github.com/tpope/vim-repeat.git",
  "git://github.com/jimenezrick/vimerl.git",
  "git://github.com/tsaleh/vim-matchit.git",
  "git://github.com/scrooloose/syntastic.git",
  "git://github.com/tpope/vim-commentary.git",
  "git://github.com/tpope/vim-endwise.git",
  "git://github.com/tpope/vim-rvm.git",
  "git://github.com/vim-scripts/YankRing.vim.git",
  "git://github.com/Lokaltog/vim-easymotion.git",
  "git://github.com/uguu-org/vim-matrix-screensaver.git",
]

vim_org_scripts = [
  #["IndexedSearch", "7062",  "plugin"],
  ["ListMaps", "2494", "plugin"],
]

require 'fileutils'
require 'open-uri'

bundles_dir = File.join(File.dirname(__FILE__), "bundle")

FileUtils.cd(bundles_dir)

puts "trashing (lookout!)"
Dir["*"].delete_if{|d| exclude.include? d }.each {|d| FileUtils.rm_rf d }

git_bundles.each do |url|
  dir = url.split('/').last.sub(/\.git$/, '')
  puts "unpacking #{url} into #{dir}"
  `git clone #{url} #{dir}`
  FileUtils.rm_rf(File.join(dir, ".git"))
end

vim_org_scripts.each do |name, script_id, script_type|
  puts "downloading #{name}"
  local_file = File.join(name, script_type, "#{name}.vim")
  FileUtils.mkdir_p(File.dirname(local_file))
  File.open(local_file, "w") do |file|
    file << open("http://www.vim.org/scripts/download_script.php?src_id=#{script_id}").read
  end
end

puts "\nDone. Please update snapmate.vim and eclim manually!"
puts "Eclim Paths:\n~/.vim/bundle/eclim\n/Applications/Eclipse"
puts "Please check snapmate.vim's syntax folder for custom syntax!"
