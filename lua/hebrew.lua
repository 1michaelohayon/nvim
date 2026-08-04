-- ============================================================================
-- Make Normal/Visual/Operator-pending mode commands (hjkl, dd, yy, v, ...)
-- keep working by physical key when the OS keyboard layout itself is
-- switched to Hebrew (not this file's own <C-Space> toggle, which only
-- affects Insert mode). Uses 'langmap' to translate the Hebrew character a
-- key produces back to the Latin command it corresponds to on the standard
-- Israeli (SI-1452) layout — the same layout Vim's own 'keymap=hebrew'
-- models (see $VIMRUNTIME/keymap/hebrew_utf-8.vim).
-- ============================================================================
local hebrew_langmap_pairs = {
  { '\u{5e9}', 'a' }, -- ש
  { '\u{5e0}', 'b' }, -- נ
  { '\u{5d1}', 'c' }, -- ב
  { '\u{5d2}', 'd' }, -- ג
  { '\u{5e7}', 'e' }, -- ק
  { '\u{5db}', 'f' }, -- כ
  { '\u{5e2}', 'g' }, -- ע
  { '\u{5d9}', 'h' }, -- י
  { '\u{5df}', 'i' }, -- ן
  { '\u{5d7}', 'j' }, -- ח
  { '\u{5dc}', 'k' }, -- ל
  { '\u{5da}', 'l' }, -- ך
  { '\u{5e6}', 'm' }, -- צ
  { '\u{5de}', 'n' }, -- מ
  { '\u{5dd}', 'o' }, -- ם
  { '\u{5e4}', 'p' }, -- פ
  { '/', 'q' },
  { '\u{5e8}', 'r' }, -- ר
  { '\u{5d3}', 's' }, -- ד
  { '\u{5d0}', 't' }, -- א
  { '\u{5d5}', 'u' }, -- ו
  { '\u{5d4}', 'v' }, -- ה
  { "'", 'w' },
  { '\u{5e1}', 'x' }, -- ס
  { '\u{5d8}', 'y' }, -- ט
  { '\u{5d6}', 'z' }, -- ז
  { '\u{5ea}', ',' }, -- ת
  { '\u{5e5}', '.' }, -- ץ
  { '\u{5e3}', ';' }, -- ף
  { ',', "'" },
  { '.', '/' },
  { ';', '`' },
}

local function langmap_escape(c)
  if c == ',' or c == ';' or c == '\\' then
    return '\\' .. c
  end
  return c
end

local langmap_parts = {}
for _, pair in ipairs(hebrew_langmap_pairs) do
  table.insert(langmap_parts, langmap_escape(pair[1]) .. langmap_escape(pair[2]))
end
vim.opt.langmap = table.concat(langmap_parts, ',')
vim.opt.langremap = false -- don't re-run langmap on keys already produced by a mapping

-- Defining the different cursors in a table
local guicursor_ltr = table.concat({
  'n-v-c:block', -- normal/visual/cmdline: block
  'i-ci-ve:ver25', -- insert/insert-cmd/visual-exclude: vertical bar (steady)
  'r-cr:hor20', -- replace modes: underline
  'o:hor50', -- operator-pending
}, ',')

local guicursor_rtl = table.concat({
  'n-v-c:block', -- normal/visual/cmdline: block
  'i-ci-ve:hor20', -- insert becomes underline (steady) for RTL
  'r-cr:hor20',
  'o:hor50',
}, ',')

-- Default to LTR cursor shapes
vim.o.guicursor = guicursor_ltr

local function enable_hebrew_spell()
  vim.opt_local.spelllang = { 'he', 'en_us' }
  -- Disable capitalization check, as Hebrew doesn’t have caps
  vim.opt_local.spellcapcheck = ''
  vim.opt_local.spellsuggest = 'best,9'
end

local function enable_english_spell()
  vim.opt_local.spelllang = { 'en_us' }
  vim.opt_local.spellcapcheck = vim.api.nvim_get_option_value('spellcapcheck', { scope = 'global' })
  vim.opt_local.spellsuggest = 'best,9'
end

local function ToggleHebrewMode()
  local heb_mode = vim.b.hebrew_mode_enabled

  if not heb_mode then
    vim.opt_local.keymap = 'hebrew'
    vim.opt_local.iminsert = 1
    vim.opt_local.imsearch = 1
    vim.opt_local.rightleft = true
    vim.b.hebrew_mode_enabled = true

    vim.o.guicursor = guicursor_rtl

    --enable_hebrew_spell()

    vim.notify('Hebrew mode: ON', vim.log.levels.INFO)
  else
    vim.opt_local.keymap = ''
    vim.opt_local.iminsert = 0
    vim.opt_local.imsearch = 0
    vim.opt_local.rightleft = false
    vim.b.hebrew_mode_enabled = false

    vim.o.guicursor = guicursor_ltr

    --enable_english_spell()

    vim.notify('Hebrew mode: OFF', vim.log.levels.INFO)
  end
end

-- Expose as a command, just in case
vim.api.nvim_create_user_command('HebrewToggle', function()
  ToggleHebrewMode()
end, {})

-- And as a keymap
vim.keymap.set({ 'n', 'i' }, '<C-Space>', function()
  vim.cmd.HebrewToggle()
end, { silent = true, desc = 'Toggle Hebrew mode' })

