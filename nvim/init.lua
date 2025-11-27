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
    		'nvim-telescope/telescope.nvim', tag = 'v0.1.9',
     		dependencies = { 'nvim-lua/plenary.nvim' },
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
          { desc = '󰉋 Files', group = 'Label', key = 'f', action = 'NvimTreeToggle' },
          { desc = '󰭎 Search',  group = 'Label', key = 'g', action = 'Telescope live_grep' },
		{ desc = '󰝒 New', group = 'Label', key = 'n', action = 'tabnew' },
		{ desc = '󰯉 Zsh', group = 'Label', key = 't', action = 'term'},
		{ desc = '󰲶 Config', group = 'Label', key = 'e', action = 'e ~/.config/nvim/init.lua'},
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
    opts = {},
  },

{ "sitiom/nvim-numbertoggle", name="numbertoggle"},

  
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  --install = { colorscheme = { "rose-pine" } },
  -- automatically check for plugin updates
  checker = { enabled = true },

})

-- Use system clipboard, makes my life easier
vim.opt.clipboard = "unnamedplus"

-- Set rose-pine as our color scheme because I love it <3
vim.cmd.colorscheme("rose-pine")

-- Some keybinds ^w^

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set({"n","v"}, "<leader>n", ":NvimTreeToggle<CR>", { desc = "Toggle explorer" })
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
