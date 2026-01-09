return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.completion.spell,
      },
    })

    -- Use vim.lsp.buf.format for Neovim 0.8+ or vim.lsp.buf.formatting for older versions
    vim.keymap.set("n", "<space>gf", function()
      vim.lsp.buf.format({ async = true })
    end, {})
  end,
}
