local function start_server()
  local matching = {}
  for name, client in pairs(require("lspconfig.configs")) do
    for _, ft in ipairs(client.filetypes) do
      if ft == vim.opt_local.filetype:get() then
        table.insert(matching, name)
        break
      end
    end
  end
  if #matching == 0 then
    print("No matching clients for this filetype")
    return
  end
  vim.ui.select(matching, {
    prompt_title = "Start LSP server",
  }, function(name)
    if name == nil then
      return
    end
    require("lspconfig.configs")[name].launch()
  end)
end

local function stop_server()
  local clients = vim.lsp.get_active_clients()
  vim.ui.select(clients, {
    prompt = "Restart LSP server",
    format_item = function(c)
      return ("%s %s"):format(c.name, c.config.root_dir)
    end,
  }, function(client)
    if client == nil then
      return
    end
    client:stop()
  end)
end

local function restart_server()
  local clients = vim.lsp.get_active_clients()
  vim.ui.select(clients, {
    prompt = "Restart LSP server",
    format_item = function(c)
      return ("%s %s"):format(c.name, c.config.root_dir)
    end,
  }, function(client)
    if client == nil then
      return
    end
    local configs = require("lspconfig.configs")
    local client_conf = configs[client.name]
    if client_conf == nil then
      print(client.name .. " doesn't support restarting.")
      return
    end
    client:stop()
    vim.defer_fn(function()
      client_conf.launch()
    end, 500)
  end)
end

m("n", "<Leader>lsta", start_server)
m("n", "<Leader>lsto", stop_server)
m("n", "<Leader>lr", restart_server)
