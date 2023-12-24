local coq = require('coq')

local M = {}

function M.pre()
  vim.g.coq_settings = {
    ['display.icons.mode'] = 'none',
    ['completion.always'] = false,
    ['keymap.jump_to_mark'] = '<LocalLeader>m',
  }
end

function M.ensure_capabilities(_, opts)
  return coq.lsp_ensure_capabilities(opts)
end

function M.post()
  vim.api.nvim_command('COQnow -s')
end

return M
