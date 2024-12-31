local M = {}

M.buf = nil
M.is_focused = false -- cursed, whatever
M.window = nil

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
    if not M.is_open()
    then
        vim.cmd("NvimTreeOpen") -- will focus it automatically
        M.win = vim.api.nvim_open_win(M.buf, false, {split = "below", height = 9}) -- TODO: set initial bufpos here
        -- window specific options
        vim.api.nvim_set_option_value("relativenumber", false, {win = M.win})
        vim.api.nvim_set_option_value("signcolumn", "no", {win = M.win})
        vim.api.nvim_set_option_value("cursorline", true, {win = M.win})
        vim.cmd("wincmd h") -- TODO: unfuck this
    end
end

-- receives a list(table?) of strings
-- sets the message to be displayed
function M.display(lines)
    vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, lines)
end

function M.is_focused()
    return vim.api.nvim_get_current_win() == M.win
end

-- is open if window object exists and the window is valid
function M.is_open()
    return (M.win ~= nil and vim.api.nvim_win_is_valid(M.win))
end

function M.close()
    if M.is_open()
    then
        vim.cmd("NvimTreeClose")
        vim.api.nvim_win_close(M.win, false)
        M.win = nil
    end
end

function M.toggle()
    if M.is_open()
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
    if not M.is_focused()
    then
        vim.api.nvim_set_current_win(M.win)
    end
end

-- assumes open
function M.unfocus()
    if M.is_focused()
    then
        vim.cmd("wincmd h") -- TODO: unfuck this
    end
end

function M.focus_toggle()
    if M.is_open()
    then
        if M.is_focused()
        then
            M.unfocus()
        else
            M.focus()
        end
    end
end

function M.select(number)
    M.focus()
    vim.api.nvim_win_set_cursor(M.win, { number, 0 })
    M.unfocus()
end

return M

