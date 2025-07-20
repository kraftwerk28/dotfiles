local function start_server()
  local matching = {}
  for name, client in pairs(require("lspconfig.configs")) do
    for _, ft in ipairs(client.filetypes) do
      if ft == vim.bo.filetype then
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
    prompt = "Start LSP server",
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
    prompt = "Stop LSP server",
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

-- function _G.restart_server(name)
--   local function do_restart(client)
--     if not client then
--       return
--     end
--     if vim.lsp.config[client.name] == nil then
--       vim.notify(
--         string.format("Invalid name %s", client.name),
--         vim.log.levels.ERROR
--       )
--       return
--     end
--     client:stop()
--     vim.wait(10000, function()
--       return client:is_stopped()
--     end, 100)
--     vim.lsp.config[client.name].launch()
--   end
--
--   local clients = vim.lsp.get_clients()
--   if type(name) == "string" then
--     for _, c in ipairs(clients) do
--       if c.name == name then
--         do_restart(c)
--         return
--       end
--     end
--     vim.notify(("No such client: '%s'"):format(name), vim.log.levels.ERROR)
--   else
--     vim.ui.select(clients, {
--       prompt = "Select LSP Server to restart",
--       format_item = function(client)
--         return client.name
--       end,
--     }, do_restart)
--   end
-- end

-- vim.api.nvim_create_user_command("LspRestart", function()
--   print("Restarting server")
--   restart_server()
-- end, {})

-- local actions = {
--   start = start_server,
--   stop = stop_server,
--   restart = restart_server,
-- }
-- vim.api.nvim_create_user_command("Lsp", function(arg)
--   local f = actions[arg.args]
--   if f ~= nil then
--     f()
--   end
-- end, {
--   nargs = 1,
--   complete = function()
--     return vim.tbl_keys(actions)
--   end,
-- })

-- vim.keymap.set("n", "<Leader>lsta", start_server)
-- vim.keymap.set("n", "<Leader>lsto", stop_server)
-- vim.keymap.set("n", "<Leader>lr", restart_server)
