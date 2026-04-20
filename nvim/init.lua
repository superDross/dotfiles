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
vim.o.thesaurus = '~/.vim/thesaurus.txt' -- Ctrl-x,Ctrl-t
vim.o.mouse = ""
vim.o.sessionoptions = 'buffers,curdir,help,tabpages,terminal,winsize,globals'
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.conceallevel = 2            -- hide markdown formatting
vim.opt.fillchars = { eob = " " } -- prevent ~ at end of file
vim.g.vimrc = vim.fn.resolve(vim.fn.expand('<sfile>:p'))
vim.g.vimdir = vim.fn.fnamemodify(vim.g.vimrc, ':h')
vim.o.runtimepath = vim.g.vimdir .. ',' .. vim.o.runtimepath -- add vimrc directory to runtimepath
vim.g.mapleader = ' '
vim.opt.spellfile = vim.g.vimdir .. '/spell/en.utf-8.add'
vim.opt.winborder = "rounded"
vim.opt.pumborder = "rounded"
vim.opt.pummaxwidth = 60
vim.opt.pumheight = 20


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
  { 'williamboman/mason.nvim',         config = function() require('mason').setup() end },
  'williamboman/mason-lspconfig.nvim',
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  'mfussenegger/nvim-lint',
  'stevearc/conform.nvim',
  {
	  'nvim-treesitter/nvim-treesitter',
	  lazy = false,
	  build = ':TSUpdate',
	  config = function()
	  	local parsers = {
        'c', 'lua', 'python', 'vim', 'yaml', 'markdown', 'ql',
        'make', 'dockerfile', 'bash', 'javascript', 'json', 'html', 'css'
	  	}
	  	require('nvim-treesitter').install(parsers)
    end,
  },
  -- AI
  {
    'github/copilot.vim',
    init = function()
      vim.g.copilot_filetypes = { markdown = false, tex = false, text = false, codecompanion = false }
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_enabled = false
    end
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'ravitemer/codecompanion-history.nvim',
    },
    config = true
  },
  -- completion
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  'saadparwaiz1/cmp_luasnip',
  'hrsh7th/cmp-nvim-lua',
  'f3fora/cmp-spell',
  -- snippets
  'L3MON4D3/LuaSnip',
  -- colorschemes
  { 'ellisonleao/gruvbox.nvim', priority = 1000 },
  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      filesystem = {
        filtered_items = {
          always_show = { '.github', '.gitlab-ci.yml', '.nexus' }
        }
      }
    }
  },
  -- text object extensions
  'machakann/vim-sandwich',
  -- git enhancers
  {
    'tpope/vim-fugitive',
    init = function()
      -- disable cc commit mapping, causes git hooks to execute and potentially wipe out changes not staged!!!
      vim.g.nremap = { ['<nomap>'] = 'cc', ['cc'] = '<nomap>' }
    end
  },
  'tpope/vim-rhubarb',
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },
  'sindrets/diffview.nvim',
  -- file searcher
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      grep = {
        -- same as fzf-lua defaults but shows hidden files not in the gitignore file
        rg_opts =
        "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden -g '!.git' -e ",
      },
    },
  },
  -- statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true }
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
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons'
    }
  },
  'masukomi/vim-markdown-folding',
  -- code symbols
  { 'stevearc/aerial.nvim',     config = function() require('aerial').setup() end },
  -- personal plugins
  {
    'superDross/ticket.vim',
    priority = 500,
    init = function()
      vim.g.auto_ticket_open = 1
      vim.g.auto_ticket_git_only = 1
      vim.g.ticket_black_list = { 'main', 'master' }
      vim.g.ticket_use_fzf_default = 1
      vim.g.ticket_very_verbose = 1
      vim.g.ticket_overwrite_confirm = 1
    end,
    -- dev = true
  },
  {
    'superDross/picobook',
    init = function()
      vim.g.notesdir = '~/bin/piconotes/'
      vim.g.noteurl = 'https://github.com/superDross/piconotes/blob/main/'
    end,
    -- dev = true
  },
  {
    'superDross/run-with-me.vim',
    init = function()
      vim.g.default_testing_cmd = 'make test'
      vim.g.runner_cmds = {
        python = "python3",
        javascript = "node",
        vim = "vim -N -u NONE -n -c 'set nomore' -S",
        tex = "pdflatex",
        lua = "nvim -l",
        go = "go run",
      }
    end
  },
  {
    'superDross/scrappy.vim',
    init = function()
      vim.g.scrappy_use_fzf_default = 1
    end,
    -- dev = true
  },
  {
    'superDross/spellbound.nvim',
    init = function()
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

-- Builtin plugins
vim.cmd("packadd nvim.undotree")
vim.cmd("packadd nvim.difftool")
require('vim._core.ui2').enable({})

-- AUTOCOMMANDS ------------------------------------------------------------
-- highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.hl.on_yank { timeout = 500 } end,
})
-- make neovim terminal more like vim terminal & disable line numbering in terminal mode
local vim_term = vim.api.nvim_create_augroup('vim_term', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
  end,
  group = vim_term
})
-- ensure vader files are treated as vim files
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.vader',
  command = 'set filetype=vim',
})
-- indentation spacing
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = {
    '*.js', '*.ts', '*.html', '*.css', '*.jsx', '*.tsx', '*.lua', '*.vue', '*.vim', '*.sh', '*bashrc', '*.vader',
  },
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
-- copilot toggle (assumes 'disable' is the default state)
vim.api.nvim_create_user_command('CopilotToggle', function()
    copilot_on = not copilot_on
    vim.cmd('Copilot ' .. (copilot_on and 'enable' or 'disable'))
    print('Copilot ' .. (copilot_on and 'ON' or 'OFF'))
end, { nargs = 0 })
-- ensure we check if file has changed
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "checktime",
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
    NormalFloat = { link = "Normal" },
    FloatBorder = { link = "Normal" },
    FloatTitle = { link = "Normal" },
    Pmenu = { link = "Normal" },
  }
})
vim.opt.termguicolors = true
vim.o.background = 'dark'
vim.cmd.colorscheme('gruvbox')
vim.env.BAT_THEME = 'gruvbox-dark'
vim.api.nvim_set_hl(0, 'SpellBad', { undercurl = true, italic = true, sp = 'red' })


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
  ['<Leader>cc'] = '<cmd>CodeCompanion<CR>',
  ['<Leader>ca'] = '<cmd>CodeCompanionActions<CR>',
}

local normal_mappings = {
  -- folding
  ['<leader><leader>'] = 'za',
  -- clipboard
  ['<leader>y']        = '"+y',
  ['<leader>p']        = '"+p',
  -- undo mappings
  ['<leader>u']        = '<cmd>Undotree<CR>',
  -- git mappings
  ['<leader>ga']       = '<cmd>write | Git add %<CR>',
  ['<leader>gb']       = '<cmd>Git blame<CR>',
  ['<leader>gc']       = '<cmd>Git commit -n<CR>',
  ['<leader>gd']       = '<cmd>Git diff %<CR>',
  ['<leader>gg']       = '<cmd>Git<CR>',
  ['<leader>gi']       = '<cmd>GBrowse<CR>',
  ['<leader>gl']       = '<cmd>Git log<CR>',
  ['<leader>gm']       = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
  ['<leader>gs']       = '<cmd>Git status<CR>',
  ['<leader>do']       = '<cmd>DiffviewOpen<CR>',
  ['<leader>dc']       = '<cmd>DiffviewClose<CR>',
  ['<leader>dh']       = '<cmd>DiffviewFileHistory<CR>',
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
  ['<leader>2']        = '<cmd>Markview toggle<CR>',
  ['<leader>3']        = '<cmd>MarkdownPreviewToggle<CR>',
  ['<leader>4']        = '<cmd>lua require("conform").format({ lsp_fallback = true })<CR>',
  ['<leader>5']        = '<cmd>Neotree show toggle<CR>',
  ['<leader>8']        = '<cmd>AerialToggle!<CR>',
  -- terminal mappings
  ['<leader>t']        = '<cmd>startinsert | botright 15split | term<CR>',
  ['<leader>T']        = '<cmd>startinsert | botright vsplit | term<CR>',
  ['<leader>N']        = '<cmd>startinsert | tabe | term<CR>',
  -- diagnostics
  ['<leader>e']        = '<cmd>lua vim.diagnostic.open_float()<CR>',
  ['<leader>j']        = '<cmd>lua vim.diagnostic.jump({count=1, float=true})<CR>',
  ['<leader>k']        = '<cmd>lua vim.diagnostic.jump({count=-1, float=true})<CR>',
  ['<leader>q']        = '<cmd>lua vim.diagnostic.setloclist()<CR>',
  -- FZF
  ['<Leader>f*']       = "<cmd>FzfLua grep_cword previewer=bat git_icons=false file_icons=false<CR>",
  ['<Leader>f`']       = '<cmd>FzfLua marks<CR>',
  ['<Leader>fa']       = '<cmd>FzfLua live_grep resume=true previewer=bat git_icons=false file_icons=false<CR>',
  ['<Leader>fb']       = '<cmd>FzfLua buffers<CR>',
  ['<Leader>fc']       = '<cmd>FzfLua git_commits<CR>',
  ['<Leader>fd']       = '<cmd>FzfLua git_status<CR>',
  ['<Leader>fg']       = '<cmd>FzfLua live_grep_native previewer=bat git_icons=false file_icons=false<CR>',
  ['<Leader>fn']       = '<cmd>GrepNotes<CR>',
  ['<Leader>fs']       = '<cmd>FindSessions<CR>',
  ['<leader>ff']       = '<cmd>FzfLua files previewer=bat git_icons=false file_icons=false<CR>',
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
  -- copilot/ai
  ['<Leader>cp']       = '<cmd>Copilot panel<CR>',
  ['<leader>co']       = ':CopilotToggle<CR>',
  ['<Leader>cc']       = '<cmd>CodeCompanion<CR>',
  ['<Leader>ca']       = '<cmd>CodeCompanionActions<CR>',
  ['<Leader>ct']       = '<cmd>CodeCompanionChat Toggle<CR>',
  ['<Leader>cm']       = ':CodeCompanionCmd ',
  ['<Leader>ch']       = ':CodeCompanionHistory<CR>',
  ['<Leader>cd']       = ':CodeCompanionSummaries<CR>',
  -- <leader>cs save chat
  -- neotree
  ['<Leader>bb']       = '<cmd>Neotree toggle<CR>',
  ['<Leader>br']       = '<cmd>Neotree reveal<CR>',
}

local insert_mappings = {
  ['<C-j>'] = 'copilot#Accept("<CR>")',
  ['<C-k>'] = 'copilot#Next()',
}
local insert_opts = { noremap = true, silent = true, expr = true, replace_keycodes = false }

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
    ['<leader>lt'] = '<cmd>tab split | lua vim.lsp.buf.definition()<CR>',
    ['<leader>lr'] = '<cmd>lua vim.lsp.buf.rename()<CR>',
    ['<leader>ls'] = '<cmd>split | lua vim.lsp.buf.definition()<CR>',
    ['<leader>lv'] = '<cmd>vert split | lua vim.lsp.buf.definition()<CR>',
    ['<leader>lx'] = '<cmd>split | lua vim.lsp.buf.definition()<CR>',
    ['<leader>ll'] = '<cmd>LspRestart<CR>',
    ['<leader>li'] = '<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>',
    ['<leader>lz'] = '<cmd>lua vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })<CR>',
  }
  for map, func in pairs(mappings) do
    vim.api.nvim_buf_set_keymap(bufnr, 'n', map, func, opts)
  end
end


-- COPILOT/AI ---------------------------------------------------------------
require('codecompanion').setup({
  extensions = {
    history = {
      enabled = true,
      opts = {
        save_chat_keymap = '<leader>cs',
        picker = 'fzf-lua',
        auto_save = false,
        expiration_days = 180,
      },
    }
  },
  interactions = {
    inline = { adapter = 'copilot' },
    chat = {
      opts = {
        completion_provider = 'cmp'
      },
      adapter = {
        name ='copilot',
        model = 'gpt-4.1',
      },
      slash_commands = {
        ['buffer'] = { opts = { provider = 'fzf_lua' } },
        ['help'] = { opts = { provider = 'fzf_lua' } },
        ['file'] = { opts = { provider = 'fzf_lua' } },
        ['symbols'] = { opts = { provider = 'fzf_lua' } },
      }
    }
  }
})


-- MARKDOWN --------------------------------------------------------------
require('markview').setup({
  code_blocks = { style = 'simple' },
  preview = {
    modes = { 'n', 'i', 'no' },
    filetypes = { 'markdown', 'md', 'rmd', 'codecompanion' },
    ignore_buftypes = {},
  }
})


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
    lualine_z = { { 'lsp_status', ignore_lsp = { "GitHub Copilot", "harper_ls" } } },
  },
})


-- LSP ------------------------------------------------------------
-- automatically start each server when the corresponding filetype is opened
local mason_lspconfig = require('mason-lspconfig')
-- autoinstall LSP
mason_lspconfig.setup {
  ensure_installed = {
    'basedpyright', 'ruff', 'bashls', 'ts_ls', 'lua_ls', 'dockerls', 'vimls', 'yamlls', 'jsonls',
    'harper_ls', 'marksman',
  },
  automatic_installation = true,
}
-- auto install formatters and linters
require('mason-tool-installer').setup {
  ensure_installed = {
    'hadolint', 'prettier', 'shfmt',
    'vint', 'stylua', 'luacheck', 'shellharden', 'shellcheck', 'sqlfluff',
  },
}

-- set up linters
local sqlfluff = require('lint').linters.sqlfluff
sqlfluff.args = { 'lint', '--dialect=postgres', '--exclude-rules=LT02,LT05', '--format=json', '-' }

require('lint').linters_by_ft = {
  dockerfile = { 'hadolint' },
  vim = { 'vint' },
  vader = { 'vint' },
  sql = { 'sqlfluff' },
  sh = { 'shellcheck' },
  lua = { 'luacheck' },
}
vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
  callback = function() require('lint').try_lint() end,
})

-- set up formatters
require('conform').setup({
  formatters = {
    sqlfluff = {
      args = { 'format', '--dialect=postgres', '--exclude-rules=LT02,LT05', '-' },
    },
  },
  formatters_by_ft = {
    python = { 'ruff_format' },
    sh = { 'shfmt', 'shellharden' },
    sql = { 'sqlfluff' },
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    html = { 'prettier' },
    css = { 'prettier' },
    json = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
    lua = { 'stylua' },
  },
  format_on_save = false,
})

-- global default: apply on_attach to all servers
vim.lsp.config('*', {
  on_attach = on_attach,
})

-- server-specific overrides
vim.lsp.config('ruff', {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
  end,
  init_options = {
    settings = {
      lineLength = 120,
      lint = { select = { "E", "F", "C", "W", "R" } },
    }
  }
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      diagnostics = { globals = { 'vim' } },
    }
  }
})

vim.lsp.config('ltex', {
  filetypes = { 'tex' },
})

vim.lsp.config('postgres_lsp', {
  workspace_required = false,
})

vim.lsp.config('yamlls', {
  settings = {
    yaml = { schemas = { kubernetes = { 'k8s/*.yaml', 'k8s/*.yml' } } }
  }
})

vim.lsp.config('harper_ls', {
  filetypes = { 'markdown', 'text' },
  settings = {
    ["harper-ls"] = {
      linters = {
        SpellCheck = false,
      }
    }
  }
})

-- enable all servers
vim.lsp.enable(mason_lspconfig.get_installed_servers())

-- Change diagnostic symbols and virtual text
vim.diagnostic.config({
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '>>',
      [vim.diagnostic.severity.WARN] = '--',
      [vim.diagnostic.severity.INFO] = 'ℹ',
      [vim.diagnostic.severity.HINT] = '?',
    },
  },
})


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
    { name = 'nvim_lua' },
    { name = 'spell', option = {
      keep_all_entries = false,
      enable_in_context = function()
        return true
      end,
    } },
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
}


-- UI ---------------------------------------------------------------------
require('fzf-lua').register_ui_select()
