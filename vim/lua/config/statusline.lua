-- Add a compact encoding/format indicator to the statusline.

-- Guard against narrow windows.
local MIN_COLUMNS = 40

-- Encoding marker mapping. Circle = BOM present, capital = big-endian,
-- trailing digit = width in bits (omitted for utf-8 since it's implicit).
--
--   Ⓤ    utf-8   + BOM       Ⓤ 16  utf-16 BE + BOM     Ⓤ 32  utf-32 BE + BOM
--   U16  utf-16 BE           U32   utf-32 BE
--   ⓤ 16 utf-16 LE + BOM     ⓤ 32  utf-32 LE + BOM
--   u16  utf-16 LE           u32   utf-32 LE
--   Ⓛ    latin1              Ⓔ     any other encoding
--   (empty)  utf-8 no BOM    (empty)  below MIN_COLUMNS
local function encoding_marker()
  local enc = vim.bo.fileencoding
  local bom = vim.bo.bomb

  -- utf-8 / empty: no endianness, BOM optional.
  if enc == '' or enc == 'utf-8' then
    return bom and 'Ⓤ' or ''
  end

  -- utf-16 / utf-32 / ucs-2 / ucs-4 (+ le/be suffix).
  local family, width = enc:match('^(utf)%-(%d+)')
  if not family then
    family, width = enc:match('^(ucs)%-(%d+)')
    if family == 'ucs' then
      -- ucs-2 is 16-bit, ucs-4 is 32-bit.
      width = (width == '2') and '16' or '32'
    end
  end
  if family then
    local suffix = enc:sub(-2)
    local is_le  = suffix == 'le'
    if bom then
      -- Circled glyphs crowd the digit visually; separate them.
      return (is_le and 'ⓤ' or 'Ⓤ') .. ' ' .. width
    end
    return (is_le and 'u' or 'U') .. width
  end

  if enc == 'latin1' then return 'Ⓛ' end
  return 'Ⓔ'
end

-- Exposed as a global so the %{} expression doesn't pay for a `require`
-- lookup on every redraw.
function _G.statusline_encoding()
  if vim.o.columns < MIN_COLUMNS then
    return ''
  end
  local parts  = {}
  local marker = encoding_marker()
  if marker ~= '' then
    table.insert(parts, marker)
  end
  local fmt = vim.bo.fileformat
  if fmt ~= '' and fmt ~= 'unix' then
    table.insert(parts, '[' .. fmt .. ']')
  end
  if #parts == 0 then
    return ''
  end
  return table.concat(parts, ' ') .. ' '
end

local ENCODING = [[%#WarningMsg#%{v:lua.statusline_encoding()}%*]]

local function splice_statusline()
  local default = vim.o.statusline
  if default == '' then
    vim.o.statusline = '%<%f %h%m%r%=' .. ENCODING .. '%-14.(%l,%c%V%) %P'
    return
  end
  -- Insert our slot immediately before the first %= (right-align marker),
  -- so the encoding indicator sits at the left edge of the right-aligned
  -- section alongside the ruler / diagnostic / busy fields.
  -- Function replacement sidesteps gsub's %-escaping in the pattern output.
  local spliced, n = default:gsub('%%=',
    function() return '%=' .. ENCODING end, 1)
  if n == 0 then
    -- No %= found; just append.
    spliced = default .. ENCODING
  end
  vim.o.statusline = spliced
end

vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('UserStatuslineSplice', { clear = true }),
  callback = splice_statusline,
})
