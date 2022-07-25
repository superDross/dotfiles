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


-- NETRW SETTINGS -------------------------------------------------------
vim.g.netrw_preview   = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize   = 30


-- FUNCTIONS ------------------------------------------------------------
function ActivateSpelling()
  vim.cmd('setlocal spell spelllang=en_gb')
  vim.cmd('hi SpellBad cterm=underline ctermfg=Red ctermbg=none')
end

function SpellingToggle()
  if vim.o.spell == false then
    print('Spelling On')
    ActivateSpelling()
  else
    print('Spelling Off')
    vim.cmd('setlocal nospell')
  end
end

function HasValue(table, val)
  -- check if value is in table (list)
  for _, value in ipairs(table) do
    if value == val then return true end
  end
  return false
end

function Format()
  -- determines if filetype should use Format plugin or lsp formatter
  local custom_formatter = { 'python' }
  local use_custom = HasValue(custom_formatter, vim.bo.filetype)
  if use_custom then vim.api.nvim_command('Format') else vim.lsp.buf.formatting() end
end

-- SNIPPETS ------------------------------------------------------------
vim.cmd([[
iabbrev pdb import pdb;pdb.set_trace()  # fmt: skip
iabbrev remote_pdb from remote_pdb import RemotePdb;RemotePdb('0.0.0.0', 4444).set_trace()  # fmt: skip
iabbrev rpdb from remote_pdb import RemotePdb;RemotePdb('0.0.0.0', 4444).set_trace()  # fmt: skip
iabbrev scriptline if __name__ == '__main__':<CR>
]])


-- AUTOCOMMANDS ------------------------------------------------------------
-- highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank { timeout = 500 } end,
})
-- make neovim terminal more like vim terminal
local vim_term = vim.api.nvim_create_augroup('vim_term', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
  end,
  group = vim_term
})
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
  callback = function()
    if vim.bo.buftype == 'terminal' then vim.cmd('startinsert') end
  end,
  group = vim_term
})
vim.api.nvim_create_autocmd('TermClose', {
  command = 'stopinsert',
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
    local ft = vim.opt_local.filetype:get()
    -- don't apply to git messages
    if (ft:match('commit') or ft:match('rebase')) then
      return
    end
    -- get position of last saved edit
    local markpos = vim.api.nvim_buf_get_mark(0, '"')
    local line = markpos[1]
    local col = markpos[2]
    -- if in range, go there
    if (line > 1) and (line <= vim.api.nvim_buf_line_count(0)) then
      vim.api.nvim_win_set_cursor(0, { line, col })
    end
  end
})
-- automatically set spelling settings on when opening certain file types
local spelling = vim.api.nvim_create_augroup('spelling', { clear = true })
vim.api.nvim_create_autocmd(
  { 'BufRead', 'BufNewFile' }, {
  pattern = { '*.md', '*.txt', '*.rst' },
  callback = function() ActivateSpelling() end,
  group = spelling,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern  = { 'gitcommit', 'gitrebase' },
  callback = function() ActivateSpelling() end,
  group    = spelling,
})


-- PLUGINS ------------------------------------------------------------
local use = require('packer').use
require('packer').startup(function()
  -- package manager
  use 'wbthomason/packer.nvim'
  -- lsp configs
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  -- completion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  -- formatter
  use 'mhartington/formatter.nvim'
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
    tag = 'release',
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
  -- markdown previewer
  use {
    'iamcco/markdown-preview.nvim',
    run = function() vim.fn['mkdp#util#install']() end,
  }
  -- personal plugins
  use 'superDross/class-builder'
  use 'superDross/ticket.vim'
  use 'superDross/picobook'
  use 'superDross/run-with-me.vim'
  use 'superDross/scrappy.vim'
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
vim.cmd([[colorscheme gruvbox]])


-- MAPPINGS ------------------------------------------------------------
local opts = { noremap = true, silent = true }
vim.g.mapleader = ' '

function SetKeymap(mode, mappings, options)
  -- set mappings based upon {key: command}
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
  ['<leader>y'] = '"+y',
  ['<leader>p'] = '"+p',
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
  ['<leader>m']        = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
  -- tab mappings
  ['<C-h>']            = ':tabprevious<CR>',
  ['<C-l>']            = ':tabnext<CR>',
  -- leader number mappings
  ['<leader>0']        = ':set hlsearch! hlsearch?<CR>',
  ['<leader>1']        = '<cmd>RunTests 0<CR>',
  ['<leader>3']        = '<cmd>MarkdownPreviewToggle<CR>',
  ['<leader>4']        = '<cmd>lua Format()<CR>',
  ['<leader>5']        = '<cmd>Vexplore<CR>',
  ['<leader>8']        = '<cmd>SymbolsOutline<CR>',
  ['<leader>9']        = '<cmd>RunCode 0<CR>',
  ['<leader>s']        = '<cmd>lua SpellingToggle()<CR>',
  ['<leader>;']        = ']s1z=', -- fix next spelling mistake with first suggestion
  ['<M-l>']            = ']s1z=',
  ['<leader>:']        = '[s1z=', -- fix previous spelling mistake with first suggestion
  ['<M-h>']            = '[s1z=',
  ['<leader>t']        = '<cmd>startinsert | sp | resize 15 | term<CR>',
  ['<leader>T']        = '<cmd>startinsert | vs | term<CR>',
  -- lsp
  ['<leader>e']        = '<cmd>lua vim.diagnostic.open_float()<CR>',
  ['<leader>j']        = '<cmd>lua vim.diagnostic.goto_next()<CR>',
  ['<leader>k']        = '<cmd>lua vim.diagnostic.goto_prev()<CR>',
  ['<leader>q']        = '<cmd>lua vim.diagnostic.setloclist()<CR>',
  -- FZF
  ['<Leader>b']        = '<cmd>FzfLua buffers<CR>',
  ['<Leader>c']        = '<cmd>FzfLua git_commits<CR>',
  ['<Leader>g']        = '<cmd>FzfLua live_grep_native git_icons=false file_icons=false<CR>',
  ['<leader>f']        = '<cmd>FzfLua files git_icons=false file_icons=false<CR>',
  ['<Leader>`']        = '<cmd>FzfLua marks<CR>',
  ['<Leader>*']        = "<cmd>FzfLua grep_cword git_icons=false file_icons=false<CR>",
}

SetKeymap('n', normal_mappings, opts)
SetKeymap('v', visual_mappings, opts)
SetKeymap('t', terminal_mappings, opts)

local on_attach = function(_, bufnr)
  -- this is required so the LSP takes effect on all buffers
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local mappings = {
    ['<leader>d'] = '<cmd>lua vim.lsp.buf.definition()<CR>',
    ['<leader>h'] = '<cmd>lua vim.lsp.buf.hover()<CR>',
    ['<leader>n'] = '<cmd>tab split | lua vim.lsp.buf.definition()<CR>',
    ['<leader>r'] = '<cmd>lua vim.lsp.buf.rename()<CR>',
    ['<leader>~'] = '<cmd>lua vim.lsp.buf.references()<CR>',
    ['<leader>v'] = '<cmd>vert split | lua vim.lsp.buf.definition()<CR>',
    ['<leader>x'] = '<cmd>split | lua vim.lsp.buf.definition()<CR>',
  }
  for map, func in pairs(mappings) do
    vim.api.nvim_buf_set_keymap(bufnr, 'n', map, func, opts)
  end
end


-- PERSONAL ------------------------------------------------------------
vim.g.default_testing_cmd = 'make test'
vim.g.notesdir = '~/bin/dotfiles/notes/'
vim.g.noteurl = 'https://github.com/superDross/dotfiles/blob/master/notes/'


-- STATUSLINE ------------------------------------------------------------
require('lualine').setup({
  options = {
    theme = 'gruvbox',
    globalstatus = true
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff' },
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
        sources = { 'nvim_diagnostic' },
        sections = { 'error', 'warn', 'info', 'hint' },
        diagnostics_color = {
          error = 'DiagnosticError',
          warn  = 'DiagnosticWarn',
          info  = 'DiagnosticInfo',
          hint  = 'DiagnosticHint',
        },
        symbols = { error = '✘ ', warn = '⏶ ', info = 'ℹ ', hint = '? ' },
        colored = true,
        update_in_insert = false,
        always_visible = false,
      }
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  }
})


-- LSP ------------------------------------------------------------
-- :LspInstallInfo (it installs everything within ~/.local/share/nvim/lsp_servers/)
require('nvim-lsp-installer').setup {
  ensure_installed = { 'pylsp', 'bashls', 'tsserver', 'sumneko_lua', 'dockerls', 'vimls' },
  automatic_installation = true,
}
-- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
-- e.g. settings = { pylsp = { plugins = { flake8 = { maxLineLength = 10 } } } }
require 'lspconfig'.pylsp.setup { on_attach = on_attach }
require 'lspconfig'.bashls.setup { on_attach = on_attach }
require 'lspconfig'.dockerls.setup { on_attach = on_attach }
require 'lspconfig'.vimls.setup { on_attach = on_attach }
require 'lspconfig'.sumneko_lua.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
    }
  }
}
require 'lspconfig'.tsserver.setup { on_attach = on_attach }
require 'lspconfig'.ltex.setup { on_attach = on_attach, filetypes = { 'tex' } } -- spelling
-- disable inline diagnostics for LSPs
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false
}
)
-- change gutter symbols
vim.fn.sign_define('DiagnosticSignWarn', { text = '--', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignError', { text = '>>', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignHint', { text = '?', texthl = 'DiagnosticSignHint' })


-- FORMATTERS ------------------------------------------------------------
require('formatter').setup({
  filetype = {
    python = {
      function()
        return { exe = 'isort', args = { '-' }, stdin = true }
      end,
      function()
        return { exe = 'black', args = { '-' }, stdin = true }
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
  completion = { autocomplete = false },
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
require 'nvim-treesitter.configs'.setup {
  highlight = { enable = true, additional_vim_regex_highlighting = false },
} -- TSInstall all


-- MARKDOWN PREVIEWER ------------------------------------------------------
vim.g.mkdp_theme = 'light'
vim.g.mkdp_browser = 'firefox'
