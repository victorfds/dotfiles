-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")

-- EXAMPLE
local servers = { "html", "cssls", "oxlint", "tailwindcss" }
local nvlsp = require("nvchad.configs.lspconfig")

-- lsps with default config
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = nvlsp.on_attach,
		on_init = nvlsp.on_init,
		capabilities = nvlsp.capabilities,
	})
end

-- Custom on_attach to enable inlay hints
local on_attach = function(client, bufnr)
	nvlsp.on_attach(client, bufnr) -- Keep NvChad's default on_attach
	-- Enable inlay hints if the LSP server supports it
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

-- Rust Analyzer with corrected checkOnSave
lspconfig.rust_analyzer.setup({
	on_attach = on_attach,
	on_init = nvlsp.on_init,
	capabilities = nvlsp.capabilities,
	settings = {
		["rust-analyzer"] = {
			check = {
				allFeatures = true,
				command = "clippy",
			},
			checkOnSave = true, -- Set as boolean to enable checking on save
			procMacro = {
				enable = true,
				ignored = {
					["leptos-macro"] = { "server" },
				},
			},
			cargo = {
				allFeatures = true,
				autoreload = true,
			},
			rustfmt = {
				overrideCommand = { "leptosfmt", "--stdin", "--rustfmt" },
			},
			callInfo = {
				full = true,
			},
			lens = {
				enable = true,
				references = true,
				implementations = true,
				enumVariantReferences = true,
				methodReferences = true,
			},
			inlayHints = {
				enable = true,
				typeHints = {
					enable = true,
				},
				parameterHints = {
					enable = true,
				},
				bindingModeHints = {
					enable = true,
				},
				closureReturnTypeHints = {
					enable = "always",
				},
				lifetimeElisionHints = {
					enable = "skip_trivial",
				},
			},
			hoverActions = {
				enable = true,
			},
		},
	},
})

local mason_registry = require("mason-registry")

-- Get the installation path for Vue Language Server
local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
	.. "/node_modules/@vue/language-server"

local typescript_server_path = mason_registry.get_package("typescript-language-server"):get_install_path()
	.. "/node_modules/typescript/lib"

-- Tailwind CSS LSP setup
lspconfig.tailwindcss.setup({
	on_attach = on_attach,
	on_init = nvlsp.on_init,
	capabilities = nvlsp.capabilities,
	filetypes = { "rust", "html", "css", "javascript", "typescript", "vue" },
	root_dir = lspconfig.util.root_pattern(
		"tailwind.config.js",
		"tailwind.config.cjs",
		"package.json",
		"index.css",
		"globals.css",
		"input.css"
	),
	settings = {
		tailwindCSS = {
			experimental = {
				classRegex = {
					[[class="([^"]*)"]], -- Match class="..."
					[[class\s*=\s*"([^"]*)"]], -- Match class = "..."
				},
			},
			includeLanguages = {
				rust = "html",
			},
			emmetCompletions = true, -- Enable Emmet-like completions
		},
	},
	env = {
		NODE_OPTIONS = "--max-old-space-size=4096",
	},
})

-- TypeScript Language Server with Vue plugin
lspconfig.ts_ls.setup({
	init_options = {
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = vue_language_server_path,
				languages = { "javascript", "typescript" },
			},
		},
	},
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
	on_attach = on_attach,
	on_init = nvlsp.on_init,
	capabilities = nvlsp.capabilities,
	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = false,
				includeInlayVariableTypeHintsWhenTypeMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
			format = {
				printWidth = 80,
			},
		},
	},
})

-- Volar for Vue
lspconfig.volar.setup({
	filetypes = { "vue" },
	init_options = {
		typescript = {
			tsdk = typescript_server_path,
		},
		vue = {
			hybridMode = false,
		},
		documentFeatures = {
			documentFormatting = {
				defaultPrintWidth = 100,
			},
		},
	},
	settings = {
		typescript = {
			inlayHints = {
				enumMemberValues = {
					enabled = true,
				},
				functionLikeReturnTypes = {
					enabled = true,
				},
				propertyDeclarationTypes = {
					enabled = true,
				},
				parameterTypes = {
					enabled = true,
					suppressWhenArgumentMatchesName = true,
				},
				variableTypes = {
					enabled = false,
				},
			},
		},
	},
	on_attach = on_attach,
	on_init = nvlsp.on_init,
	capabilities = nvlsp.capabilities,
})
