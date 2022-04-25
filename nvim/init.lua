-- NOTE: helpful for converting to lua:
-- https://github.com/nanotee/nvim-lua-guide
-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/

-- BASIC SETTINGS ------------------------------------------------------------
vim.o.number = true
vim.o.relativenumber = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.undolevels=10000000
vim.o.undofile = true
vim.o.path = vim.o.path .. "**"
vim.o.wildignore = '*node_modules/*,*bower_components/*,*venv/*,*__pycache__/*,*.pyc'
vim.o.hlsearch = false
vim.o.completeopt = "menu,menuone,noselect"
vim.o.foldmethod = "indent"
vim.o.foldlevel = 99
vim.o.showmode = false
vim.o.laststatus = 3


-- FUNCTIONS ------------------------------------------------------------
function SpellingToggle()
  if vim.o.spell == false then
    print("spelling on")
    vim.cmd('setlocal spell spelllang=en_gb')
    vim.cmd('hi SpellBad cterm=underline ctermfg=Red ctermbg=none')
  else
    print('spelling off')
    vim.cmd('setlocal nospell')
  end
end


-- SNIPPETS ------------------------------------------------------------
vim.cmd("iabbrev pudb_remote from pudb.remote import set_trace; set_trace(term_size=(160, 40),host='0.0.0.0', port=6900)  # fmt: skip")
vim.cmd("iabbrev pudb import pudb;pudb.set_trace()  # fmt: skip")
vim.cmd("iabbrev pdb import pdb;pdb.set_trace()  # fmt: skip")
vim.cmd("iabbrev remote_pdb from remote_pdb import RemotePdb;RemotePdb('0.0.0.0', 4444).set_trace()  # fmt: skip")
vim.cmd("iabbrev rpdb from remote_pdb import RemotePdb;RemotePdb('0.0.0.0', 4444).set_trace()  # fmt: skip")
vim.cmd("iabbrev ipdb import ipdb;ipdb.set_trace()  # fmt: skip")
vim.cmd("iabbrev pytrace import pytest;pytest.set_trace()  # fmt: skip")


-- AUTOCOMMANDS ------------------------------------------------------------
-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank{timeout=500} end,
})
-- make terminal more like vim (no nums, insert mode when switching to term win)
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
  end
})
vim.api.nvim_command([[
autocmd BufWinEnter,WinEnter * if &buftype == 'terminal' | silent! normal i | endif
]])
-- indentation spacing
vim.api.nvim_command([[
augroup BufNewFile,BufRead *.js,*.html,*.css,*.jsx,*.lua
  setlocal expandtab
  setlocal tabstop=2
  setlocal softtabstop=2
  setlocal shiftwidth=2
augroup END
]])
-- jumps to the last position when reopening a file
vim.api.nvim_command([[
autocmd BufRead * autocmd FileType <buffer> ++once if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif
]])


-- PLUGINS ------------------------------------------------------------
local use = require('packer').use
require('packer').startup(function()
  -- package manager
  use 'wbthomason/packer.nvim'
  -- lsp configs
  use 'neovim/nvim-lspconfig'
  use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
  }
  -- completion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  -- formatter
  use 'mhartington/formatter.nvim'
  -- symbol viewer
  use 'simrat39/symbols-outline.nvim'
  -- undo tree
  use 'simnalamburt/vim-mundo'
  -- colorschemes
  use 'ellisonleao/gruvbox.nvim'
  -- text object extensions
  use 'machakann/vim-sandwich'
  -- git enhancers
  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    tag = 'release'
  }
  -- file searcher
  use 'junegunn/fzf.vim'
  use 'chengzeyi/fzf-preview.vim'
  -- statusline
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  -- personal plugins
  use 'superDross/class-builder'
  use 'superDross/ticket.vim'
  use 'superDross/picobook'
  use 'superDross/run-with-me.vim'
  use 'superDross/scrappy.vim'
end)


-- COLOURSCHEMES ------------------------------------------------------------
vim.g.gruvbox_contrast_dark = "hard"
vim.g.gruvbox_sign_column = 'bg0'
vim.g.gruvbox_color_column = 'bg0'
vim.opt.termguicolors = true
vim.o.background = 'dark'
vim.env.BAT_THEME = "gruvbox-dark"
vim.cmd([[colorscheme gruvbox]])


-- MAPPINGS ------------------------------------------------------------
local opts = { noremap=true, silent=true }
vim.g.mapleader = ' '

function SetKeymap (mode, mappings, opts)
  -- set mappings based upon {key: command}
  for map, func in pairs(mappings) do
    vim.keymap.set(mode, map, func, opts)
  end
end

local terminal_mappings = {
  ['<Esc>'] = '<C-\\><C-n>',
  ['<C-w>'] = '<C-\\><C-n><C-w>',
}

local visual_mappings = {
  -- clipboard
  ['<leader>y'] = '"+y',
  ['<leader>p'] = '"+p',
}

local normal_mappings = {
  -- folding
  ['<leader><leader>'] = 'za',
  -- clipboard
  ['<leader>y'] = '"+y',
  ['<leader>p'] = '"+p',
  -- undo mappings
  ['<leader>u'] = '<cmd>MundoToggle<CR>',
  -- git mappings
  ['<leader>m'] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
  -- tab mappings
  ['<C-h>'] = ':tabprevious<CR>',
  ['<C-l>'] = ':tabnext<CR>',
  -- leader number mappings
  ['<leader>0'] = ':set hlsearch! hlsearch?<CR>',
  ['<leader>1'] = '<cmd>RunTests 0<CR>',
  ['<leader>4'] = '<cmd>Format<CR>',
  ['<leader>8'] = '<cmd>SymbolsOutline<CR>',
  ['<leader>9'] = '<cmd>RunCode 0<CR>',
  ['<leader>s'] = '<cmd>lua SpellingToggle()<CR>',
  ['<leader>t'] = '<cmd>startinsert | sp | resize 15 | term<CR>',
  -- lsp
  ['<leader>e'] = '<cmd>lua vim.diagnostic.open_float()<CR>',
  ['<leader>k'] = '<cmd>lua vim.diagnostic.goto_prev()<CR>',
  ['<leader>j'] = '<cmd>lua vim.diagnostic.goto_next()<CR>',
  ['<leader>q'] = '<cmd>lua vim.diagnostic.setloclist()<CR>',
  -- FZF
  ['<leader>f'] = '<cmd>FZF<CR>',
  ['<Leader>a'] = '<cmd>RgContents<CR>',
  ['<Leader>g'] = '<cmd>Rg<CR>',
  ['<Leader>b'] = '<cmd>Buffers<CR>',
  ['<Leader>c'] = '<cmd>Commits<CR>',
  ['<Leader>`'] = '<cmd>FZFMarks<CR>',
  ['<Leader>*'] = "<cmd>execute 'Rg' expand('<cword>')<CR>",
}

SetKeymap('n', normal_mappings, opts)
SetKeymap('v', visual_mappings, opts)
SetKeymap('t', terminal_mappings, opts)

local on_attach = function(client, bufnr)
  -- this is required so the LSP takes effect on all buffers
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local mappings = {
    ['<leader>d'] = '<cmd>lua vim.lsp.buf.definition()<CR>',
    ['<leader>h'] = '<cmd>lua vim.lsp.buf.hover()<CR>',
    ['<leader>n'] = '<cmd>tab split | lua vim.lsp.buf.definition()<CR>',
    ['<leader>x'] = '<cmd>split | lua vim.lsp.buf.definition()<CR>',
    ['<leader>v'] = '<cmd>vert split | lua vim.lsp.buf.definition()<CR>',
    ['<leader>r'] = '<cmd>lua vim.lsp.buf.rename()<CR>',
  }
  for map, func in pairs(mappings) do
    vim.api.nvim_buf_set_keymap(bufnr, 'n', map, func, opts)
  end
end


-- PERSONAL ------------------------------------------------------------
vim.g.default_testing_cmd = 'make test'
vim.g.notesdir = '~/bin/dotfiles/notes/'
vim.g.noteurl = 'https://github.com/superDross/dotfiles/blob/master/notes/'


-- GIT ------------------------------------------------------------
require('gitsigns').setup({ keymaps = {} })


-- TAGBAR ----------------------------------------------------------------
vim.g.symbols_outline = {auto_preview = false}


-- STATUSLINE ------------------------------------------------------------
require('lualine').setup({
  options = { theme = 'gruvbox' },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {
      {
	'filename',
	symbols = {
	  modified = " | +",
	  readonly = " | RO",
	}
      }
    },
    lualine_x = {
      {
        'diagnostics',
        sources = { 'nvim_diagnostic'},
        sections = { 'error', 'warn', 'info', 'hint' },
        diagnostics_color = {
          error = 'DiagnosticError',
          warn  = 'DiagnosticWarn',
          info  = 'DiagnosticInfo',
          hint  = 'DiagnosticHint',
        },
        symbols = {error = '✘ ', warn = '⏶ ', info = 'ℹ ', hint = '? '},
        colored = true,
        update_in_insert = false,
        always_visible = false,
      }
    },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  }
})


-- LSP ------------------------------------------------------------
-- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
-- e.g. settings = { pylsp = { plugins = { flake8 = { maxLineLength = 10 } } } }
require'lspconfig'.pylsp.setup{on_attach = on_attach}
require'lspconfig'.bashls.setup{on_attach = on_attach}
require'lspconfig'.dockerls.setup{on_attach = on_attach}
require'lspconfig'.vimls.setup{on_attach = on_attach}
require'lspconfig'.sumneko_lua.setup{
  on_attach = on_attach,
  settings = {
    Lua = {
        diagnostics = {
            globals = { 'vim' }
        }
    }
  }
}
-- disable inline diagnostics for LSPs
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false
    }
)
-- change gutter symbols
vim.fn.sign_define("DiagnosticSignWarn", { text = "--", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignError", { text = ">>", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignHint", { text = "?", texthl = "DiagnosticSignHint"})


-- FORMATTERS ------------------------------------------------------------
require('formatter').setup({
  filetype = {
    python = {
      function()
        return {
          exe = "isort",
          args = { "-" },
          stdin = true,
        }
      end,
      function()
        return {
          exe = "black",
          args = { "-" },
          stdin = true,
        }
      end
    }
  }
})


-- COMPLETION ------------------------------------------------------------
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end
-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#no-snippet-plugin
-- compare completion methods https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
local cmp = require('cmp')
cmp.setup {
  completion = {
    autocomplete = false,
  },
  mapping = {
      ['<Tab>'] = function(fallback)
        if not cmp.select_next_item() then
          if vim.bo.buftype ~= 'prompt' and has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end
      end,
    ['<S-Tab>'] = function(fallback)
      if not cmp.select_prev_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  })
}


-- TREESITTERS ------------------------------------------------------------
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
} -- TSInstall all


-- FZF --------------------------------------------------------------------
vim.env.FZF_DEFAULT_COMMAND = "rg --files --hidden --follow --glob '!.git'"
vim.cmd([[
command! -bang -nargs=* RgContents
  \ call fzf#vim#grep(
  \ 'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \ fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0
  \)
]])
