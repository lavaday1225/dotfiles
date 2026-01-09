return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = { ensure_installed = { "go", "gomod", "gowork", "gosum" } },
  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      auto_install = true,
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
