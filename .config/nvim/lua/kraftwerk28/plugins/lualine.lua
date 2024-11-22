local char_under_cursor = {
  function()
    return "0x%02.B"
  end,
}

local lsp_status = {
  function()
    if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
      return "󰌙 "
    else
      return "󰌘 "
    end
  end,
  color = function()
    local hl_name
    if #vim.lsp.get_clients() > 0 then
      hl_name = "CmpItemKindSnippet"
    else
      hl_name = "Error"
    end
    local hl = vim.api.nvim_get_hl(0, { name = hl_name, link = false })
    return { fg = vim.fn.printf("%06x", hl.fg) }
  end,
  on_click = function(nclicks, btn)
    if nclicks == 1 and btn == "l" then
      vim.cmd("LspInfo")
    end
  end,
}

require("lualine").setup({
  options = {
    -- component_separators = { left = "", right = "" },
    -- section_separators = { left = "", right = "" },
    component_separators = { left = "┃", right = "┃" },
    section_separators = { left = "▌", right = "▐" },
    -- component_separators = { left = "", right = "" },
    -- section_separators = { left = "", right = "" },
    -- theme = "gruvbox",
  },

  sections = {
    lualine_a = {
      -- {
      --   "branch",
      --   on_click = function(nclicks, btn)
      --     if nclicks == 1 and btn == "l" then
      --       vim.cmd("vertical Git")
      --     end
      --   end,
      -- },
    },
    lualine_b = {
      {
        "fileformat",
        symbols = { dos = " ", mac = " ", unix = " " },
        separator = "",
      },
      { "encoding", separator = "" },
      { "filetype", icon_only = true, separator = "" },
    },
    lualine_c = {
      {
        "filename",
        path = 1, -- Relative
        symbols = {
          modified = "󰆔 ",
          readonly = " ",
        },
      },
    },

    lualine_x = {
      "diagnostics",
      lsp_status,
      {
        "lsp_progress",
        display_components = {
          "lsp_client_name",
          "spinner",
          { "title", "percentage", "message" },
        },
      },
    },
    lualine_y = { char_under_cursor, "progress", "%3.l/%-3.L:%2.c" },
    lualine_z = {},
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {
      { "filetype", icon_only = true, separator = "" },
    },
    lualine_c = {
      {
        "filename",
        path = 1, -- Relative
        symbols = {
          modified = "󰆔 ",
          readonly = " ",
        },
      },
    },

    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },

  -- tabline = {
  --   lualine_a = {
  --     {
  --       "tabs",
  --       mode = 1,
  --       symbols = {
  --         modified = " ",
  --       },
  --       separator = "/",
  --     },
  --   },
  -- },
})
