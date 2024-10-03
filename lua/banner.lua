local M = {}

local logo = {
    " =================     ===============     ===============   ========  ========",
    " \\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //",
    " ||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\\/ . . .||",
    " || . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||",
    " ||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||",
    " || . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\\ . . . . ||",
    " ||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\\_ . .|. .||",
    " || . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\\ `-_/| . ||",
    " ||_-' ||  .|/    || ||    \\|.  || `-_|| ||_-' ||  .|/    || ||   | \\  / |-_.||",
    " ||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \\  / |  `||",
    " ||    `'         || ||         `'    || ||    `'         || ||   | \\  / |   ||",
    " ||            .===' `===.         .==='.`===.         .===' /==. |  \\/  |   ||",
    " ||         .=='   \\_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \\/  |   ||",
    " ||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \\/  |   ||",
    " ||   .=='    _-'          '-__\\._-'         '-_./__-'         `' |. /|  |   ||",
    " ||.=='    _-'                                                     `' |  /==.||",
    " =='    _-'                        N E O V I M                         \\/   `==",
    " \\   _-'                                                                `-_   /",
    "  `''                                                                      ``'",
}

local neovim = {
    "  ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓",
    "  ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒",
    " ▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░",
    " ▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██ ",
    " ▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒",
    " ░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░",
    " ░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░",
    "    ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░   ",
    "          ░    ░  ░    ░ ░        ░   ░         ░   ",
    "                                 ░                  ",
}

local function set_default_config()
    vim.opt_local.bufhidden = "wipe"
    vim.opt_local.buflisted = false
    vim.opt_local.matchpairs = ""
    vim.opt_local.swapfile = false
    vim.opt_local.buftype = "nofile"
    vim.opt_local.filetype = "banner"
    vim.opt_local.synmaxcol = 0
    vim.opt_local.wrap = false
    vim.opt_local.colorcolumn = ""
    vim.opt_local.foldlevel = 999
    vim.opt_local.foldcolumn = "0"
    vim.opt_local.cursorcolumn = false
    vim.opt_local.cursorline = false
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.list = false
    vim.opt_local.spell = false
    vim.opt_local.signcolumn = "no"
end

local function should_skip_banner()
    -- don't start when opening a file
    if vim.fn.argc() > 0 then
        return true
    end

    -- Do not open alpha if the current buffer has any lines (something opened explicitly).
    local lines = vim.api.nvim_buf_get_lines(0, 0, 2, false)
    if #lines > 1 or (#lines == 1 and lines[1]:len() > 0) then
        return true
    end

    -- Skip when there are several listed buffers.
    for _, buf_id in pairs(vim.api.nvim_list_bufs()) do
        local bufinfo = vim.fn.getbufinfo(buf_id)
        if bufinfo.listed == 1 and #bufinfo.windows > 0 then
            return true
        end
    end
end

local function banner(on_vimenter)
    local buffer
    if on_vimenter then
        if should_skip_banner() then
            return
        end
        buffer = vim.api.nvim_get_current_buf()
    else
        if vim.bo.ft ~= "banner" then
            buffer = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_win_set_buf(0, buffer)
        else
            ---@diagnostic disable-next-line: param-type-mismatch
            if not pcall(vim.cmd, "e #") then
                buffer = vim.api.nvim_get_current_buf()
                vim.api.nvim_buf_delete(buffer, {})
            end
            return
        end
    end

    set_default_config()

    local width = vim.api.nvim_win_get_width(0)
    local height = vim.api.nvim_win_get_height(0)

    vim.api.nvim_buf_set_option(buffer, "modifiable", true)
    vim.api.nvim_buf_clear_namespace(buffer, -1, 0, -1)
    local text = {}
    -- padding up
    for _ = 0, height / 2 - (#neovim / 2) - (#logo / 2) do
        vim.list_extend(text, { "" })
    end
    -- padding left of logo
    for _, value in ipairs(logo) do
        local offset_width = string.len(logo[1]) / 2
        local line = string.rep(" ", width / 2 - offset_width) .. value
        vim.list_extend(text, { line })
    end
    -- padding left of banner text
    for _, value in ipairs(neovim) do
        local offset_width = string.len(neovim[1])
        local line = string.rep(" ", width / 2 - 24) .. value
        vim.list_extend(text, { line })
    end
    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, text)
    vim.api.nvim_buf_set_option(buffer, "modifiable", false)
end

M.setup = function()
    vim.api.nvim_create_user_command("Banner", function()
        package.loaded.main = nil
        banner()
    end, {})

    vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        callback = function()
            banner(true)
        end,
    })
end

return M
