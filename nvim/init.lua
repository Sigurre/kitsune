-- Basic Neovim setup for Kitsune
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Plugin manager (packer)
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'nvim-treesitter/nvim-treesitter'
  use 'nvim-telescope/telescope.nvim'
  use 'neovim/nvim-lspconfig'
end)

-- Ranger integration
vim.api.nvim_create_user_command("RangerReveal", function()
  local file = vim.fn.expand("%:p")
  vim.fn.system({"nvim-to-ranger", file})
end, {})
vim.keymap.set("n", "<leader>fr", ":RangerReveal<CR>", { noremap = true, silent = true })
