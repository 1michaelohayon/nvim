function ColorMyPencils(scheme)
    require("colorizer").attach_to_buffer(0, { mode = "background", css = true})
    require('kanagawa').setup({
        keywordStyle = {  italic = false, bold = true},
    })
	vim.cmd.colorscheme(scheme or "kanagawa-dragon")
    
    if not scheme then
    	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    	vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
        
        vim.api.nvim_set_hl(0, "TelescopeBorder", {bg="none"}) 
    
        vim.api.nvim_set_hl(0, "SignColumn", {bg="none"}) 
    
        vim.cmd('highlight CursorLine guibg=#161a1a')
        vim.cmd('highlight StatusLine guibg=#252630 guifg=#989887')
    end
end

------------------------------------------------------------
local function executeCommand(command)
  local handle = io.popen(command)
  local output = handle:read("*a")
  handle:close()
  return output
end

local command = "gsettings get org.gnome.desktop.interface gtk-theme"
local output = executeCommand(command)

if output:find("dark") then
ColorMyPencils() -- dark
else
ColorMyPencils() -- light
end

