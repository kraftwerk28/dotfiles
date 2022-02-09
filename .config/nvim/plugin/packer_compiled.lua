-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/kraftwerk28/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/kraftwerk28/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/kraftwerk28/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/kraftwerk28/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/kraftwerk28/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  Colorizer = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/Colorizer",
    url = "https://github.com/chrisbra/Colorizer"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-calc"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/cmp-calc",
    url = "https://github.com/hrsh7th/cmp-calc"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-snippy"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/cmp-snippy",
    url = "https://github.com/dcampos/cmp-snippy"
  },
  ["editorconfig-vim"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/editorconfig-vim",
    url = "https://github.com/editorconfig/editorconfig-vim"
  },
  ["emmet-vim"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/emmet-vim",
    url = "https://github.com/mattn/emmet-vim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\nM\0\0\4\0\5\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\2B\0\2\1K\0\1\0\fkeymaps\1\0\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["gtranslate.nvim"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/gtranslate.nvim",
    url = "/home/kraftwerk28/projects/neovim/gtranslate.nvim"
  },
  ["haskell-vim"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/haskell-vim",
    url = "https://github.com/neovimhaskell/haskell-vim"
  },
  kommentary = {
    config = { "\27LJ\2\n|\0\0\4\0\5\0\b6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0005\3\4\0B\0\3\1K\0\1\0\1\0\1 prefer_single_line_comments\2\fdefault\23configure_language\22kommentary.config\frequire\0" },
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/kommentary",
    url = "https://github.com/b3nj5m1n/kommentary"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  neorg = {
    config = { "\27LJ\2\n�\1\0\0\a\0\14\0\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\f\0005\3\3\0004\4\0\0=\4\4\0034\4\0\0=\4\5\0035\4\t\0005\5\a\0005\6\6\0=\6\b\5=\5\n\4=\4\v\3=\3\r\2B\0\2\1K\0\1\0\tload\1\0\0\21core.norg.dirman\vconfig\1\0\0\15workspaces\1\0\0\1\0\1\17my_workspace\f~/notes\24core.norg.concealer\18core.defaults\1\0\0\nsetup\nneorg\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/opt/neorg",
    url = "https://github.com/nvim-neorg/neorg"
  },
  ["neovim-gui-shim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/opt/neovim-gui-shim",
    url = "https://github.com/equalsraf/neovim-gui-shim"
  },
  ["nginx.vim"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/nginx.vim",
    url = "https://github.com/chr4/nginx.vim"
  },
  ["null-ls.nvim"] = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20plugins.null_ls\frequire\0" },
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-base16"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/nvim-base16",
    url = "https://github.com/RRethy/nvim-base16"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16plugins.cmp\frequire\0" },
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\n3\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\24plugins.lsp_servers\frequire\0" },
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-snippy"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/nvim-snippy",
    url = "https://github.com/dcampos/nvim-snippy"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\n�\5\0\0\6\0\19\0#6\0\0\0'\2\1\0B\0\2\0029\1\2\0\18\2\1\0005\4\3\0B\2\2\1\18\2\1\0005\4\4\0B\2\2\0016\2\5\0009\2\6\2)\3\1\0=\3\a\0026\2\5\0009\2\6\2)\3\0\0=\3\b\0026\2\5\0009\2\6\0025\3\v\0005\4\n\0=\4\f\0035\4\r\0=\4\14\3=\3\t\0026\2\0\0'\4\15\0B\2\2\0029\2\16\0025\4\17\0005\5\18\0=\5\14\4B\2\2\1K\0\1\0\1\0\1\vignore\1\1\0\6\18disable_netrw\1\15auto_close\2\18hijack_cursor\2\16auto_resize\1\27highlight_opened_files\2\17hijack_netrw\2\nsetup\14nvim-tree\bgit\1\0\a\14untracked\b\fdeleted\b\frenamed\b➜\fignored\b\runmerged\b\vstaged\b✓\runstaged\b✗\vfolder\1\0\0\1\0\b\17arrow_closed\b\fsymlink\b\15arrow_open\b\15empty_open\b\nempty\b\fdefault\b\17symlink_open\b\topen\b\20nvim_tree_icons\29nvim_tree_indent_markers\27nvim_tree_quit_on_open\6g\bvim\1\3\0\0\23NvimTreeFolderIcon\nTitle\1\3\0\0\23NvimTreeFolderName\nTitle\14highlight\17config.utils\frequire\0" },
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    after = { "neorg" },
    loaded = true,
    only_config = true
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/opt/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["prolog.vim"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/prolog.vim",
    url = "https://github.com/adimit/prolog.vim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22plugins.telescope\frequire\0" },
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["vim-easy-align"] = {
    config = { "\27LJ\2\nb\0\0\6\0\6\0\t6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0004\5\0\0B\0\5\1K\0\1\0\22<Plug>(EasyAlign)\15<Leader>ea\6v\20nvim_set_keymap\bapi\bvim\0" },
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/vim-easy-align",
    url = "https://github.com/junegunn/vim-easy-align"
  },
  ["vim-elixir"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/vim-elixir",
    url = "https://github.com/elixir-editors/vim-elixir"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-jq"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/vim-jq",
    url = "https://github.com/bfrg/vim-jq"
  },
  ["vim-pug"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/vim-pug",
    url = "https://github.com/digitaltoad/vim-pug"
  },
  ["vim-snippets"] = {
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/vim-snippets",
    url = "https://github.com/honza/vim-snippets"
  },
  ["vim-surround"] = {
    config = { "\27LJ\2\n�\2\0\0\6\0\15\00016\0\0\0009\0\1\0009\0\2\0006\1\0\0009\1\3\1'\2\4\0\18\3\0\0'\5\5\0B\3\2\2&\2\3\2'\3\6\0<\3\2\0016\1\0\0009\1\3\1'\2\4\0\18\3\0\0'\5\a\0B\3\2\2&\2\3\2'\3\b\0<\3\2\0016\1\0\0009\1\3\1'\2\4\0\18\3\0\0'\5\t\0B\3\2\2&\2\3\2'\3\n\0<\3\2\0016\1\0\0009\1\3\1'\2\4\0\18\3\0\0'\5\v\0B\3\2\2&\2\3\2'\3\f\0<\3\2\0016\1\0\0009\1\3\1'\2\4\0\18\3\0\0'\5\r\0B\3\2\2&\2\3\2'\3\14\0<\3\2\1K\0\1\0\25\1before: \1\r\2after: \2\6i\n[[\r]]\6l\f/* \r */\6c\14{/* \r */}\6j\n{'\r'}\6r\14surround_\6g\fchar2nr\afn\bvim\0" },
    loaded = true,
    path = "/home/kraftwerk28/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\n�\5\0\0\6\0\19\0#6\0\0\0'\2\1\0B\0\2\0029\1\2\0\18\2\1\0005\4\3\0B\2\2\1\18\2\1\0005\4\4\0B\2\2\0016\2\5\0009\2\6\2)\3\1\0=\3\a\0026\2\5\0009\2\6\2)\3\0\0=\3\b\0026\2\5\0009\2\6\0025\3\v\0005\4\n\0=\4\f\0035\4\r\0=\4\14\3=\3\t\0026\2\0\0'\4\15\0B\2\2\0029\2\16\0025\4\17\0005\5\18\0=\5\14\4B\2\2\1K\0\1\0\1\0\1\vignore\1\1\0\6\18disable_netrw\1\15auto_close\2\18hijack_cursor\2\16auto_resize\1\27highlight_opened_files\2\17hijack_netrw\2\nsetup\14nvim-tree\bgit\1\0\a\14untracked\b\fdeleted\b\frenamed\b➜\fignored\b\runmerged\b\vstaged\b✓\runstaged\b✗\vfolder\1\0\0\1\0\b\17arrow_closed\b\fsymlink\b\15arrow_open\b\15empty_open\b\nempty\b\fdefault\b\17symlink_open\b\topen\b\20nvim_tree_icons\29nvim_tree_indent_markers\27nvim_tree_quit_on_open\6g\bvim\1\3\0\0\23NvimTreeFolderIcon\nTitle\1\3\0\0\23NvimTreeFolderName\nTitle\14highlight\17config.utils\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16plugins.cmp\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22plugins.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: kommentary
time([[Config for kommentary]], true)
try_loadstring("\27LJ\2\n|\0\0\4\0\5\0\b6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0005\3\4\0B\0\3\1K\0\1\0\1\0\1 prefer_single_line_comments\2\fdefault\23configure_language\22kommentary.config\frequire\0", "config", "kommentary")
time([[Config for kommentary]], false)
-- Config for: vim-surround
time([[Config for vim-surround]], true)
try_loadstring("\27LJ\2\n�\2\0\0\6\0\15\00016\0\0\0009\0\1\0009\0\2\0006\1\0\0009\1\3\1'\2\4\0\18\3\0\0'\5\5\0B\3\2\2&\2\3\2'\3\6\0<\3\2\0016\1\0\0009\1\3\1'\2\4\0\18\3\0\0'\5\a\0B\3\2\2&\2\3\2'\3\b\0<\3\2\0016\1\0\0009\1\3\1'\2\4\0\18\3\0\0'\5\t\0B\3\2\2&\2\3\2'\3\n\0<\3\2\0016\1\0\0009\1\3\1'\2\4\0\18\3\0\0'\5\v\0B\3\2\2&\2\3\2'\3\f\0<\3\2\0016\1\0\0009\1\3\1'\2\4\0\18\3\0\0'\5\r\0B\3\2\2&\2\3\2'\3\14\0<\3\2\1K\0\1\0\25\1before: \1\r\2after: \2\6i\n[[\r]]\6l\f/* \r */\6c\14{/* \r */}\6j\n{'\r'}\6r\14surround_\6g\fchar2nr\afn\bvim\0", "config", "vim-surround")
time([[Config for vim-surround]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\n3\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\24plugins.lsp_servers\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: vim-easy-align
time([[Config for vim-easy-align]], true)
try_loadstring("\27LJ\2\nb\0\0\6\0\6\0\t6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0004\5\0\0B\0\5\1K\0\1\0\22<Plug>(EasyAlign)\15<Leader>ea\6v\20nvim_set_keymap\bapi\bvim\0", "config", "vim-easy-align")
time([[Config for vim-easy-align]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n3\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\24plugins.tree_sitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: null-ls.nvim
time([[Config for null-ls.nvim]], true)
try_loadstring("\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20plugins.null_ls\frequire\0", "config", "null-ls.nvim")
time([[Config for null-ls.nvim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\nM\0\0\4\0\5\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\2B\0\2\1K\0\1\0\fkeymaps\1\0\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd neorg ]]

-- Config for: neorg
try_loadstring("\27LJ\2\n�\1\0\0\a\0\14\0\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\f\0005\3\3\0004\4\0\0=\4\4\0034\4\0\0=\4\5\0035\4\t\0005\5\a\0005\6\6\0=\6\b\5=\5\n\4=\4\v\3=\3\r\2B\0\2\1K\0\1\0\tload\1\0\0\21core.norg.dirman\vconfig\1\0\0\15workspaces\1\0\0\1\0\1\17my_workspace\f~/notes\24core.norg.concealer\18core.defaults\1\0\0\nsetup\nneorg\frequire\0", "config", "neorg")

time([[Sequenced loading]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
