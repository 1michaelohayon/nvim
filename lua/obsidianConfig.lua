require("obsidian").setup({
  legacy_commands = false,

  workspaces = {
    {
      name = "notes",
      path = "$WIN/Documents/Obsidian/work/",
    },
    {
      name = "notes",
      path = "~/plidea/",
    },
  },

  picker = {
    name = "telescope.nvim",
  },
})
