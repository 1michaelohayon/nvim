-- Green/red statusline flash tied to the write event itself (BufWritePre/
-- the write's outcome), not to any specific save keybind — fires for :w,
-- <C-s>, <C-ד>, :wa, or anything else that writes the buffer. Only flashes
-- when there were actual changes to write; a redundant :w on an
-- already-saved buffer does nothing.

local FLASH_MS = 500
local GREEN = '#2ecc71'
local RED = '#e74c3c'

-- Captured lazily on the first-ever flash (not at module load) so repeated
-- flashes always revert to the true original rather than a previously-
-- flashed color. Module load happens during init.lua, before the
-- colorscheme is applied at the bottom of it — capturing here instead of
-- then would freeze in the pre-colorscheme default, not the real color.
local baseline = nil
local revert_timer = nil

local function flash(color)
  if not baseline then
    baseline = vim.api.nvim_get_hl(0, { name = 'StatusLine', link = false })
  end
  if revert_timer then
    revert_timer:stop()
  end
  vim.api.nvim_set_hl(0, 'StatusLine', vim.tbl_extend('force', baseline, { bg = color }))
  revert_timer = vim.defer_fn(function()
    vim.api.nvim_set_hl(0, 'StatusLine', baseline)
    revert_timer = nil
  end, FLASH_MS)
end

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    local buf = args.buf
    local was_modified = vim.bo[buf].modified
    if not was_modified then
      return
    end
    -- Deferred to the next event-loop tick so it runs after the write
    -- attempt (success or failure) has fully resolved, including any
    -- error thrown partway through. BufWritePost only fires on success,
    -- so checking 'modified' afterwards is the only way to also detect
    -- failure generically, regardless of what command triggered the write:
    -- Vim only ever clears 'modified' on an actually-successful write.
    vim.schedule(function()
      if vim.bo[buf].modified then
        flash(RED)
      else
        flash(GREEN)
      end
    end)
  end,
})
