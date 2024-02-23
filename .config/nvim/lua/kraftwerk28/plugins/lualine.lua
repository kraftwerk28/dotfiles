local char_under_cursor = {
  function()
    return "0x%02.B"
  end,
}

local lsp_status = {
  function()
    if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
      return " "
    else
      return " "
    end
  end,
  color = function()
    if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
      return { fg = "LightRed" }
    else
      return { fg = "LightGreen" }
    end
  end,
  on_click = function(nclicks, btn)
    if nclicks == 1 and btn == "l" then
      vim.cmd("LspInfo")
    end
  end,
}

require("lualine").setup({
  options = {
    component_separators = { left = "│", right = "│" },
    section_separators = { left = "▌", right = "▐" },
  },

  sections = {
    lualine_a = {},
    lualine_b = {
      {
        "branch",
        on_click = function(nclicks, btn)
          if nclicks == 1 and btn == "l" then
            vim.cmd("vertical Git")
          end
        end,
      },
      "diff",
      "diagnostics",
    },
    lualine_c = {
      { "filetype", icon_only = true },
      "filename",
      "fileformat",
      "encoding",
    },

    lualine_x = { lsp_status },
    lualine_y = { char_under_cursor, "progress", "location" },
    lualine_z = {},
  },
})
