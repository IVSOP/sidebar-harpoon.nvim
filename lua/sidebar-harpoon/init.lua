local M = {}

M.buf = nil
M.is_open = false
M.is_focused = false -- cursed, whatever

-- internally creates a buffer
function M.create()
    if not M.buf
    then
        M.buf = vim.api.nvim_create_buf(false, true) -- Create a new buffer (not listed, scratch buffer)
        vim.api.nvim_set_option_value('buftype', 'nofile', {buf = M.buf}) -- Mark it as a non-file buffer
        -- vim.api.nvim_buf_set_option(M.buf, 'bufhidden', 'wipe') -- Automatically wipe buffer on close
        vim.api.nvim_set_option_value('modifiable', true, {buf = M.buf}) -- Allow modifications
        vim.api.nvim_buf_set_name(M.buf, "Harpooned files")
    end
end

-- opens buffer in a new window and the window tree
function M.open()
    if not M.is_open
    then
        vim.cmd("NvimTreeOpen") -- will focus it automatically
        -- vim.cmd("split")
        -- vim.cmd("wincmd j")
        -- vim.api.nvim_set_current_buf(M.buf)
        -- local win = vim.api.nvim_get_current_win()
        local win = vim.api.nvim_open_win(M.buf, false, {split = "below", height = 9}) -- TODO: set initial bufpos here
        vim.api.nvim_set_option_value("relativenumber", false, {win = win})
        vim.api.nvim_set_option_value("signcolumn", "no", {win = win})
        vim.api.nvim_set_option_value("cursorline", true, {win = win})
        -- vim.api.nvim_win_set_height(win, 9)
        vim.cmd("wincmd h")
        M.is_open = true
    end
end

-- receives a list(table?) of strings
-- sets the message to be displayed
function M.display(lines)
    vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, lines)
end

-- closes buffer and tree
function M.close()
    if M.is_open
    then
        vim.cmd("NvimTreeClose")
        vim.cmd("wincmd l")
        vim.cmd("close")
        -- print(vim.api.nvim_buf_is_valid(M.buf))
        M.is_open = false
    end
end

function M.toggle()
    if M.is_open
    then
        M.close()
    else
        M.open()
    end
end

function M.destroy()
    vim.api.nvim_buf_delete(M.buf, { force = true })
end

-- assumes open
function M.focus()
    if not M.is_focused
    then
        vim.cmd("wincmd l")
        -- vim.cmd("wincmd j")
        M.is_focused = true
    end
end

-- assumes open
function M.unfocus()
    if M.is_focused
    then
        vim.cmd("wincmd h")
        -- vim.cmd("wincmd j")
        M.is_focused = false
    end
end

function M.focus_toggle()
    if M.is_open
    then
        if M.is_focused
        then
            M.unfocus()
        else
            M.focus()
        end
    end
end

function M.select(number)
    M.focus()
    vim.cmd("wincmd j")
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_cursor(win, { number, 0 })
    M.unfocus()
end

return M

-- return {
--     "sidebar-nvim/sidebar.nvim",
--     dependencies = {
--         "nvim-tree/nvim-tree.lua",
--     },
--     config = function()
--         require("sidebar-nvim").setup({
--             disable_default_keybindings = 0,
--             bindings = nil,
--             open = false,
--             side = "right",
--             initial_width = 35,
--             hide_statusline = false,
--             update_interval = 1000,
--             sections = { "files" },
--             section_separator = {"", "-----", ""},
--             section_title_separator = {""},
--             containers = {
--                 attach_shell = "/bin/sh", show_all = true, interval = 5000,
--             },
--             datetime = { format = "%a %b %d, %H:%M", clocks = { { name = "local" } } },
--             todos = { ignored_paths = { "~" } },
--         })
--     end
-- }

