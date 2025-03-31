return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
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
      },
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
          local file_extension = vim.fn.expand "%:e"
          if file_extension == "rs" then
            local bash_script = tostring(vim.fn.stdpath "data" .. "/leetcode/rust_init.sh")
            local success, error_message = os.execute(bash_script)
            if success then
              print "Successfully updated rust-project.json"
              vim.cmd "LspRestart rust_analyzer"
            else
              print("Failed update rust-project.json. Error: " .. error_message)
            end
          end
        end,
      },
      -- ["question_enter"] = {
      --   function()
      --     local file_extension = vim.fn.expand "%:e"
      --     if file_extension == "rs" then
      --       local target_dir = vim.fn.stdpath "data" .. "/leetcode"
      --       local output_file = target_dir .. "/rust-project.json"
      --
      --       if vim.fn.isdirectory(target_dir) == 1 then
      --         local crates = ""
      --         local next = ""
      --
      --         local rs_files = vim.fn.globpath(target_dir, "*.rs", false, true)
      --         for _, f in ipairs(rs_files) do
      --           local file_path = f
      --           crates = crates .. next .. '{"root_module": "' .. file_path .. '","edition": "2021","deps": []}'
      --           next = ","
      --         end
      --
      --         if crates == "" then
      --           print("No .rs files found in directory: " .. target_dir)
      --           return
      --         end
      --
      --         local sysroot_src = vim.fn.system("rustc --print sysroot"):gsub("\n", "")
      --           .. "/lib/rustlib/src/rust/library"
      --
      --         local json_content = '{"sysroot_src": "' .. sysroot_src .. '", "crates": [' .. crates .. "]}"
      --
      --         local file = io.open(output_file, "w")
      --         if file then
      --           file:write(json_content)
      --           file:close()
      --
      --           local clients = vim.lsp.get_clients()
      --           local rust_analyzer_attached = false
      --           for _, client in ipairs(clients) do
      --             if client.name == "rust_analyzer" then
      --               rust_analyzer_attached = true
      --               break
      --             end
      --           end
      --
      --           if rust_analyzer_attached then
      --             vim.cmd "LspRestart rust_analyzer"
      --           end
      --         else
      --           print("Failed to open file: " .. output_file)
      --         end
      --       else
      --         print("Directory " .. target_dir .. " does not exist.")
      --       end
      --     end
      --   end,
      -- },
    },
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
}
