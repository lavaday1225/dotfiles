local opt = vim.opt

-- 新しい行を改行で追加した時に、ひとつ上の行のインデントを引き継がせます。
opt.autoindent = true
opt.smartindent = true
-- smartindent と cindent を両方 true にしたときは、cindent のみ true になるようです。
-- opt.cindent = true
-- カーソルが存在する行にハイライトを当ててくれます。
opt.cursorline = true

-- カーソルが存在する列にハイライトを当てたい場合、下記をtrueにする。
-- opt.cursorculumn = true

-- TABキーを押した時に、2文字分の幅を持ったTABが表示されます。
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
-- tabstop で設定した数の分の半角スペースが入力されます。
opt.expandtab = true
-- カーソル行からの相対的な行番号を表示する
opt.number = true
opt.termguicolors = true

vim.g.mapleader = "<Space>"
vim.loader.enable()

-- lazyvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

