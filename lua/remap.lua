local hebrew = require("hebrew")

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", vim.cmd.Oil)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")



vim.keymap.set("n", "<n>", "<nzzzv")
vim.keymap.set("n", "<N>", "<Nzzzv")


-- Hebrew-layout Ctrl equivalents: langmap only translates unmodified keys, not
-- Ctrl-chords, so under a Hebrew OS keyboard layout <C-s>/<C-w> land on whatever
-- the physical key produces instead. hebrew.hebrew_equivalent() looks up what
-- that physical key types under the Israeli layout (hebrew.lua's langmap table).
local heb_s = hebrew.hebrew_equivalent('s')
local heb_w = hebrew.hebrew_equivalent('w')
vim.api.nvim_set_keymap('n', '<c-' .. heb_s .. '>', ':w<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<c-' .. heb_s .. '>', '<c-o>:w<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<c-' .. heb_w .. '>', '<c-w>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<c-' .. heb_w .. '>', '<c-w>', {noremap = true, silent = true})

-- leader + p doesn't overrite the current clipboard
vim.keymap.set("x", "<leader>p", "\"_dP")

-- system clipboard
--vim.keymap.set("n", "<leader>y", "\"+y")
--vim.keymap.set("v", "<leader>y", "\"+y")
--vim.keymap.set("n", "<leader>Y", "\"+Y")


-- quickfix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Hebrew-layout equivalents of the two above.
vim.keymap.set("n", "<C-" .. hebrew.hebrew_equivalent('k') .. ">", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-" .. hebrew.hebrew_equivalent('j') .. ">", "<cmd>cprev<CR>zz")


vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })


-- Alt+[hjkl] to navigate through splits in terminal mode
-- vim.keymap.set("n", "<M-h>", "<C-\\><C-n><C-w>h")
-- vim.keymap.set("n", "<M-j>", "<C-\\><C-n><C-w>j")
-- vim.keymap.set("n", "<M-k>", "<C-\\><C-n><C-w>k")
-- vim.keymap.set("n", "<M-l>", "<C-\\><C-n><C-w>l")
