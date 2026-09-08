-- load defaults from NvChad
require("nvchad.configs.lspconfig").defaults()

local nvlsp = require "nvchad.configs.lspconfig"

-- === SERVIDORES LSP (adicione aqui os que você usa) ===
local servers = {
  "html",
  "cssls",
  "tailwindcss",
  "rust_analyzer",   -- seu principal
  -- "vtsls",        -- se estiver usando Vue/TS
  -- "lua_ls",
}

-- Configuração nova recomendada (Neovim 0.11+)
for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
  vim.lsp.enable(server)
end

-- === CONFIGURAÇÃO ESPECÍFICA DO RUST-ANALYZER (mantida e atualizada) ===
vim.lsp.config("rust_analyzer", {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    ["rust-analyzer"] = {
      check = {
        allFeatures = true,
        command = "clippy",
      },
      checkOnSave = true,
      procMacro = {
        enable = true,
        ignored = {
          leptos_macro = { "server" },
        },
      },
      cargo = {
        allFeatures = true,
        autoreload = true,
      },
      rustfmt = {
        overrideCommand = { "leptosfmt", "--stdin", "--rustfmt" },
      },
      inlayHints = {
        enable = true,
        typeHints = { enable = true },
        parameterHints = { enable = true },
        closureReturnTypeHints = { enable = "always" },
      },
    },
  },
})

-- Força cores fortes no hover
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e222a", fg = "#c8d3f5" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#89b4fa", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "FloatTitle",  { fg = "#bb9af7", bg = "#1e222a", bold = true })
