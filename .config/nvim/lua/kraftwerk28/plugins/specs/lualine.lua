local char_under_cursor = {
  function()
    return "0x%02.B"
  end,
}

local lsp_status = {
  function()
    if vim.tbl_isempty(vim.lsp.get_clients()) then
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
      vim.cmd "LspInfo"
    end
  end,
}

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "arkav/lualine-lsp-progress",
  },
  opts = {
    options = {
      -- component_separators = { left = "", right = "" },
      -- section_separators = { left = "", right = "" },
      component_separators = { left = "┃", right = "┃" },
      section_separators = { left = "▌", right = "▐" },
      -- component_separators = { left = "", right = "" },
      -- section_separators = { left = "", right = "" },
      -- theme = "gruvbox",
      always_show_tabline = false,
    },

    sections = {
      lualine_a = {
        "mode",
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
          symbols = { dos = " ", mac = " ", unix = "󰣇 " },
          separator = "",
        },
        { "encoding", separator = "" },
        { "filetype", icon_only = true, separator = "" },
      },
      lualine_c = {
        {
          "filename",
          -- 0: Just the filename
          -- 1: Relative path
          -- 2: Absolute path
          -- 3: Absolute path, with tilde as the home directory
          -- 4: Filename and parent dir, with tilde as the home directory
          path = 1,
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
          spinner_symbols = vim.g.spinner.frames,
        },
      },
      lualine_y = { char_under_cursor },
      lualine_z = {
        function()
          return string.format(
            "%3d/%-3d:%-3d",
            vim.fn.line("."),
            vim.fn.line("$"),
            vim.fn.col(".")
          )
        end,
      },
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

    tabline = {
      lualine_a = {
        {
          "tabs",
          max_length = function()
            return vim.o.columns
          end,
          mode = 1,
          path = 1,
          use_mode_colors = true,
          symbols = {
            modified = "•",
          },
        },
      },
    },
  },
}
