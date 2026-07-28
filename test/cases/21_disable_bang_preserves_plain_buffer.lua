local h = require("test.helper")

return function()
	local sops = h.setup()
	local plain = h.temp_file("plain.yml", { "plain" })
	vim.cmd.edit(vim.fn.fnameescape(plain))
	vim.api.nvim_buf_set_lines(0, 0, -1, false, { "changed" })

	sops.disable({ bang = true })

	h.assert_eq(vim.api.nvim_buf_get_name(0), plain)
	h.assert_eq(vim.api.nvim_buf_get_lines(0, 0, -1, false), { "changed" })
	h.assert_eq(vim.bo.modified, true)
end
