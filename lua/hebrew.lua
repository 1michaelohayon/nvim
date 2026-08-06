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

-- Session-wide toggle (not per-buffer/per-window), so it stays on across
-- :edit, buffer switches, Oil, new splits, etc. until pressed again.
local hebrew_mode_enabled = false

-- Single function applying every option for a given state, so ON and OFF
-- can never drift out of sync with each other.
local function set_hebrew_mode(enabled)
  hebrew_mode_enabled = enabled

  -- 'keymap'/'iminsert'/'imsearch' are local-to-buffer, but setting them
  -- with vim.opt (not vim.opt_local) also updates the global default that
  -- every buffer created/entered afterwards inherits.
  vim.opt.keymap = enabled and 'hebrew' or ''
  vim.opt.iminsert = enabled and 1 or 0
  vim.opt.imsearch = enabled and 1 or 0
  -- 'rightleft' is local-to-window with no such global default, so it's
  -- reapplied per-window by the autocmd below.
  vim.opt_local.rightleft = enabled

  vim.o.guicursor = enabled and guicursor_rtl or guicursor_ltr

  vim.notify('Hebrew mode: ' .. (enabled and 'ON' or 'OFF'), vim.log.levels.INFO)
end

local function toggle_hebrew_mode()
  set_hebrew_mode(not hebrew_mode_enabled)
end

-- Keep 'rightleft' in sync on every window as you navigate, since it has no
-- global default to inherit the way the buffer-local options above do.
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
  callback = function()
    vim.opt_local.rightleft = hebrew_mode_enabled
  end,
})

-- Also expose as a command, so it's scriptable/callable outside the keymap.
vim.api.nvim_create_user_command('HebrewToggle', function()
  toggle_hebrew_mode()
end, {})

-- And as a keymap
vim.keymap.set({ 'n', 'i' }, '<C-Space>', function()
  vim.cmd.HebrewToggle()
end, { silent = true, desc = 'Toggle Hebrew mode' })

-- Public: what physical-key correspondence does `latin_char` have under the
-- Israeli layout? e.g. hebrew_equivalent('s') -> 'ד'. Used by other files
-- (markdown.lua, remap.lua) to build Hebrew-layout Ctrl-chord aliases
-- without duplicating hebrew_langmap_pairs — see their "Hebrew-layout
-- equivalents" comments for why those aliases are needed.
local function hebrew_equivalent(latin_char)
  for _, pair in ipairs(hebrew_langmap_pairs) do
    if pair[2] == latin_char then
      return pair[1]
    end
  end
  return nil
end

return {
  hebrew_equivalent = hebrew_equivalent,
}

