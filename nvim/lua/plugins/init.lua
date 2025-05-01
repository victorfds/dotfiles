return {
	{
		"stevearc/conform.nvim",
		-- event = 'BufWritePre', -- uncomment for format on save
		opts = require("configs.conform"),
	},

	-- These are some examples, uncomment them if you want to see them work!
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"vim",
				"lua",
				"vimdoc",
				"html",
				"css",
				"rust",
				"toml",
				"vue",
			},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		},
	},

	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
		lazy = false,
		dependencies = {
			"nvim-telescope/telescope.nvim",
			-- "ibhagwan/fzf-lua",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			-- configuration goes here
			lang = "rust",
		},
		hooks = {
			-- -@type fun(question: lc.ui.Question)[]
			["question_enter"] = {
				function()
					-- os.execute "sleep 1"
					local file_extension = vim.fn.expand("%:e")
					if file_extension == "rs" then
						local bash_script = tostring(vim.fn.stdpath("data") .. "/leetcode/rust_init.sh")
						local success, error_message = os.execute(bash_script)
						if success then
							print("Successfully updated rust-project.json")
							vim.cmd("LspRestart rust_analyzer")
						else
							print("Failed update rust-project.json. Error: " .. error_message)
						end
					end
				end,
			},
			-- -@type fun(question: lc.ui.Question)[]
			--   ["question_enter"] = {
			--     function()
			--       local file_extension = vim.fn.expand "%:e"
			--       if file_extension == "rs" then
			--         local target_dir = vim.fn.stdpath "data" .. "/leetcode"
			--         local output_file = target_dir .. "/rust-project.json"
			--
			--         if vim.fn.isdirectory(target_dir) == 1 then
			--           local crates = ""
			--           local next = ""
			--
			--           local rs_files = vim.fn.globpath(target_dir, "*.rs", false, true)
			--           for _, f in ipairs(rs_files) do
			--             local file_path = f
			--             crates = crates .. next .. '{"root_module": "' .. file_path .. '","edition": "2021","deps": []}'
			--             next = ","
			--           end
			--
			--           if crates == "" then
			--             print("No .rs files found in directory: " .. target_dir)
			--             return
			--           end
			--
			--           local sysroot_src = vim.fn.system("rustc --print sysroot"):gsub("\n", "")
			--             .. "/lib/rustlib/src/rust/library"
			--
			--           local json_content = '{"sysroot_src": "' .. sysroot_src .. '", "crates": [' .. crates .. "]}"
			--
			--           local file = io.open(output_file, "w")
			--           if file then
			--             file:write(json_content)
			--             file:close()
			--
			--             local clients = vim.lsp.get_clients()
			--             local rust_analyzer_attached = false
			--             for _, client in ipairs(clients) do
			--               if client.name == "rust_analyzer" then
			--                 rust_analyzer_attached = true
			--                 break
			--               end
			--             end
			--
			--             if rust_analyzer_attached then
			--               vim.cmd "LspRestart rust_analyzer"
			--             end
			--           else
			--             print("Failed to open file: " .. output_file)
			--           end
			--         else
			--           print("Directory " .. target_dir .. " does not exist.")
			--         end
			--       end
			--     end,
			--   },
		},
	},
	-- {
	--   "mrcjkb/rustaceanvim",
	--   version = "^6", -- Recommended
	--   lazy = false, -- This plugin is already lazy
	-- },
	{
		"nvim-pack/nvim-spectre",
		event = "BufRead",
		config = function()
			require("spectre").setup()
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
			"Gedit",
		},
		ft = { "fugitive" },
	},
	{
		"j-hui/fidget.nvim",
		opts = {
			-- options
		},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},

	-- {
	--   "windwp/nvim-ts-autotag",
	--   event = { "BufReadPre", "BufNewFile" },
	--   opts = {
	--     opts = {
	--       enable = true,
	--       enable_rename = true, -- Auto-rename closing tag when editing opening tag
	--       enable_close = true, -- Auto-close tags on >
	--       enable_close_on_slash = true, -- Auto-close on typing </
	--       filetypes = { "html", "vue", "rust" },
	--     },
	--   },
	-- },
	{
		"rayliwell/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	{
		"rayliwell/tree-sitter-rstml",
		dependencies = { "nvim-treesitter" },
		build = ":TSUpdate",
		config = function()
			require("tree-sitter-rstml").setup()
		end,
	},

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},

	{
		"sindrets/diffview.nvim",
		event = "BufRead",
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>lx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>lX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>lL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>lQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	{ "danilamihailov/beacon.nvim" }, -- lazy calls setup() by itself
}
