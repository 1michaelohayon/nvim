local hebrew = require("hebrew")

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>e", vim.cmd.Oil)
vim.keymap.set("n", "<leader>" .. hebrew.hebrew_equivalent('e'), vim.cmd.Oil) -- Hebrew-layout equivalent

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")
-- J/K are Shift-modified: no Hebrew-layout equivalent is possible here.
-- Hebrew has no case, so Shift+key on the Israeli layout produces niqud
-- marks/punctuation instead of a "shifted Hebrew letter" — there's nothing
-- in hebrew_langmap_pairs (or that could be added to it) to translate back.


vim.keymap.set("n", "<n>", "<nzzzv")
vim.keymap.set("n", "<N>", "<Nzzzv")
-- <N> has the same Shift-modifier limitation as J/K above.


-- save: the English <C-s> lives in save.lua (loaded absolute last so
-- nothing can override it — see that file). Its Hebrew-layout equivalent
-- lives here since it doesn't need that same load-order guarantee.
vim.api.nvim_set_keymap('n', '<c-' .. hebrew.hebrew_equivalent('s') .. '>', ':w<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<c-' .. hebrew.hebrew_equivalent('s') .. '>', '<c-o>:w<CR>', {noremap = true, silent = true})

-- <C-w> (window-command prefix) is a Vim builtin — no English mapping
-- needed here, just its Hebrew-layout equivalent, aliased to the real thing.
vim.api.nvim_set_keymap('n', '<c-' .. hebrew.hebrew_equivalent('w') .. '>', '<c-w>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<c-' .. hebrew.hebrew_equivalent('w') .. '>', '<c-w>', {noremap = true, silent = true})

-- leader + p doesn't overrite the current clipboard
vim.keymap.set("x", "<leader>p", "\"_dP")
vim.keymap.set("x", "<leader>" .. hebrew.hebrew_equivalent('p'), "\"_dP") -- Hebrew-layout equivalent

-- system clipboard
--vim.keymap.set("n", "<leader>y", "\"+y")
--vim.keymap.set("v", "<leader>y", "\"+y")
--vim.keymap.set("n", "<leader>Y", "\"+Y")


-- quickfix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-" .. hebrew.hebrew_equivalent('k') .. ">", "<cmd>cnext<CR>zz") -- Hebrew-layout equivalent
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<C-" .. hebrew.hebrew_equivalent('j') .. ">", "<cmd>cprev<CR>zz") -- Hebrew-layout equivalent

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>" .. hebrew.hebrew_equivalent('k'), "<cmd>lnext<CR>zz") -- Hebrew-layout equivalent
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
vim.keymap.set("n", "<leader>" .. hebrew.hebrew_equivalent('j'), "<cmd>lprev<CR>zz") -- Hebrew-layout equivalent


vim.keymap.set("n", "Q", "<nop>")

local substitute_word_cmd = [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
vim.keymap.set("n", "<leader>r", substitute_word_cmd)
vim.keymap.set("n", "<leader>" .. hebrew.hebrew_equivalent('r'), substitute_word_cmd) -- Hebrew-layout equivalent
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })


-- Alt+[hjkl] to navigate through splits in terminal mode
-- vim.keymap.set("n", "<M-h>", "<C-\\><C-n><C-w>h")
-- vim.keymap.set("n", "<M-j>", "<C-\\><C-n><C-w>j")
-- vim.keymap.set("n", "<M-k>", "<C-\\><C-n><C-w>k")
-- vim.keymap.set("n", "<M-l>", "<C-\\><C-n><C-w>l")
