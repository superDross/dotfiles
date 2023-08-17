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
vim.o.thesaurus = '~/.vim/thesaurus.txt'            -- Ctrl-x,Ctrl-t
vim.o.mouse = nil
vim.o.sessionoptions = 'buffers,curdir,help,tabpages,terminal,winsize'
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.g.vimrc = vim.fn.resolve(vim.fn.expand('<sfile>:p'))
vim.g.vimdir = vim.fn.fnamemodify(vim.g.vimrc, ':h')
vim.g.mapleader = ' '


-- PLUGINS ------------------------------------------------------------
-- Install lazy.nvim automatically
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  print('Installing Lazy.nvim...')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- package manager
  'folke/lazy.nvim',
  -- dependencies
  'nvim-lua/plenary.nvim',
  -- lsp configs
  'neovim/nvim-lspconfig',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  'jose-elias-alvarez/null-ls.nvim',
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  -- AI
  'github/copilot.vim',
  -- completion
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  'saadparwaiz1/cmp_luasnip',
  -- snippets
  'L3MON4D3/LuaSnip',
  -- undo tree
  'simnalamburt/vim-mundo',
  -- colorschemes
  { 'ellisonleao/gruvbox.nvim', priority = 1000 },
  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "MunifTanjim/nui.nvim" }
  },
  -- text object extensions
  'machakann/vim-sandwich',
  'machakann/vim-swap',
  -- git enhancers
  'tpope/vim-commentary',
  'tpope/vim-fugitive',
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },
  -- file searcher
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'kyazdani42/nvim-web-devicons' }
  },
  -- statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons', lazy = true }
  },
  -- markdown
  {
    'iamcco/markdown-preview.nvim',
    build = function() vim.fn['mkdp#util#install']() end,
    init = function()
      vim.g.mkdp_theme = 'light'
      vim.g.mkdp_browser = 'firefox'
    end
  },
  'masukomi/vim-markdown-folding',
  -- code outline
  'stevearc/aerial.nvim',
  -- personal plugins
  {
    'superDross/ticket.vim',
    priority = 500,
    init = function ()
      vim.g.auto_ticket_open = 1
      vim.g.auto_ticket_git_only = 1
      vim.g.ticket_black_list = { 'main', 'master' }
      vim.g.ticket_use_fzf_default = 1
      vim.g.ticket_very_verbose = 1
      vim.g.ticket_overwrite_confirm = 1
    end
  },
  {
    'superDross/picobook',
    init = function ()
      vim.g.notesdir = '~/bin/piconotes/'
      vim.g.noteurl = 'https://github.com/superDross/piconotes/blob/main/'
    end
  },
  {
    'superDross/run-with-me.vim',
    init = function ()
      vim.g.default_testing_cmd = 'make test'
      vim.g.runner_cmds = {
        python = "python3",
        javascript = "node",
        vim = "vim -N -u NONE -n -c 'set nomore' -S",
        tex = "pdflatex",
        lua = "nvim -l",
      }
    end
  },
  {
    'superDross/scrappy.vim',
    init = function ()
      vim.g.scrappy_use_fzf_default = 1
    end
  },
  {
    'superDross/spellbound.nvim',
    init = function ()
      vim.g.spellbound_settings = {
        mappings = {
          fix_right = '<M-l>',
          fix_left = '<M-h>',
          toggle_map = '<M-s>'
        },
        return_to_position = true,
      }
    end
  },
}, {
  dev = {
    path = "~/dev",
  },
  performance = { cache = { enabled = false } },
  lockfile = vim.g.vimdir .. '/lazy-lock.json',
})


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
  pattern = { '*.js', '*.html', '*.css', '*.jsx', '*.lua', '*.vue', '*.vim' },
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
      if buf == 'COMMIT_EDITMSG' or buf == 'git-rebase-todo' then
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


-- COLOURSCHEMES ------------------------------------------------------------
require('gruvbox').setup({
  contrast = 'hard',
  overrides = {
    SignColumn = { link = "Normal" },
    GruvboxGreenSign = { bg = "" },
    GruvboxOrangeSign = { bg = "" },
    GruvboxPurpleSign = { bg = "" },
    GruvboxYellowSign = { bg = "" },
    GruvboxRedSign = { bg = "" },
    GruvboxBlueSign = { bg = "" },
    GruvboxAquaSign = { bg = "" },
  }
})
vim.opt.termguicolors = true
vim.o.background = 'dark'
vim.cmd.colorscheme('gruvbox')
vim.env.BAT_THEME = 'gruvbox-dark'


-- MAPPINGS ------------------------------------------------------------
local opts = { noremap = true, silent = true }

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
  ['<leader>ga']       = '<cmd>write | Git add %<CR>',
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
  ['<S-Up>']           = '<cmd>resize +5<CR>',
  ['<S-Down>']         = '<cmd>resize -5<CR>',
  ['<S-Left>']         = '<cmd>vertical resize +5<CR>',
  ['<S-Right>']        = '<cmd>vertical resize -5<CR>',
  -- leader number mappings
  ['<leader>0']        = ':silent set hlsearch! hlsearch?<CR>',
  ['<leader>1']        = '<cmd>RunTests 0<CR>',
  ['<leader>3']        = '<cmd>MarkdownPreviewToggle<CR>',
  ['<leader>4']        = '<cmd>lua vim.lsp.buf.format()<CR>',
  ['<leader>5']        = '<cmd>Neotree show toggle<CR>',
  ['<leader>8']        = '<cmd>AerialToggle!<CR>',
  -- terminal mappings
  ['<leader>t']        = '<cmd>startinsert | botright 15split | term<CR>',
  ['<leader>T']        = '<cmd>startinsert | botright vsplit | term<CR>',
  ['<leader>N']        = '<cmd>startinsert | tabe | term<CR>',
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
  ['<Leader>rh']       = '<cmd>RunToCursor<CR>',
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
  -- copilot
  ['<Leader>cp']       = '<cmd>Copilot panel<CR>',
  -- neotree
  ['<Leader>bb']       = '<cmd>Neotree toggle<CR>',
  ['<Leader>br']       = '<cmd>Neotree reveal<CR>',
}

local insert_mappings = {
  ['<C-j>'] = 'copilot#Accept("<CR>")',
  ['<C-k>'] = 'copilot#Next()',
}
local insert_opts = { noremap = true, silent = true, expr = true, replace_keycodes = false }

-- disable copilot tab mapping
vim.g.copilot_no_tab_map = true

set_key_map('n', normal_mappings, opts)
set_key_map('v', visual_mappings, opts)
set_key_map('t', terminal_mappings, opts)
set_key_map('i', insert_mappings, insert_opts)


local on_attach = function(_, bufnr)
  -- this is required so the LSP takes effect on all buffers
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local mappings = {
    ['<leader>lc'] = '<cmd>lua vim.lsp.buf.code_action()<CR>',
    ['<leader>ld'] = '<cmd>lua vim.lsp.buf.definition()<CR>',
    ['<leader>lf'] = '<cmd>lua vim.lsp.buf.references()<CR>',
    ['<leader>lh'] = '<cmd>lua vim.lsp.buf.hover()<CR>',
    ['<leader>ln'] = '<cmd>tab split | lua vim.lsp.buf.definition()<CR>',
    ['<leader>lr'] = '<cmd>lua vim.lsp.buf.rename()<CR>',
    ['<leader>ls'] = '<cmd>split | lua vim.lsp.buf.definition()<CR>',
    ['<leader>lv'] = '<cmd>vert split | lua vim.lsp.buf.definition()<CR>',
    ['<leader>lx'] = '<cmd>split | lua vim.lsp.buf.definition()<CR>',
    ['<leader>ll'] = '<cmd>LspRestart<CR>',
  }
  for map, func in pairs(mappings) do
    vim.api.nvim_buf_set_keymap(bufnr, 'n', map, func, opts)
  end
end


-- STATUSLINE ------------------------------------------------------------
require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'gruvbox-material',
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
      { 'filetype', icon_only = true, colored = false, color = 'lualine_c_normal' },
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
    lualine_z = { 'location' },
  },
  tabline = {
    lualine_a = {
      {
        'tabs',
        mode = 1,
        max_length = vim.o.columns,
        fmt = function(name, context)
          -- Show + if buffer is modified in tab
          local winnr = vim.fn.tabpagewinnr(context.tabnr)
          local bufnr = vim.fn.tabpagebuflist(context.tabnr)[winnr]
          return name .. (vim.fn.getbufvar(bufnr, '&mod') == 1 and ' +' or '')
        end
      },
    },
  },
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
  ensure_installed = {
    'pyright', 'bashls', 'tsserver', 'lua_ls', 'dockerls', 'vimls', 'yamlls'
  },
  automatic_installation = true,
}
-- autoinstall formatters and linters
mason_installer.setup {
  ensure_installed = {
    'black', 'flake8', 'isort', 'hadolint', 'prettier', 'shfmt', 'eslint_d',
    'vint', 'stylua', 'luacheck', 'shellharden', 'shellcheck', 'sqlfluff',
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
local sqlfluff = { extra_args = { '--dialect=postgres', '--exclude-rules=LT02,LT05' } }
local shfmt_config = { extra_args = { '-i', '4' } } -- use 4 spaces
null_ls.setup({
  sources = {
    d.hadolint, d.vint, d.flake8.with(flake8_config), d.sqlfluff.with(sqlfluff), d.eslint_d,
    f.black, f.isort, f.jq, f.shfmt.with(shfmt_config), f.sqlfluff.with(sqlfluff), f.shellharden,
    f.prettier
  }
})

-- automatically start each server when the corresponding filetype is opened
mason_lspconfig.setup_handlers({
  function(server_name)
    lspconfig[server_name].setup { on_attach = on_attach }
  end,
  -- provide targeted overrides for specific servers.
  ['lua_ls'] = function()
    lspconfig.lua_ls.setup {
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
  -- use kubernetes yaml for all?
  ['yamlls'] = function()
    lspconfig.yamlls.setup {
      settings = {
        yaml = {
          schemas = {
            kubernetes = { 'k8s/*.yaml', 'k8s/*.yml' },
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
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
}


-- TREESITTER ------------------------------------------------------------
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'c', 'lua', 'python', 'vim', 'yaml', 'markdown', 'ql', 'latex',
    'make', 'dockerfile', 'bash', 'javascript', 'json', 'html', 'css'
  },
  highlight = { enable = true, additional_vim_regex_highlighting = false },
}
