vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", vim.cmd.Oil)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")



vim.keymap.set("n", "<n>", "<nzzzv")
vim.keymap.set("n", "<N>", "<Nzzzv")


-- save
vim.api.nvim_set_keymap('n', '<c-s>', ':w<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<c-s>', '<c-o>:w<CR>', {noremap = true, silent = true})

-- Hebrew-layout Ctrl equivalents: langmap only translates unmodified keys, not
-- Ctrl-chords, so under a Hebrew OS keyboard layout <C-s>/<C-w> land on whatever
-- the physical key produces instead. ד and ' are what the physical s/w keys type
-- under the Israeli layout (same pairing as hebrew_langmap_pairs in hebrew.lua).
vim.api.nvim_set_keymap('n', '<c-\u{5d3}>', ':w<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<c-\u{5d3}>', '<c-o>:w<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', "<c-'>", '<c-w>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', "<c-'>", '<c-w>', {noremap = true, silent = true})

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

-- Hebrew-layout equivalents of the two above (ל/ח are what the physical k/j
-- keys type under the Israeli layout, same pairing as hebrew_langmap_pairs).
vim.keymap.set("n", "<C-\u{5dc}>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-\u{5d7}>", "<cmd>cprev<CR>zz")


vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })


-- Alt+[hjkl] to navigate through splits in terminal mode
-- vim.keymap.set("n", "<M-h>", "<C-\\><C-n><C-w>h")
-- vim.keymap.set("n", "<M-j>", "<C-\\><C-n><C-w>j")
-- vim.keymap.set("n", "<M-k>", "<C-\\><C-n><C-w>k")
-- vim.keymap.set("n", "<M-l>", "<C-\\><C-n><C-w>l")
