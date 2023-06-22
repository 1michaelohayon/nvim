vim.g.mapleader = " "
--vim.keymap.set("n", "<leader>ee", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")


vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<n>", "<nzzzv")
vim.keymap.set("n", "<N>", "<Nzzzv")


-- leader + p doesn't overrite the current clipboard
vim.keymap.set("x", "<leader>p", "\"_dP")

-- system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")


-- quickfix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")


vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })


-- Alt+[hjkl] to navigate through splits in terminal mode
-- vim.keymap.set("n", "<M-h>", "<C-\\><C-n><C-w>h")
-- vim.keymap.set("n", "<M-j>", "<C-\\><C-n><C-w>j")
-- vim.keymap.set("n", "<M-k>", "<C-\\><C-n><C-w>k")
-- vim.keymap.set("n", "<M-l>", "<C-\\><C-n><C-w>l")
