require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
 use {
  "folke/which-key.nvim",
  config = function()
    require("which-key").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  end
}
use 'karb94/neoscroll.nvim'
  use 'neovim/nvim-lspconfig'
  use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
  }
  use({
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
        local saga = require("lspsaga")

        saga.init_lsp_saga({
            -- your configuration
        
            --max_preview_lines = 30,
        })

        --vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
    end,
  })

    use {
      'rmagatti/goto-preview',
      config = function()
        require('goto-preview').setup {}
      end
    }
  --use 'jeffkreeftmeijer/neovim-sensible' 
  --use 'Mofiqul/vscode.nvim'
  use {
     'nvim-telescope/telescope.nvim', tag = '0.1.0',
     requires = { {'nvim-lua/plenary.nvim'} }  
  }

  use {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
    require"telescope".load_extension("frecency")
    end,
    requires = {"kkharji/sqlite.lua"}
  }

  
    use {
            'LukasPietzschmann/telescope-tabs',
            requires = { 'nvim-telescope/telescope.nvim' },
            config = function()
                    require'telescope-tabs'.setup{
                            -- Your custom config :^)
                    }
            end
    }


  use 'gennaro-tedesco/nvim-peekup'
  use 'RRethy/vim-illuminate'
  use({ "kelly-lin/telescope-ag", requires = { { "nvim-telescope/telescope.nvim" } } })
  --use 'marko-cerovac/material.nvim'
  use({
  'projekt0n/github-nvim-theme',
  config = function()
    require('github-theme').setup({
        theme_style = "dimmed",
        -- ...
    })
  end
  })

  use {"smartpde/telescope-recent-files"}
  use  "MattesGroeger/vim-bookmarks"
  use "tom-anders/telescope-vim-bookmarks.nvim"

  use 'nvim-tree/nvim-web-devicons'
  use {
    'nvim-tree/nvim-tree.lua',
     requires = {
        'nvim-tree/nvim-web-devicons', -- optional, for file icons
     }
  }
  use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'kyazdani42/nvim-web-devicons'}

  use {
     'jedrzejboczar/possession.nvim',
     requires = { 'nvim-lua/plenary.nvim' },
  }

  use {
    'goolord/alpha-nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
  }

  use "woosaaahh/sj.nvim"  

end)


-- lsp config
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local lsp_on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  --vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  --vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  --vim.keymap.set('n', '<space>wl', function()
  --print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  --end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr',"<cmd>lua require('goto-preview').goto_preview_references()<CR>" , bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)


end


require('lspconfig')['clangd'].setup{
    cmd = {"clangd","--background-index","-j=20"},
    on_attach = lsp_on_attach,

}
vim.lsp.set_log_level("debug")

--local saga = require('lspsaga')


-- lsp end

-- treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c" },
  

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = false,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {  },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

--[[
local c = require('vscode.colors')
require('vscode').setup({
    -- Enable transparent background
    transparent = false,

    -- Enable italic comment
    italic_comments = true,

    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,

    -- Override colors (see ./lua/vscode/colors.lua)
    color_overrides = {
        vscLineNumber = '#FFFFFF',
    },

    -- Override highlight groups (see ./lua/vscode/theme.lua)
    group_overrides = {
        -- this supports the same val table as vim.api.nvim_set_hl
        -- use colors from this colorscheme by requiring vscode.colors!
        Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
    }
})

--]]


-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', function() builtin.live_grep({grep_open_files=true}) end,{})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fs', builtin.grep_string, {})

vim.keymap.set('n', '<leader>fj', builtin.jumplist, {})
require('telescope').load_extension('vim_bookmarks')

vim.api.nvim_set_keymap("n", "<leader>fr", "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>", {noremap = true, silent = true})
-- telescope bookmarks

local telescope = require('telescope')
vim.keymap.set('n', '<leader>ma', "<Cmd>Telescope vim_bookmarks all<CR>" ,{})
vim.keymap.set('n', '<leader>mb', "<Cmd>Telescope vim_bookmarks current_file<CR>" ,{})
--vim.keymap.set('n', '<leader>ma', require('telescope').extensions.vim_bookmarks.all(), {})
--vim.keymap.set('n', '<leader>ma', telescope.extensions.vim_bookmarks.all(), {})
--vim.keymap.set('n', '<leader>mc', telescope.extensions.vim_bookmarks.current_file(), {})

require("telescope").load_extension("recent_files")
vim.api.nvim_set_keymap("n", "<Leader>fz",
  [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
  {noremap = true, silent = true})



-- NVIM-TREE

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

--NVIM_TREE--

vim.keymap.set('n', 'nv', '<CMD>NvimTreeToggle<CR>')

--Bufferline

vim.opt.termguicolors = true
require("bufferline").setup{}

vim.keymap.set('n', ']]', '<CMD>BufferLineCycleNext<CR>')
vim.keymap.set('n', '[[', '<CMD>BufferLineCyclePrev<CR>')
vim.keymap.set('n', 'bd', '<CMD>bd<CR>')

--BufferLine

-- Session
require('possession').setup {
    session_dir = os.getenv( "HOME" )..'/.vim_sessions' , 
    silent = false,
    load_silent = true,
    debug = false,
    prompt_no_cr = false,
    autosave = {
        current = true,  -- or fun(name): boolean
        tmp = false,  -- or fun(): boolean
        tmp_name = 'tmp',
        on_load = true,
        on_quit = true,
    },
    commands = {
        save = 'PossessionSave',
        load = 'PossessionLoad',
        close = 'PossessionClose',
        delete = 'PossessionDelete',
        show = 'PossessionShow',
        list = 'PossessionList',
        migrate = 'PossessionMigrate',
    },
    hooks = {
        before_save = function(name) return {} end,
        after_save = function(name, user_data, aborted) end,
        before_load = function(name, user_data) return user_data end,
        after_load = function(name, user_data) end,
    },
    plugins = {
        close_windows = {
            hooks = {'before_save', 'before_load'},
            preserve_layout = true,  -- or fun(win): boolean
            match = {
                floating = true,
                buftype = {},
                filetype = {},
                custom = false,  -- or fun(win): boolean
            },
        },
        delete_hidden_buffers = {
            hooks = {
                'before_load',
                vim.o.sessionoptions:match('buffer') and 'before_save',
            },
            force = false,  -- or fun(buf): boolean
        },
        nvim_tree = true,
        tabby = true,
        delete_buffers = false,
    },

}
require('telescope').load_extension('possession')
-- End Session\

-- alpha

local query = require('possession.query')
local dashboard = require("alpha.themes.dashboard")
local startify = require("alpha.themes.startify")

local workspaces = {
    

}

local create_button = function(sc, text, keymap)
    return startify.button(sc,text,keymap)
end



local config = {
    layout = query.alpha_workspace_layout(workspaces, create_button, {
        sessions = sessions, 
        others_name = 'sessions',
    })
}


require'alpha'.setup(config)

--
--1
--2
--3

local sj = require("sj")
sj.setup()
vim.keymap.set("n", "s", sj.run)
--vim.keymap.set("n", "A-.", sj.prev_match)
--vim.keymap.set("n", "A-,", sj.next_match)
vim.keymap.set("n", "<localleader>s", sj.redo)


require('neoscroll').setup()
