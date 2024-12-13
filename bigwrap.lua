vim.api.nvim_create_user_command("WrapLines", function(opts)
	-- Default values for wrap character and line end
	local wrap_char = opts.fargs[1] or "'" -- Default to single quote if no character is provided
	local line_end = opts.fargs[2] or "" -- Optional line end, default to empty string
	local join_lines = false

	-- Check if the 'join' argument is passed
	if opts.fargs[2] == "join" then
		line_end = ""
		join_lines = true
	end
	if opts.fargs[3] == "join" then
		join_lines = true
	end

	local range_start, range_end

	-- Determine the range to operate on (visual or entire file)
	if opts.range then
		-- Visual selection range
		range_start = vim.fn.getpos("'<")[2]
		range_end = vim.fn.getpos("'>")[2]
	else
		-- Use % for the entire file
		range_start = 1
		range_end = vim.fn.line("$")
	end

	-- Apply wrapping and line end to each line in the range
	for line = range_start, range_end do
		-- Wrap the line with the specified character
		vim.fn.execute(line .. "norm I" .. wrap_char) -- Prepend character
		vim.fn.execute(line .. "norm A" .. wrap_char) -- Append character

		-- If a line end is provided and it's not the last line, append it
		if line ~= range_end then
			vim.fn.execute(line .. "norm A" .. line_end)
		end
	end

	if join_lines then
		-- Join the lines in the selected range without relying on 'norm J'
		vim.cmd(range_start .. "," .. range_end .. "join")
		-- After joining, the range will now consist of a single line
		range_start = vim.fn.line("$")
		range_end = vim.fn.line("$")
	end
end, {
	range = true,
	nargs = "*", -- Accept up to two arguments
	complete = function(ArgLead, Cmdline, CursorPos)
		-- Provide auto-completion for the wrap character and optional comma
		return { "'", '"', "(", "[", "{", ",", "join" }
	end,
})
