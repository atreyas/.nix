local o = vim.opt -- because opt now supports all of o, bo, wo ?
local g = vim.g
local map = vim.keymap

g.mapleader = ';'
g.maplocalleader = ';'

map.set('n', 'sr', ':%s/')
map.set('i', 'jj', '<ESC>')

o.clipboard = 'unnamedplus'

o.number = true
o.relativenumber = true
o.cursorline = true

o.signcolumn = 'yes'

o.smartindent = true
o.autoindent = true
o.tabstop = 4
o.shiftwidth = 4
o.smarttab = true
o.expandtab = true

o.updatetime = 300
o.ttimeoutlen = 5

-- Nicer UI settings
o.termguicolors = true
o.mouse = 'a'

-- Remove viminfo file
o.viminfo = ""
o.viminfofile = "NONE"

o.compatible = false
o.autoread = true
o.incsearch = true
o.hidden = true

o.wrap = false
o.backup = false
o.writebackup = false
o.swapfile = false
o.errorbells = false


