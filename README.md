# WHY

I wanted to have an always-open menu to show me, in order, my harpooned files


# HOW TO USE

Using lazy:
```lua
return {
    "IVSOP/sidebar-harpoon.nvim",
    dependencies = {
        "nvim-tree/nvim-tree.lua" -- since it opens nvim tree, depend on it
    },
    config = function()
        local sbh = require("sidebar-harpoon")

        -- ran only once, to internally create the buffer
        sbh.create()

        -- keybinds to toggle and focus the menu
        vim.keymap.set("n", "<leader>e", function() sbh.toggle() end)
        vim.keymap.set("n", "<leader>t", function() sbh.focus_toggle() end)
    end
}
```

Then, hijack harpoon's configuration. For example:

```lua
-- ..........
config = function()
    local harpoon = require("harpoon")

    harpoon:setup()

    -- set initial text
    display(harpoon:list())

    -- hijack keybinds. call wrappers
    vim.keymap.set("n", "<leader>a", add)
    vim.keymap.set("n", "<leader>r", remove)
    vim.keymap.set("n", "<leader>1", function() select(1) end)
    -- ...............
end
```

The functions `add`, `remove` and `select` should be defined (for example on the top of the file), like this:

```lua
-- refresh the text on the buffer, set it to the output of harpoon
local function display(list)
    local sbh = require("sidebar-harpoon")
    sbh.display(list:display())
end

-- all these next functions do is call the appropriate function from harpoon,
-- and then call display() to refresh the buffer
local function add()
    local harpoon = require("harpoon")
    local list = harpoon:list():add()
    display(list)
end

local function remove()
    local harpoon = require("harpoon")
    local list = harpoon:list():remove()
    display(list)
end

-- this one also calls select() to visually update what line is selected
local function select(number)
    local harpoon = require("harpoon")
    local list = harpoon:list()
    list:select(number)
    local sbh = require("sidebar-harpoon")
    sbh.select(number)
    display(list)
end
```
