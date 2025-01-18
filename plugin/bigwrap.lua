local bigwrap = require("bigwrap")

vim.api.nvim_create_user_command("WrapLines", bigwrap.wraplines, {
	range = true,
	nargs = "*",
	complete = function(ArgLead, Cmdline, CursorPos)
		-- Provide auto-completion for the wrap character and optional comma
		return { "'", '"', "(", "[", "{", ",", "join" }
	end,
})
