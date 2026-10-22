
-- ============================================================================
-- Markdown list/checkbox editing.
-- <C-x>            toggle current/selected line(s) into a checkbox, or flip
--                   done/undone if already a checkbox
-- <C-Right/Left>    indent/unindent current or selected line(s); direction
--                   flips automatically under Hebrew mode's 'rightleft'
-- <C-l>  (visual)   toggle selected lines between "-" bullets and "1." numbers
-- <CR>   (insert)   continue the current list marker on a new line; pressing
--                   it on an empty list item clears the marker instead
--
-- On save:
--   - Checklist blocks are sorted by completion state.
--   - Consecutive ordered-list items are renumbered starting from 1.
-- ============================================================================
local hebrew = require("hebrew")

-- ----------------------------------------------------------------------------
-- List-line parsing/rendering. Pure functions, no buffer access.
-- ----------------------------------------------------------------------------
local function parse_list_line(line)
  local indent, rest = line:match('^(%s*)(.*)$')

  local checked, content = rest:match('^[-*]%s+%[([ xX])%]%s?(.*)$')
  if checked then
    return indent, 'bullet', nil, checked, content
  end

  local num
  num, checked, content = rest:match('^(%d+)%.%s+%[([ xX])%]%s?(.*)$')
  if num then
    return indent, 'number', num, checked, content
  end

  content = rest:match('^[-*]%s+(.*)$')
  if content then
    return indent, 'bullet', nil, nil, content
  end

  num, content = rest:match('^(%d+)%.%s+(.*)$')
  if num then
    return indent, 'number', num, nil, content
  end

  return indent, nil, nil, nil, rest
end

local function render_list_line(indent, kind, number, checked, content)
  local marker = ''
  if kind == 'bullet' then
    marker = '- '
  elseif kind == 'number' then
    marker = (number or '1') .. '. '
  end
  local box = checked ~= nil and ('[' .. checked .. '] ') or ''
  return indent .. marker .. box .. content
end

-- ----------------------------------------------------------------------------
-- Checkbox toggle (<C-x>).
-- ----------------------------------------------------------------------------
local function toggle_checkbox(lnum)
  local indent, kind, number, checked, content =
    parse_list_line(vim.fn.getline(lnum))

  if checked == nil then
    checked = ' '
  elseif checked == ' ' then
    checked = 'x'
  else
    checked = ' '
  end

  kind = kind or 'bullet'
  vim.fn.setline(lnum, render_list_line(indent, kind, number, checked, content))
end

local function toggle_checkbox_range(start_line, end_line)
  for l = start_line, end_line do
    toggle_checkbox(l)
  end
end

-- ----------------------------------------------------------------------------
-- List type toggle (<C-l>, visual only).
-- ----------------------------------------------------------------------------
local function toggle_list_type(start_line, end_line)
  local _, first_kind = parse_list_line(vim.fn.getline(start_line))
  local target = (first_kind == 'number') and 'bullet' or 'number'
  local n = 1

  for l = start_line, end_line do
    local indent, _, _, checked, content =
      parse_list_line(vim.fn.getline(l))

    vim.fn.setline(l, render_list_line(indent, target, tostring(n), checked, content))
    n = n + 1
  end
end

-- ----------------------------------------------------------------------------
-- Ordered-list auto-renumber on save.
--
-- Renumbers each consecutive run of numbered items independently.
-- Indentation must match, and blank/non-numbered lines end a run.
-- A single numbered item is also reset to 1.
-- ----------------------------------------------------------------------------
local function renumber_ordered_lists(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local i = 1

  while i <= #lines do
    local indent, number =
      lines[i]:match('^(%s*)(%d+)%.%s+')

    if number then
      local start_idx = i
      local list_indent = indent

      -- Find the end of this consecutive list at the same indentation.
      while i <= #lines do
        local current_indent, current_number =
          lines[i]:match('^(%s*)(%d+)%.%s+')

        if not current_number or current_indent ~= list_indent then
          break
        end

        i = i + 1
      end

      -- Renumber from 1, preserving the rest of each line.
      for idx = start_idx, i - 1 do
        local current_indent, _, content =
          lines[idx]:match('^(%s*)(%d+)%.%s+(.*)$')

        if content then
          lines[idx] = current_indent .. (idx - start_idx + 1)
            .. '. ' .. content
        end
      end
    else
      i = i + 1
    end
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

-- ----------------------------------------------------------------------------
-- Checklist auto-sort on save.
-- ----------------------------------------------------------------------------
local checked_snapshots = {}

local function item_key(indent, content)
  return indent .. '\0' .. content
end

local function build_snapshot(lines)
  local snapshot = {}

  for _, line in ipairs(lines) do
    local indent, _, _, checked, content = parse_list_line(line)

    if checked ~= nil and checked ~= ' ' then
      snapshot[item_key(indent, content)] = true
    end
  end

  return snapshot
end

local function scan_checklist_block(lines, start_idx, end_idx)
  local first_indent = lines[start_idx]:match('^(%s*)')
  local items = {}
  local i = start_idx

  while i <= end_idx do
    local indent = lines[i]:match('^(%s*)')

    if indent ~= first_indent then
      break
    end

    local _, _, _, checked, content = parse_list_line(lines[i])

    if checked == nil then
      break
    end

    local item_start = i
    local item_end = i
    i = i + 1

    while i <= end_idx do
      local next_indent = lines[i]:match('^(%s*)')

      if #next_indent > #first_indent then
        item_end = i
        i = i + 1
      else
        break
      end
    end

    table.insert(items, {
      start_idx = item_start,
      end_idx = item_end,
      checked = checked,
      key = item_key(first_indent, content),
    })
  end

  return items, i
end

local function sort_checklist_range(lines, start_idx, end_idx, was_checked)
  local result = {}
  local i = start_idx

  while i <= end_idx do
    local _, _, _, checked = parse_list_line(lines[i])

    if checked == nil then
      table.insert(result, lines[i])
      i = i + 1
    else
      local items, next_idx = scan_checklist_block(lines, i, end_idx)

      for _, item in ipairs(items) do
        item.lines = { lines[item.start_idx] }

        if item.end_idx > item.start_idx then
          local inner = sort_checklist_range(
            lines, item.start_idx + 1, item.end_idx, was_checked
          )

          for _, l in ipairs(inner) do
            table.insert(item.lines, l)
          end
        end
      end

      local unchecked, new_checked, old_checked = {}, {}, {}

      for _, item in ipairs(items) do
        if item.checked == ' ' then
          table.insert(unchecked, item)
        elseif was_checked[item.key] then
          table.insert(old_checked, item)
        else
          table.insert(new_checked, item)
        end
      end

      for _, group in ipairs({ unchecked, new_checked, old_checked }) do
        for _, item in ipairs(group) do
          for _, l in ipairs(item.lines) do
            table.insert(result, l)
          end
        end
      end

      i = next_idx
    end
  end

  return result
end

local function sort_checklists(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local was_checked = checked_snapshots[bufnr] or {}
  local new_lines = sort_checklist_range(lines, 1, #lines, was_checked)

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
  checked_snapshots[bufnr] = build_snapshot(new_lines)
end

-- ----------------------------------------------------------------------------
-- Indent direction (<C-Right>/<C-Left>).
-- ----------------------------------------------------------------------------
local function want_indent(is_right_key)
  if vim.wo.rightleft then
    return not is_right_key
  end
  return is_right_key
end

-- ----------------------------------------------------------------------------
-- Enter continuation (<CR> in insert mode).
-- ----------------------------------------------------------------------------
local function feed(keys)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true
  )
end

local function smart_enter()
  if vim.fn.pumvisible() == 1 then
    feed('<C-y>')
    return
  end

  local lnum = vim.fn.line('.')
  local line = vim.fn.getline(lnum)
  local indent, kind, number, checked, content = parse_list_line(line)

  if kind == nil then
    if _G.MiniPairs then
      feed(MiniPairs.cr())
    else
      feed('<CR>')
    end
    return
  end

  if content == '' then
    vim.fn.setline(lnum, '')
    vim.fn.cursor(lnum, 1)
    return
  end

  local col = vim.fn.col('.')
  local before = line:sub(1, col - 1)
  local after = line:sub(col)

  local next_number =
    (kind == 'number') and tostring((tonumber(number) or 0) + 1) or nil
  local next_checked = (checked ~= nil) and ' ' or nil
  local new_line = render_list_line(indent, kind, next_number, next_checked, '')

  vim.fn.setline(lnum, before)
  vim.fn.append(lnum, new_line .. after)
  vim.fn.cursor(lnum + 1, #new_line + 1)
end

-- ----------------------------------------------------------------------------
-- Hebrew-layout equivalents.
-- ----------------------------------------------------------------------------
local function with_hebrew_alias(key, latin_char)
  local equivalent = hebrew.hebrew_equivalent(latin_char)
  return { key, '<C-' .. equivalent .. '>' }
end

local CHECKBOX_KEYS = with_hebrew_alias('<C-x>', 'x')
local LIST_TYPE_KEYS = with_hebrew_alias('<C-l>', 'l')

-- ----------------------------------------------------------------------------
-- Keymap wiring.
-- ----------------------------------------------------------------------------
local function visual_range()
  vim.cmd('normal! \27')

  local s, e = vim.fn.line("'<"), vim.fn.line("'>")

  if s > e then
    s, e = e, s
  end

  return s, e
end

local function setup_checkbox_keymaps(opts)
  for _, key in ipairs(CHECKBOX_KEYS) do
    vim.keymap.set('n', key, function()
      toggle_checkbox(vim.fn.line('.'))
    end, opts)

    vim.keymap.set('v', key, function()
      local s, e = visual_range()
      toggle_checkbox_range(s, e)
      vim.cmd('normal! gv')
    end, opts)
  end
end

local function setup_indent_keymaps(opts)
  local expr_opts = vim.tbl_extend('force', opts, { expr = true })

  vim.keymap.set('n', '<C-Right>', function()
    return want_indent(true) and '>>' or '<<'
  end, expr_opts)

  vim.keymap.set('n', '<C-Left>', function()
    return want_indent(false) and '>>' or '<<'
  end, expr_opts)

  vim.keymap.set('v', '<C-Right>', function()
    return want_indent(true) and '>gv' or '<gv'
  end, expr_opts)

  vim.keymap.set('v', '<C-Left>', function()
    return want_indent(false) and '>gv' or '<gv'
  end, expr_opts)
end

local function setup_list_type_keymaps(opts)
  for _, key in ipairs(LIST_TYPE_KEYS) do
    vim.keymap.set('v', key, function()
      local s, e = visual_range()
      toggle_list_type(s, e)
      vim.cmd('normal! gv')
    end, opts)
  end
end

local function setup_enter_keymap(opts)
  local function set_cr_mapping()
    vim.keymap.set('i', '<CR>', smart_enter, opts)
  end

  set_cr_mapping()

  vim.api.nvim_create_autocmd('InsertEnter', {
    buffer = opts.buffer,
    callback = set_cr_mapping,
  })
end

local function setup_checklist_sort(buf)
  checked_snapshots[buf] = build_snapshot(
    vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  )

  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = buf,
    callback = function()
      sort_checklists(buf)
    end,
  })
end

-- ----------------------------------------------------------------------------
-- Markdown FileType setup.
-- ----------------------------------------------------------------------------
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function(args)
    local opts = { buffer = args.buf, silent = true }

    setup_checkbox_keymaps(opts)
    setup_indent_keymaps(opts)
    setup_list_type_keymaps(opts)
    setup_enter_keymap(opts)
    setup_checklist_sort(args.buf)

    -- Renumber ordered lists whenever this Markdown buffer is saved.
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = args.buf,
      callback = function()
        renumber_ordered_lists(args.buf)
      end,
    })
  end,
})
