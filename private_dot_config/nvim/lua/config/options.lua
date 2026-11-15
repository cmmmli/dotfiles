-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- LazyVim は SSH 接続中だけ clipboard を空にする。SSH 越しでもシステムクリップボードを使うため常に指定する。
vim.opt.clipboard = "unnamedplus"
