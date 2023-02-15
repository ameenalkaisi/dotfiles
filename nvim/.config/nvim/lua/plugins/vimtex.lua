return {
	"lervag/vimtex",
	config = function()
		local sys = require("global.system").cursys
		if sys ~= "Windows" then
			-- for windows, make sure sumatrapdf is installed and is in path
			vim.g.vimtex_view_method = "zathura"
		end
	end
}
