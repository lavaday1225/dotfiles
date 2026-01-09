return {
	"akinsho/toggleterm.nvim",
	tag = "*",
	config = function()
		require("toggleterm").setup()
		local Terminal = require("toggleterm.terminal").Terminal
		-- lazygit
		local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })

		_G.lazygit_toggle = function()
			lazygit:toggle()
		end

		vim.api.nvim_set_keymap("n", "lg", "<cmd>lua _G.lazygit_toggle()<CR>", { noremap = true, silent = true })

		-- default terminal
		local term = Terminal:new({ hidden = true })

		_G.term_toggle = function()
			term:toggle()
		end
		vim.api.nvim_set_keymap("n", "tm", "<cmd>lua _G.term_toggle()<CR>", { noremap = true, silent = true })
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
	end,
}
