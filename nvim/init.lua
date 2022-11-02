-- BASIC SETTINGS ------------------------------------------------------------
vim.o.number = true
vim.o.relativenumber = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.undolevels = 10000000
vim.o.undofile = true
vim.o.path = vim.o.path .. '**'
vim.o.wildignore = '*node_modules/*,*bower_components/*,*venv/*,*__pycache__/*,*.pyc'
vim.o.hlsearch = false
vim.o.completeopt = 'menu,menuone,noselect'
vim.o.foldmethod = 'indent'
vim.o.foldlevel = 99
vim.o.showmode = false
vim.o.laststatus = 3
vim.o.updatetime = 100
vim.o.dictionary = '/usr/share/dict/cracklib-small' -- Ctrl-x,Ctrl-k
vim.o.thesaurus = '~/.vim/thesaurus.txt' -- Ctrl-x,Ctrl-t
vim.o.mouse = nil
vim.g.vimrc = vim.fn.resolve(vim.fn.expand('<sfile>:p'))
vim.g.vimdir = vim.fn.fnamemodify(vim.g.vimrc, ':h')


-- NETRW SETTINGS -------------------------------------------------------
vim.g.netrw_preview   = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize   = 30


-- AUTOCOMMANDS ------------------------------------------------------------
-- highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank { timeout = 500 } end,
})
-- make neovim terminal more like vim terminal
-- disable line numbering in terminal mode
local vim_term = vim.api.nvim_create_augroup('vim_term', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
  end,
  group = vim_term
})
-- start insert mode when moving to a terminal window
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
  callback = function()
    if vim.bo.buftype == 'terminal' then vim.cmd('startinsert') end
  end,
  group = vim_term
})
-- prevents insert mode when the terminal process has exited
vim.api.nvim_create_autocmd('TermClose', {
  callback = function(ctx)
    vim.cmd('stopinsert')
    vim.api.nvim_create_autocmd('TermEnter', {
      command = 'stopinsert',
      buffer = ctx.buf,
    })
  end,
  nested = true,
  group = vim_term
})
-- indentation spacing
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.js', '*.html', '*.css', '*.jsx', '*.lua', '*.vue' },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end
})
-- jumps to the last position when reopening a file
vim.api.nvim_create_autocmd(
  { 'BufReadPost' }, {
  pattern = { '*' },
  callback = function()
    -- don't apply to git messages
    local buf = vim.fn.expand('%:t')
    if buf == 'COMMIT_EDITMSG' or buf == 'git-rebase=todo' then
      return
    end
    -- get position of last saved edit
    local markpos = vim.api.nvim_buf_get_mark(0, '"')
    local line, col = markpos[1], markpos[2]
    -- if in range, go there
    if (line > 1) and (line <= vim.api.nvim_buf_line_count(0)) then
      vim.api.nvim_win_set_cursor(0, { line, col })
    end
  end
})
vim.api.nvim_create_autocmd(
  { 'BufNewFile', 'BufRead' }, {
  pattern = { '*.vader' },
  command = 'set syntax=vim',
})
-- create directories if not already there when saving files
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(ctx)
    vim.fn.mkdir(vim.fn.fnamemodify(ctx.file, ':p:h'), 'p')
  end
})
-- create template files
vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = { '*.sh' },
  command = '0r ' .. vim.fn.fnamemodify(vim.g.vimdir, ':h') .. '/vim/templates/template.sh'
})


-- PLUGINS ------------------------------------------------------------
require('packer').startup(function(use)
  -- package manager
  use 'wbthomason/packer.nvim'
  -- lsp configs
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'WhoIsSethDaniel/mason-tool-installer.nvim'
  use 'jose-elias-alvarez/null-ls.nvim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  -- completion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'saadparwaiz1/cmp_luasnip'
  -- snippets
  use({ 'L3MON4D3/LuaSnip', tag = "v<CurrentMajor>.*" })
  -- undo tree
  use 'simnalamburt/vim-mundo'
  -- colorschemes
  use 'ellisonleao/gruvbox.nvim'
  -- text object extensions
  use 'machakann/vim-sandwich'
  use 'machakann/vim-swap'
  -- git enhancers
  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    -- tag = 'release',
    config = require('gitsigns').setup({ keymaps = {} })
  }
  -- file searcher
  use {
    'ibhagwan/fzf-lua',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }
  -- statusline
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  -- markdown
  use {
    'iamcco/markdown-preview.nvim',
    run = function() vim.fn['mkdp#util#install']() end,
  }
  use 'masukomi/vim-markdown-folding'
  -- database
  use 'tpope/vim-dadbod'
  use 'kristijanhusak/vim-dadbod-ui'
  use 'kristijanhusak/vim-dadbod-completion'
  -- code outline
  use 'stevearc/aerial.nvim'
  -- personal plugins
  use 'superDross/ticket.vim'
  use 'superDross/picobook'
  use 'superDross/run-with-me.vim'
  use 'superDross/scrappy.vim'
  use 'superDross/spellbound.nvim'
end)


-- COLOURSCHEMES ------------------------------------------------------------
local colors = require('gruvbox.palette')
require('gruvbox').setup({
  contrast = 'hard',
  overrides = {
    SignColumn = { bg = colors.dark0_hard },
    -- temp fix for git signs in column https://github.com/ellisonleao/gruvbox.nvim/issues/129
    GruvboxRedSign = { fg = colors.red, bg = colors.dark0_hard, reverse = false },
    GruvboxGreenSign = { fg = colors.green, bg = colors.dark0_hard, reverse = false },
    GruvboxYellowSign = { fg = colors.yellow, bg = colors.dark0_hard, reverse = false },
    GruvboxBlueSign = { fg = colors.blue, bg = colors.dark0_hard, reverse = false },
    GruvboxPurpleSign = { fg = colors.purple, bg = colors.dark0_hard, reverse = false },
    GruvboxAquaSign = { fg = colors.aqua, bg = colors.dark0_hard, reverse = false },
    GruvboxOrangeSign = { fg = colors.orange, bg = colors.dark0_hard, reverse = false },
  }
})
vim.opt.termguicolors = true
vim.o.background = 'dark'
vim.cmd.colorscheme('gruvbox')
vim.env.BAT_THEME = 'gruvbox-dark'


-- MAPPINGS ------------------------------------------------------------
local opts = { noremap = true, silent = true }
vim.g.mapleader = ' '

-- set mappings based upon {key: command}
function _G.set_key_map(mode, mappings, options)
  for map, func in pairs(mappings) do
    vim.keymap.set(mode, map, func, options)
  end
end

local terminal_mappings = {
  ['<Esc>'] = '<C-\\><C-n>',
  ['<C-w>'] = '<C-\\><C-n><C-w>',
}

local visual_mappings = {
  -- clipboard
  ['<leader>y']  = '"+y',
  ['<leader>p']  = '"+p',
  ['<Leader>rs'] = '<cmd>RunSelectedCode<CR>',
}

local normal_mappings = {
  -- folding
  ['<leader><leader>'] = 'za',
  -- clipboard
  ['<leader>y']        = '"+y',
  ['<leader>p']        = '"+p',
  -- undo mappings
  ['<leader>u']        = '<cmd>MundoToggle<CR>',
  -- git mappings
  ['<leader>ga']       = '<cmd>Git add %<CR>',
  ['<leader>gb']       = '<cmd>Git blame<CR>',
  ['<leader>gc']       = '<cmd>Git commit -n<CR>',
  ['<leader>gd']       = '<cmd>Git diff %<CR>',
  ['<leader>gg']       = '<cmd>Git<CR>',
  ['<leader>gl']       = '<cmd>Git log<CR>',
  ['<leader>gm']       = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
  ['<leader>gs']       = '<cmd>Git status<CR>',
  -- tab mappings
  ['<C-h>']            = ':tabprevious<CR>',
  ['<C-l>']            = ':tabnext<CR>',
  -- window resizing
  ['<C-Up>']           = '<cmd>resize +5<CR>',
  ['<C-Down>']         = '<cmd>resize -5<CR>',
  ['<C-Left>']         = '<cmd>vertical resize +5<CR>',
  ['<C-Right>']        = '<cmd>vertical resize -5<CR>',
  -- leader number mappings
  ['<leader>0']        = ':silent set hlsearch! hlsearch?<CR>',
  ['<leader>1']        = '<cmd>RunTests 0<CR>',
  ['<leader>3']        = '<cmd>MarkdownPreviewToggle<CR>',
  ['<leader>4']        = '<cmd>lua vim.lsp.buf.format()<CR>',
  ['<leader>5']        = '<cmd>Vexplore<CR>',
  ['<leader>8']        = '<cmd>AerialToggle!<CR>',
  ['<leader>t']        = '<cmd>startinsert | sp | resize 15 | term<CR>',
  ['<leader>T']        = '<cmd>startinsert | vs | term<CR>',
  -- diagnostics
  ['<leader>e']        = '<cmd>lua vim.diagnostic.open_float()<CR>',
  ['<leader>j']        = '<cmd>lua vim.diagnostic.goto_next()<CR>',
  ['<leader>k']        = '<cmd>lua vim.diagnostic.goto_prev()<CR>',
  ['<leader>q']        = '<cmd>lua vim.diagnostic.setloclist()<CR>',
  -- FZF
  ['<Leader>f*']       = "<cmd>FzfLua grep_cword previewer=bat git_icons=false file_icons=false<CR>",
  ['<Leader>f`']       = '<cmd>FzfLua marks<CR>',
  ['<Leader>fa']       = '<cmd>FzfLua live_grep_resume previewer=bat git_icons=false file_icons=false<CR>',
  ['<Leader>fb']       = '<cmd>FzfLua buffers<CR>',
  ['<Leader>fc']       = '<cmd>FzfLua git_commits<CR>',
  ['<Leader>fg']       = '<cmd>FzfLua live_grep_native previewer=bat git_icons=false file_icons=false<CR>',
  ['<Leader>fn']       = '<cmd>GrepNotes<CR>',
  ['<Leader>fs']       = '<cmd>FindSessions<CR>',
  ['<leader>ff']       = '<cmd>FzfLua files previewer=bat git_icons=false file_icons=false<CR>',
  ['<leader>fp']       = '<cmd>FzfLua lsp_definitions<CR>',
  ['<leader>fr']       = '<cmd>FzfLua lsp_references<CR>',
  -- run-with-me.vim
  ['<Leader>rc']       = '<cmd>RunCode<CR>',
  ['<Leader>rv']       = '<cmd>RunCodeVert<CR>',
  ['<Leader>rs']       = '<cmd>RunSelectedCode<CR>',
  ['<Leader>rt']       = '<cmd>RunTestsVert<CR>',
  ['<Leader>rm']       = '<cmd>RunModuleTestsVert<CR>',
  ['<Leader>rn']       = '<cmd>RunNearestTestVert<CR>',
  -- ticket.vim
  ['<Leader>ss']       = '<cmd>SaveSession<CR>',
  ['<Leader>so']       = '<cmd>OpenSession<CR>',
  ['<Leader>sd']       = '<cmd>DeleteSession<CR>',
  ['<Leader>sc']       = '<cmd>CleanupSessions<CR>',
  ['<Leader>sf']       = '<cmd>FindSessions<CR>',
  ['<Leader>ns']       = '<cmd>SaveNote<CR>',
  ['<Leader>no']       = '<cmd>OpenNote<CR>',
  ['<Leader>nd']       = '<cmd>DeleteNote<CR>',
  ['<Leader>ng']       = '<cmd>GrepNotes<CR>',
}

set_key_map('n', normal_mappings, opts)
set_key_map('v', visual_mappings, opts)
set_key_map('t', terminal_mappings, opts)

local on_attach = function(client, bufnr)
  -- this is required so the LSP takes effect on all buffers
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local mappings = {
    ['<leader>lc'] = '<cmd>lua vim.lsp.buf.code_action()<CR>',
    ['<leader>ld'] = '<cmd>lua vim.lsp.buf.definition()<CR>',
    ['<leader>lf'] = '<cmd>lua vim.lsp.buf.references()<CR>',
    ['<leader>lh'] = '<cmd>lua vim.lsp.buf.hover()<CR>',
    ['<leader>ln'] = '<cmd>tab split | lua vim.lsp.buf.definition()<CR>',
    ['<leader>lr'] = '<cmd>lua vim.lsp.buf.rename()<CR>',
    ['<leader>ls'] = '<cmd>lua vim.lsp.buf.signature_help()<CR>',
    ['<leader>lv'] = '<cmd>vert split | lua vim.lsp.buf.definition()<CR>',
    ['<leader>lx'] = '<cmd>split | lua vim.lsp.buf.definition()<CR>',
  }
  for map, func in pairs(mappings) do
    vim.api.nvim_buf_set_keymap(bufnr, 'n', map, func, opts)
  end
end


-- STATUSLINE ------------------------------------------------------------
require('lualine').setup({
  options = {
    theme = 'gruvbox',
    globalstatus = true
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff',
      {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        sections = { 'error', 'warn', 'info', 'hint' },
        symbols = { error = '✘ ', warn = '⏶ ', info = 'ℹ ', hint = '? ' },
        colored = true,
        update_in_insert = false,
        always_visible = false,
      }
    },
    lualine_c = {
      {
        'filename',
        symbols = {
          modified = " | +",
          readonly = " | RO",
        }
      }
    },
    lualine_x = { { 'aerial', color = { fg = '#f0f0ed' } } },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  }
})


-- LSP ------------------------------------------------------------
local mason_lspconfig = require('mason-lspconfig')
local lspconfig = require("lspconfig")
local null_ls = require('null-ls')
local mason_installer = require('mason-tool-installer')
require('mason').setup {}
require('aerial').setup({})

-- autoinstall lsp (separate mason_installer so setup_handlers can work)
mason_lspconfig.setup {
  ensure_installed = { 'pyright', 'bashls', 'tsserver', 'sumneko_lua', 'dockerls', 'vimls' },
  automatic_installation = true,
}
-- autoinstall formatters and linters
mason_installer.setup {
  ensure_installed = {
    'black', 'flake8', 'isort', 'hadolint', 'jq', 'prettier', 'shfmt',
    'vint', 'sql-formatter', 'stylua', 'luacheck', 'shellharden', 'shellcheck'
  },
}

local function swap_error_warning(diagnostic)
  -- swap error for warning in diagnostic tools, can slow down large files
  diagnostic.severity = diagnostic.message:find("really") and
      vim.diagnostic.severity["ERROR"] or
      vim.diagnostic.severity["WARN"]
end

-- setup formatters and linters
local d, f = null_ls.builtins.diagnostics, null_ls.builtins.formatting
local flake8_config = {
  diagnostics_postprocess = swap_error_warning,
  extra_args = { '--ignore=W503,E203,E231', '--max-line-length=120' }
}
local shfmt_config = { extra_args = { '-i', '4' } } -- use 4 spaces
null_ls.setup({
  sources = {
    d.hadolint, d.vint, d.flake8.with(flake8_config),
    f.black, f.isort, f.jq, f.shfmt.with(shfmt_config), f.sql_formatter, f.shellharden,
  }
})

-- automatically start each server when the corresponding filetype is opened
mason_lspconfig.setup_handlers({
  function(server_name)
    lspconfig[server_name].setup { on_attach = on_attach }
  end,
  -- provide targeted overrides for specific servers.
  ['sumneko_lua'] = function()
    lspconfig.sumneko_lua.setup {
      on_attach = on_attach,
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = { globals = { 'vim' } },
        }
      }
    }
  end,
  ['ltex'] = function()
    lspconfig.ltex.setup { on_attach = on_attach, filetypes = { 'tex' } } -- spelling
  end,
  --- https://github.com/microsoft/pyright/blob/main/docs/settings.md
  ['pyright'] = function()
    lspconfig.pyright.setup {
      on_attach = on_attach,
      settings = {
        pyright = {
          autoImportCompletion = true,
        },
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = 'openFilesOnly',
            useLibraryCodeForTypes = true,
            typeCheckingMode = 'off'
          }
        }
      }
    }
  end,
})

-- disable inline diagnostics for LSPs
vim.diagnostic.config({
  virtual_text = false,
  float = { source = 'always' },
  severity_sort = true,
})

-- change gutter symbols
vim.fn.sign_define('DiagnosticSignWarn', { text = '--', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignError', { text = '>>', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignHint', { text = '?', texthl = 'DiagnosticSignHint' })
vim.fn.sign_define('DiagnosticSignInfo', { text = 'i', texthl = 'DiagnosticSignInfo' })


-- SNIPPETS -------------------------------------------------------------
local luasnip = require("luasnip")
require("luasnip.loaders.from_lua").load({
  paths = vim.g.vimdir .. '/snippets/'
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
  -- for manual completion only
  -- completion = { autocomplete = false },
  enabled = function()
    -- disable completion in comments
    local context = require 'cmp.config.context'
    if vim.api.nvim_get_mode().mode == 'c' then
      return true
    else
      return not context.in_treesitter_capture("comment")
          and not context.in_syntax_group("Comment")
    end
  end,
  -- tab completion and selection
  -- updated for compatibilty with luasnip: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm { select = true },
  },
  sources = cmp.config.sources({
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'vim-dadbod-completion' },
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
}


-- TREESITTERS ------------------------------------------------------------
require 'nvim-treesitter.configs'.setup {
  highlight = { enable = true, additional_vim_regex_highlighting = false },
} -- TSInstall all


-- MARKDOWN PREVIEWER ------------------------------------------------------
vim.g.mkdp_theme = 'light'
vim.g.mkdp_browser = 'firefox'


-- DADBOD ------------------------------------------------------------------

vim.g.dbs = {
  dev_postgres = 'postgres://postgres:postgres@localhost:5432',
  dev_mongo = 'mongodb://localhost:27017',
}


-- PERSONAL ------------------------------------------------------------
-- run-with-me
vim.g.default_testing_cmd = 'make test TEST_ARGS='
-- piconotes
vim.g.notesdir = '~/bin/piconotes/'
vim.g.noteurl = 'https://github.com/superDross/dotfiles/blob/master/notes/'
-- ticket.vim
vim.g.auto_ticket_open = 1
vim.g.auto_ticket_git_only = 1
vim.g.ticket_black_list = { 'main', 'master' }
vim.g.ticket_use_fzf_default = 1
vim.g.ticket_very_verbose = 1
-- scrappy
vim.g.scrappy_use_fzf_default = 1
-- spellbound.nvim
vim.g.spellbound_settings = {
  mappings = {
    fix_right = '<M-l>',
    fix_left = '<M-h>',
    toggle_map = '<M-s>'
  },
}
