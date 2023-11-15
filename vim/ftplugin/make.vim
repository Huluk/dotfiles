" make all commands phony
nmap <leader>! :execute "normal ggO.PHONY: all $(MAKECMDGOALS)"<CR>
