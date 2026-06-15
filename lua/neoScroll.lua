function smoothScroll()
    require('neoscroll').setup({
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = nil,
        pre_hook = nil,
        post_hook = nil,
        performance_mode = false,
    })

    --  override Ctrl+F here
    vim.keymap.set("n", "<C-f>", function()
        require("telescope.builtin").live_grep()
    end, { desc = "Telescope live grep" })
end

smoothScroll()
