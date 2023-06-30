require("yanky").setup({
  ring = {
    history_length = 100,
    storage = "shada",
    sync_with_numbered_registers = true,
    cancel_event = "update",
    ignore_registers = { "_" },
  },
  system_clipboard = {
    sync_with_ring = true,
  },
})
vim.keymap.set("n", "<M-n>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<M-p>", "<Plug>(YankyCycleBackward)")
