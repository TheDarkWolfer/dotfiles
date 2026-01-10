local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Function to handle my notes better, by letting me pick which
-- note subfolder to focus on

local function cd_notes_subfolder()
  require('telescope.builtin').find_files({
    prompt_title = 'Notes folders',
    cwd = '~/Notes',
    find_command = {
      'find',
      '.',
      '-maxdepth', '1',
      '-type', 'd',
      '!',
      '-name', '.',
    },
  })
end

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- vim.wo.relativenumber = true
vim.opt.number = true
vim.opt.relativenumber = true

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
	{"rose-pine/neovim", name = "rose-pine" },
	{"jbyuki/venn.nvim", name = "venn"},
	{
			'nguyenvukhang/nvim-toggler', 
			name = "toggler",
			opts = {
				inverses = {
					[ "left" ] = "right",
				}
			}
		},
	{
    		'nvim-telescope/telescope.nvim', tag = 'v0.1.9',
     		dependencies = { 'nvim-lua/plenary.nvim' },
				event = "VimEnter",
		keys = {
			{"<leader>ff","<cmd>Telescope find_files<CR>",mode = {"v","n"}},
			{"<leader>Fg","<cmd>Telescope live_grep<CR>",mode = {"v","n"}},
			{"<leader>fG","<cmd>Telescope git_files<CR>",mode = {"v","n"}},
			{"<leader>fb","<cmd>Telescope buffers<CR>",mode = {"v","n"}},
			{"<leader>fc","<cmd>Telescope commands<CR>",mode = {"v","n"}},
		}
    	},	
{
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup({
      theme = 'hyper',        -- or 'doom'
      config = {
	project = { enable = false },
	mru = { enable = false },
	packages = { enable = false },
        header = {
' ▄█       ▄██   ▄    ▄████████  ▄██████▄     ▄████████  ▄█     ▄████████ ',
'███       ███   ██▄ ███    ███ ███    ███   ███    ███ ███    ███    ███ ',
'███       ███▄▄▄███ ███    █▀  ███    ███   ███    ███ ███▌   ███    █▀  ',
'███       ▀▀▀▀▀▀███ ███        ███    ███  ▄███▄▄▄▄██▀ ███▌   ███        ',
'███       ▄██   ███ ███        ███    ███ ▀▀███▀▀▀▀▀   ███▌ ▀███████████ ',
'███       ███   ███ ███    █▄  ███    ███ ▀███████████ ███           ███ ',
'███▌    ▄ ███   ███ ███    ███ ███    ███   ███    ███ ███     ▄█    ███ ',
'█████▄▄██  ▀█████▀  ████████▀   ▀██████▀    ███    ███ █▀    ▄████████▀  ',
'▀                                           ███    ███                   ',
							'',
        },
        shortcut = {
          { desc = '󰉋 Files ', group = 'Label', key = 'f', action = 'NvimTreeToggle' },
          { desc = '󰭎 Search ',  group = 'Label', key = 'g', action = 'Telescope live_grep' },
		{ desc = '󰝒 New ', group = 'Label', key = 'e', action = 'tabnew' },
		{ desc = '󰯉 Zsh ', group = 'Label', key = 't', action = 'term'},
		--{ desc = ' Notes', group = 'Label', key = 'n', action = function() vim.cmd("cd ~/Notes/")	vim.cmd("Telescope find_files")	end,},
							{ desc = '󰲶 Notes ', group = 'Label', key = 'n', action = cd_notes_subfolder, },
		{ desc = ' Config ', group = 'Label', key = 'c', action = 'e ~/.config/nvim/init.lua'},
        },

        footer = {'', '╭───────────────────────╮',' Prefiero morir de pie ',' que vivir en rodillas ','╰───────────────────────╯',' ⚝ ' },
      },
    })
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons' }
},
	{
  		"necrom4/convy.nvim",
  		cmd = { "Convy", "ConvySeparator" },
		opts = {},
		keys = {
			{"<leader>ca","<cmd>Convy auto ascii<CR>", mode = {"n", "v"}},
			{"<leader>cm","<cmd>Convy auto morse<CR>", mode = {"n","v"}},
			{"<leader>cb","<cmd>Convy auto bin<CR>", mode = {"n", "v"}},
			{"<leader>ch","<cmd>Convy auto hex<CR>", mode = {"n", "v"}},
			{"<leader>C","<cmd>Convy<CR>", mode = {"n","v"}},
		}
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function() 
				require('lualine').setup {
					options = {
						icons_enabled = true,
    						theme = 'rose-pine',
    						component_separators = { left = '', right = ''},
    						section_separators = { left = ' ', right = ' '},
    					disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
      refresh_time = 16, -- ~60fps
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
      },
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {'filename','lsp_status'},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
		end	    
	},
	
	{
		'romgrk/barbar.nvim',
  		dependencies = {
    		'lewis6991/gitsigns.nvim',        -- OPTIONAL: git status
    		'nvim-tree/nvim-web-devicons',    -- OPTIONAL: file icons
  	},
  	init = function()
    		vim.g.barbar_auto_setup = false   -- we’ll call setup ourselves
  	end,
  	config = function()
    		require('barbar').setup({
      			-- put your options here if you want, or leave empty
    			})
  	end,
  	version = '^1.0.0',
	},
	{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- "maintained" is deprecated, use "all" or a list:
        -- ensure_installed = "all",
        ensure_installed = { "lua", "vim", "bash", "python", "javascript" },

        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },

	{
		"folke/twilight.nvim",
  		opts = {
	    -- your configuration comes here
	    -- or leave it empty to use the default settings
	    -- refer to the configuration section below
  		}
	},
	{
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({})
  end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
				bullet = {
					icons = { 
						'', '', '', ''
				},
			},
				link = {
					email = " "
				},
				heading = {
					sign = false,
					position = 'inline',
					width = 'full',
				},
				anti_conceal = {
					enabled = false
				},
				quote = { repeat_linebreak = true },
				callout = {
					note      = { raw = '[!NOTE]',      rendered = '󰋽 Note',      highlight = 'RenderMarkdownInfo',    category = 'github'   },
					sources = { raw = '[!SOURCE]', rendered = ' Source', highlight = 'RendererMarkdownQuote',},
				}
			},
  },

{ "sitiom/nvim-numbertoggle", name="numbertoggle"},
{
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },

  -- use a release tag to download pre-built binaries
  version = '1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { 
					preset = 'default',
					[ "<C-z>" ] = { 'accept_and_enter' },
					[ "<C-h>" ] = { 'hide_documentation' },
				},

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = { documentation = { auto_show = true } },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" }
  },
  opts_extend = { "sources.default" }
},
{
    "m4xshen/autoclose.nvim",
    event = "InsertEnter",
    config = function()
      require("autoclose").setup()
    end,
  },
  
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  --install = { colorscheme = { "rose-pine" } },
  -- automatically check for plugin updates
  checker = { enabled = false , notify = false},

})

-- Use system clipboard, makes my life easier
vim.opt.clipboard = "unnamedplus"

-- Amount of spaces for a tabulation
vim.opt.tabstop = 2      -- how many spaces a TAB shows as
vim.opt.shiftwidth = 2   -- indentation size
vim.opt.softtabstop = 2  -- number of spaces inserted when pressing TAB
vim.opt.expandtab = false

-- Set rose-pine as our color scheme because I love it <3
vim.cmd.colorscheme("rose-pine")

-- Some keybinds ^w^

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set({ 'n', 'v' }, '<leader>v', require('nvim-toggler').toggle)

vim.keymap.set({"n","v"}, "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle explorer" })
vim.keymap.set({"n","v"}, "<leader>t", ":Twilight<CR>", { desc = "Toggle twilight"})
vim.keymap.set({"n","v"}, ";", ":", { noremap = true })

-- Save keybinds because I still like the dramatic feel of Ctrl+S on a finished project :p
vim.keymap.set({"n","v"}, "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set({"n","v"}, "<C-s>", ":w<CR>", { desc = "Save file (similar to other editors)" })

-- Buffers stuff
vim.keymap.set({"n","v"}, "<Tab>", ":BufferNext<CR>", { desc = "Next buffer"})
vim.keymap.set({"n","v"}, "<leader>l", ":BufferNext<CR>", { desc = "Next buffer"})
vim.keymap.set({"n","v"}, "<S-Tab>", ":BufferPrevious<CR>", { desc = "Previous buffer"})
vim.keymap.set({"n","v"}, "<leader>h", ":BufferPrevious<CR>", { desc = "Previous buffer"})
vim.keymap.set({"n","v"}, "<leader>x", ":BufferClose<CR>", { desc = "Close buffer"})
vim.keymap.set("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New empty buffer" })

vim.keymap.set({"n","v"}, "<leader>j", ":BufferMovePrevious<CR>", { desc = "Move buffer to the left"})
vim.keymap.set({"n","v"}, "<leader>k", ":BufferMoveNext<CR>", { desc = "Move buffer to the right"})

-- You'd be surprised how often I forget how to exit the damned terminal lol
vim.keymap.set("t", "<C-x>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- A small(ish) notes thingy
-- Since we're writing a config in lua, might as well take
-- advantage of the fact that it's code, y'know 
-- Helper function
local function get_vaults(root)
  root = vim.fn.expand(root)
  local vaults = {}

  -- list entries in the root folder
  local entries = vim.fn.readdir(root)
  for _, name in ipairs(entries) do
    local path = root .. "/" .. name
    if vim.fn.isdirectory(path) == 1 then
      table.insert(vaults, path)
    end
  end

  return vaults
end


vim.keymap.set("n", "<leader>n", function()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local builtin = require("telescope.builtin")

  local vaults = get_vaults("~/Notes/")

  pickers.new({}, {
    prompt_title = "Select Notes Folder",
    finder = finders.new_table(vaults),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<CR>", function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        local dir = entry[1]

        -- now open the combined picker for this directory
        builtin.find_files({
          prompt_title = "Notes (" .. dir .. ")",
          cwd = dir,
          attach_mappings = function(pbuf, map2)
            map2("i", "<CR>", function()
              local e = action_state.get_selected_entry()
              local input = action_state.get_current_line()
              actions.close(pbuf)

              local filename
              if e then
                filename = e.path
              else
                filename = vim.fn.expand(dir .. "/" .. input .. ".md")
              end
              vim.cmd("edit " .. filename)
            end)
            return true
          end,
        })
      end)
      return true
    end
  }):find()
end)

-- New timestamped note 
local function new_timestamped_note()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" then
    dir = vim.fn.getcwd()
  end

  local name = os.date("%Y-%m-%d_%H-%M-%S.md")
  local path = dir .. "/" .. name

  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

-- Keymap
vim.keymap.set("n", "<leader>nt", new_timestamped_note, {
  desc = "New timestamped note in current directory"
})

vim.api.nvim_create_user_command("NewTimestampedNote", new_timestamped_note, {})
