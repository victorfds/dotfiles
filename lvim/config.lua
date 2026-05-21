-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- Compatibility shims for running LunarVim 1.4-era plugins on Neovim 0.12+.
if vim.fn.has("nvim-0.12") == 1 then
  local suppressed_deprecations = {
    ["client.request"] = true,
    ["client.supports_method"] = true,
    ["vim.validate{<table>}"] = true,
    ["vim.lsp.for_each_buffer_client()"] = true,
    ["vim.lsp.start_client()"] = true,
  }
  local original_deprecate = vim.deprecate
  vim.deprecate = function(name, alternative, version, plugin, backtrace)
    if suppressed_deprecations[name] then
      return
    end

    return original_deprecate(name, alternative, version, plugin, backtrace)
  end

  if vim.islist ~= nil then
    vim.tbl_islist = vim.islist
  end

  vim.lsp.with = function(handler, override_config)
    return function(err, result, ctx, config)
      return handler(err, result, ctx, vim.tbl_deep_extend("force", config or {}, override_config))
    end
  end

  vim.tbl_flatten = function(tbl)
    local result = {}

    local function flatten(value)
      for index = 1, #value do
        local item = value[index]
        if type(item) == "table" then
          flatten(item)
        elseif item then
          table.insert(result, item)
        end
      end
    end

    flatten(tbl)
    return result
  end

  vim.tbl_add_reverse_lookup = function(tbl)
    for key, value in pairs(tbl) do
      tbl[value] = key
    end

    return tbl
  end

  if vim.diagnostic.is_disabled == nil and vim.diagnostic.is_enabled ~= nil then
    vim.diagnostic.is_disabled = function(bufnr, namespace)
      return not vim.diagnostic.is_enabled({ bufnr = bufnr, ns_id = namespace })
    end
  end

  if vim.diagnostic.disable == nil and vim.diagnostic.enable ~= nil then
    vim.diagnostic.disable = function(bufnr, namespace)
      vim.diagnostic.enable(false, { bufnr = bufnr, ns_id = namespace })
    end
  end
end

vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    require("nvim-treesitter.parsers").rust_with_rstml = {
      install_info = {
        url = "https://github.com/rayliwell/tree-sitter-rstml",
        branch = "main",
        files = { "src/parser.c", "src/scanner.c" },
        location = "rust_with_rstml",
      },
    }
  end,
})
vim.treesitter.language.register("rust_with_rstml", { "rust" })

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "css",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "query",
  "rust",
  "rust_with_rstml",
  "scss",
  "tsx",
  "toml",
  "typescript",
  "vimdoc",
  "vue",
}
-- Let LunarVim initialize Mason, and only provide the servers we want installed.
lvim.lsp.installer.setup.ensure_installed = {
  "rust_analyzer",
  "ts_ls",
  "vue_ls",
}

lvim.lsp.installer.setup.automatic_installation = {
  exclude = {},
}

local function get_mason_package_install_path(package_name)
  local package_path = vim.fn.stdpath("data") .. "/mason/packages/" .. package_name
  if vim.fn.isdirectory(package_path) == 0 then
    return nil
  end

  return package_path
end

local lspconfig_runtime_path = vim.env.LUNARVIM_RUNTIME_DIR .. "/site/pack/lazy/opt/nvim-lspconfig"
if vim.fn.isdirectory(lspconfig_runtime_path) == 1 then
  vim.opt.rtp:prepend(lspconfig_runtime_path)
end

local function mason_bin_path(binary_name)
  local path = vim.fn.stdpath("data") .. "/mason/bin/" .. binary_name
  if vim.fn.executable(path) == 1 then
    return path
  end

  return binary_name
end

local tsserver_init_options = {}
local vue_language_server_install_path = get_mason_package_install_path("vue-language-server")

if vue_language_server_install_path ~= nil then
  tsserver_init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vue_language_server_install_path .. "/node_modules/@vue/language-server",
        languages = { "vue" },
      },
    },
  }
end

vim.lsp.config("ts_ls", {
  cmd = { mason_bin_path("typescript-language-server"), "--stdio" },
  init_options = tsserver_init_options,
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})
vim.lsp.enable("ts_ls")

-- No need to set `hybridMode` to `true` as it's the default value.
vim.lsp.config("vue_ls", {
  cmd = { mason_bin_path("vue-language-server"), "--stdio" },
  filetypes = { "vue" },
})
vim.lsp.enable("vue_ls")

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
  "rust_analyzer",
  "ts_ls",
  "tsserver",
  "vue_ls",
  "volar",
})

local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")

local codelldb_path = mason_path .. "bin/codelldb"
local this_os = vim.uv.os_uname().sysname

-- The path in windows is different
if this_os:find "Windows" then
  codelldb_path = mason_path .. "packages\\codelldb\\extension\\adapter\\codelldb.exe"
end

local rust_settings = {
  ["rust-analyzer"] = {
    lens = {
      enable = true,
      references = true,
      implementations = true,
      enumVariantReferences = true,
      methodReferences = true,
    },
    checkOnSave = {
      allFeatures = true,
      enable = true,
      command = "clippy",
    },
    procMacro = {
      enable = true,
      ignored = {
        leptosMacro = {
          "server",
        },
      },
    },
    cargo = {
      allFeatures = true,
      autoreload = true,
    },
    rustfmt = {
      overrideCommand = { "leptosfmt", "--stdin", "--rustfmt" },
    },
    callInfo = { full = true },
    inlayHints = { enable = true, typeHints = true, parameterHints = true },
  },
}

vim.lsp.config("rust_analyzer", {
  cmd = { mason_bin_path("rust-analyzer") },
  on_attach = function(client, bufnr)
    require("lvim.lsp").common_on_attach(client, bufnr)
    vim.keymap.set("n", "K", function()
      if #vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/hover" }) > 0 then
        vim.lsp.buf.hover()
      end
    end, { buffer = bufnr, desc = "LSP hover" })
  end,
  capabilities = require("lvim.lsp").common_capabilities(),
  settings = rust_settings,
})
vim.lsp.enable("rust_analyzer")

lvim.builtin.dap.on_config_done = function(dap)
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = codelldb_path,
      args = { "--port", "${port}" },
    },
  }
  dap.configurations.rust = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
  }
end

vim.keymap.set("n", "<m-d>", vim.lsp.buf.hover, { desc = "LSP hover" })

lvim.builtin.which_key.mappings["C"] = {
  name = "Rust",
  t = { "<cmd>lua _CARGO_TEST()<cr>", "Cargo Test" },
  a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
  h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
  y = { "<cmd>lua require'crates'.open_repository()<cr>", "[crates] open repository" },
  P = { "<cmd>lua require'crates'.show_popup()<cr>", "[crates] show popup" },
  i = { "<cmd>lua require'crates'.show_crate_popup()<cr>", "[crates] show info" },
  f = { "<cmd>lua require'crates'.show_features_popup()<cr>", "[crates] show features" },
  D = { "<cmd>lua require'crates'.show_dependencies_popup()<cr>", "[crates] show dependencies" },
}
local leet_arg = "leetcode.nvim"
lvim.plugins = {
  {
    "echasnovski/mini.icons",
    version = false,
    config = function()
      require("mini.icons").setup()
    end,
  },
  {
    "saecki/crates.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup {
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
        popup = {
          border = "rounded",
        },
      }
    end,
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({
        -- Options related to integrating with other plugins
        integration = {
          ["nvim-tree"] = {
            enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
          },
        },
      })
    end,
  },
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit"
    },
    ft = { "fugitive" }
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
  },
  {
    "rayliwell/tree-sitter-rstml",
    dependencies = { "nvim-treesitter" },
    build = ":TSUpdate",
    config = function()
      require("tree-sitter-rstml").setup()
    end
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  { "nvim-tree/nvim-web-devicons", opts = {} },
  
}
