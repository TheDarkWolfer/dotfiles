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

-- Function to treat files with a name in all caps as markdown files (I usually don't add file extensions 
-- to my markdown files, so I kinda needed that little tweak)
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"},{
	callback = function(args)
		local name = vim.fn.fnamemodify(args.file, ":t")

		if not name:find("%.") and name:match("^[A-Z0-9_]+$") then
			vim.bo[args.buf].filetype = "markdown"
		end
	end,
})
-- In the same spirit, a few filetype associations that aren't automatic
vim.filetype.add({
  extension = {
    tsx = "typescriptreact",
    ts  = "typescript",
  },
})



-- Keep selection when indenting in Visual mode
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })

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
	{
	  "jbyuki/venn.nvim",
	},
	  {
	  "3rd/image.nvim",
	  build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
	  opts = {
	      processor = "magick_cli",
	  }
	},

    { "elentok/encrypt.nvim", opts = {} },


    {
      "nvim-telekasten/telekasten.nvim",
      dependencies = { "nvim-telescope/telescope.nvim" },
      config = function()
	require("telekasten").setup({
	  home = vim.fn.expand("~/Notes"),

	  -- Optional but nice:
	  auto_set_filetype = false,
	  dailies = vim.fn.expand("~/Notes/daily"),
	  weeklies = vim.fn.expand("~/Notes/weekly"),
	  templates = vim.fn.expand("~/Notes/templates"),
	})
      end,
    },

    {
			'nguyenvukhang/nvim-toggler', 
			name = "toggler",
			opts = {
				inverses = {
					[ "left" ] = "right",
					[ "true" ] = "false",
					[ "True" ] = "False",
					[ "╭" ] = "┌",
					[ "╮" ] = "┐",
					[ "╰" ] = "└",
					[ "╯" ] = "┘",
				}
			}
		},

	{
	  "rachartier/tiny-glimmer.nvim",
	  event = "VeryLazy",
	  priority = 10, -- Low priority to catch other plugins' keybindings
	  config = function()
	      require("tiny-glimmer").setup()
	  end,
	},

	{
	  "folke/which-key.nvim",
	  event = "VeryLazy",
	  opts = {
	    -- your configuration comes here
	    -- or leave it empty to use the default settings
	    -- refer to the configuration section below
	  },
	  keys = {
	    {
	      "<leader>?",
	      function()
		require("which-key").show({ global = false })
	      end,
	      desc = "Buffer Local Keymaps (which-key)",
	    },
	  },
	},

	{
	"rcarriga/nvim-notify",
	-- optional: only load when first used
	-- lazy = true,
	config = function()
	  local notify = require("notify")

	  notify.setup({
	    -- a few common options (all optional):
	    -- render = "minimal",
	    -- stages = "fade_in_slide_out",
	    -- timeout = 2000,
	    -- background_colour = "#000000",
	  })

	      -- Make Neovim use nvim-notify for vim.notify()
	    vim.notify = notify
	  end,
	},

	{
	    'numToStr/Comment.nvim',
	    opts = {
	      ---Add a space b/w comment and the line
	      padding = true,
	      ---Whether the cursor should stay at its position
	      sticky = true,
	      ---Lines to be ignored while (un)comment
	      ignore = nil,
	      ---LHS of toggle mappings in NORMAL mode
	      toggler = {
		  ---Line-comment toggle keymap
		  line = 'gcc',
		  ---Block-comment toggle keymap
		  block = 'gbc',
	      },
	      ---LHS of operator-pending mappings in NORMAL and VISUAL mode
	      opleader = {
		  ---Line-comment keymap
		  line = 'gc',
		  ---Block-comment keymap
		  block = 'gb',
	      },
	      ---LHS of extra mappings
	      extra = {
		  ---Add comment on the line above
		  above = 'gcO',
		  ---Add comment on the line below
		  below = 'gco',
		  ---Add comment at the end of line
		  eol = 'gcA',
	      },
	      ---Enable keybindings
	      ---NOTE: If given `false` then the plugin won't create any mappings
	      mappings = {
		  ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
		  basic = true,
		  ---Extra mapping; `gco`, `gcO`, `gcA`
		  extra = false
	      },
	      ---Function to call before (un)comment
	      pre_hook = nil,
	      ---Function to call after (un)comment
	      post_hook = nil,
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
	mru = { enable = false, limit = 7, icon = ' ' },
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
	    
	-- header = {
 --              '  ▄▄▄                                ',
	--       ' ▀██▀                        ▀▀      ',
	--       '  ██  ██ ██ ▄███▀ ▄███▄ ████▄██ ▄██▀█',
	--       '  ██  ██▄██ ██    ██ ██ ██   ██ ▀███▄',
	--       ' ████▄▄▀██▀▄▀███▄▄▀███▀▄█▀  ▄███▄▄██▀',
	--       '        ██                           ',
	--       '      ▀▀▀                            ',
	--     }, 
	             
        shortcut = {
          { desc = '󰉋 Files ', group = 'Label', key = 'f', action = 'Telescope find_files' },
	  { desc = ' Notes', group = 'label', key = 'n', action = "Telekasten find_notes" },
          --{ desc = '󰭎 Search ',  group = 'Label', key = 'g', action = 'Telescope live_grep' },
	  --{ desc = '󰝒 New ', group = 'Label', key = 'e', action = 'tabnew' },
	  --{ desc = '󰯉 Zsh ', group = 'Label', key = 't', action = 'term'},
	  { desc = ' Config ', group = 'Label', key = 'c', action = 'e $MYVIMRC'},
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
    						section_separators = { left = ' ', right = ' '},
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
					email = " ",
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
					sources = { raw = '[!SOURCE]', rendered = ' Source', highlight = 'RendererMarkdownQuote', category = 'github'},
					client = { raw = '[!CLIENT]', rendered = ' Client', highlight = 'RenderMarkdownLink', category = 'github'},
					presta = { raw = '[!PRESTA]', rendered = ' PRESTA', highlight = 'RenderMarkdownSuccess', category = 'github'},
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
  "RRethy/vim-hexokinase",
  build = "make hexokinase",
  config = function()
    vim.g.Hexokinase_highlighters = {
      "virtual", -- Show colors in virtual text
      "background", -- Highlight background
    }
  end,
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

-- Disable blink.cmp in markdown files
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*.md',
  callback = function()
    vim.b.completion = false
  end,
})

-- Amount of spaces for a tabulation
vim.opt.tabstop = 8 -- Always 8 (see :h tabstop)
vim.opt.softtabstop = 2 -- What you expecting
vim.opt.shiftwidth = 2

-- For venn.nvim - making my life easier
vim.opt.ve = "all"
vim.keymap.set("v","<leader>vf",":VBox<CR>",{desc="Draw box around selection"})

vim.keymap.set("v", "H", "<C-v>h:VBox<CR>", { noremap = true })
vim.keymap.set("v", "J", "<C-v>j:VBox<CR>", { noremap = true })
vim.keymap.set("v", "K", "<C-v>k:VBox<CR>", { noremap = true })
vim.keymap.set("v", "L", "<C-v>l:VBox<CR>", { noremap = true })

-- Make it a crosshair via highlighting
vim.api.nvim_set_hl(0, "Cursor", { bg = "NONE", underline = true, reverse = true })


-- Make the cursor appear as a crosshair by blending it with the background
vim.api.nvim_set_hl(0, "Cursor", { bg = "NONE", underline = true, reverse = true })

-- toggle keymappings for venn using <leader>v
-- vim.api.nvim_set_keymap('n', '<leader>v', ":lua Toggle_venn()<CR>", { noremap = true})

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

-- Keybinds for telekasten
--vim.keymap.set("n", "<leader>z", "<cmd>Telekasten panel<CR>")

vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>")
vim.keymap.set("n", "<leader>zl", "<cmd>Telekasten insert_link<CR>")
vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>")
vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>")
vim.keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<CR>")
vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>")
vim.keymap.set("n", "<leader>zc", "<cmd>Telekasten show_calendar<CR>")
vim.keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>")
vim.keymap.set("n", "<leader>zI", "<cmd>Telekasten insert_img_link<CR>")

-- Create an autocmd for markdown files - opening notes (telekasten)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()

    -- Buffer-local mapping
    vim.keymap.set("n", "<leader><CR>", require("telekasten").follow_link, {
      buffer = true,
      silent = true,
      desc = "Telekasten Follow Link",
    })
  end,
})

-- Small markdown-only keybind that lets me write checklists more easily.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "<leader>m", "<cmd>%s/@cl/- [ ]/ge<CR>", { buffer = true, desc = "Making checklists easily" })
  end,
})

-- Function to insert templates in an existing note
local function insert_template()
    local templates_dir = vim.fn.expand("~/Notes/templates")
    require("telescope.builtin").find_files({
        prompt_title = "Insert Template",
        cwd = templates_dir,
        attach_mappings = function(_, map)
            map("i", "<CR>", function(prompt_bufnr)
                local selection = require("telescope.actions.state").get_selected_entry()
                require("telescope.actions").close(prompt_bufnr)
                vim.cmd("read " .. templates_dir .. "/" .. selection.value)
            end)
            return true
        end,
    })
end

-- And map it to a keybind 
vim.keymap.set("n","<leader>zt", insert_template, {desc = "Insert template here"})
