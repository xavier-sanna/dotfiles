return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      php = { "phpmd", "phpstan", "phpcs" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })

    local wk = require("which-key")

    wk.register({
      ["<leader>l"] = {
        name = "linting",
      },
    })

    local phpcs = require("lint").linters.phpcs
    phpcs.args = {
      "-q",
      "--standard=ruleset.xml",
      "--report=json",
      "-", -- need `-` at the end for stdin support
    }
    -- local phpmd = require("lint").linters.phpmd
    -- phpmd.args = {
    --   "-q",
    --   -- <- Add a new parameter here
    --   "--report=json",
    --   "-",
    -- }
  end,
}
