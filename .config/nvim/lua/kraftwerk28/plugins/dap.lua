local dap = require("dap")

dap.adapters.python = {
  type = "executable",
  command = "python",
  args = { "-m", "debugpy.adapter" },
}

dap.adapters.delve = {
  type = "server",
  port = "${port}",
  executable = {
    command = "dlv",
    args = { "dap", "-l", "127.0.0.1:${port}" },
  },
}

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      return "/usr/bin/python"
    end,
  },
}

dap.configurations.go = {
  {
    type = "delve",
    name = "Debug",
    request = "launch",
    program = "${file}",
  },
  {
    type = "delve",
    name = "Debug test", -- configuration for debugging test files
    request = "launch",
    mode = "test",
    program = "${file}",
  },
  -- works with go.mod packages and sub packages
  {
    type = "delve",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
  },
}

m("n", "<Leader>dt", dap.toggle_breakpoint)
m("n", "<Leader>dc", dap.continue)
m("n", "<Leader>dn", dap.step_over)
m("n", "<Leader>di", dap.step_into)
m("n", "<Leader>do", dap.step_out)
m("n", "<Leader>dr", dap.repl.open)

-- `DapBreakpoint` for breakpoints (default: `B`)
-- `DapBreakpointCondition` for conditional breakpoints (default: `C`)
-- `DapLogPoint` for log points (default: `L`)
-- `DapStopped` to indicate where the debugee is stopped (default: `→`)
-- `DapBreakpointRejected` to indicate breakpoints rejected by the debug adapter (default: `R`)

vim.fn.sign_define({
  { name = "DapBreakpoint", text = "", texthl = "Error" },
  { name = "DapBreakpointCondition", text = "", texthl = "Boolean" },
  { name = "DapStopped", text = "", texthl = "Define" },
})
