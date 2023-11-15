local saySym = {
  ['('] = ' paren ',
  [')'] = ' close paren, ',
  ['['] = ' bracket ',
  [']'] = ' close bracket, ',
  ['{'] = ' brace ',
  ['}'] = ' close brace. ',
  ['<'] = ' angle ',
  ['>'] = ' close angle, ',
  ['"'] = ', quotes, ',
  ["'"] = ', quote, ',
  ['$'] = ' dollar ',
  ['/'] = ' slash ',
  ['.'] = ' dot ',
  [','] = ' comma, ',
  [':'] = ' colon: ',
  [';'] = ', stop! ',
} -- TODO fall back to unicode 'ga' output

local function Psay(range_start, range_end, command)
  if range_start then
    if range_end then
      command = range_start .. ',' .. range_end .. command
    else
      command = range_start .. command
    end
  end
  vim.api.nvim_command(command)

  local output = vim.fn.execute(command)
  output = output:gsub("(%p)", function(s) return saySym[s] end)
  local lines = {}
  for nr, line in output:gmatch("[ \t]*([0-9]+)[ \t]+([^ \t\n][^\n]+)\n?") do
    if line ~= "" then
      table.insert(lines, '– line '.. nr .. ': ' .. line .. ';')
    end
  end
  local text = table.concat(lines, '! ')
  vim.fn.system('echo "' .. vim.fn.shellescape(text) .. ' –" | say -r160')
end

_G.Psay = Psay
