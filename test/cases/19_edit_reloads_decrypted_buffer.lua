local h = require("test.helper")

return function()
	local fake = h.fake_sops()
	h.setup()
	local encrypted = h.temp_file("secret.yml", h.marker_lines())
	vim.cmd.edit(vim.fn.fnameescape(encrypted))
	local bufnr = vim.api.nvim_get_current_buf()
	local plain = h.temp_file("plain.yml", { "plain" })

	local hidden = vim.o.hidden
	vim.o.hidden = false
	vim.cmd.edit(vim.fn.fnameescape(plain))
	vim.cmd.edit(vim.fn.fnameescape(encrypted))
	vim.o.hidden = hidden

	h.assert_eq(vim.api.nvim_buf_is_loaded(bufnr), true)
	h.assert_eq(vim.api.nvim_buf_get_name(0), encrypted)
	h.assert_eq(vim.api.nvim_buf_get_lines(0, 0, -1, false), { "decrypted" })
	h.assert_eq(vim.b.sops, "d")
	fake.cleanup()
end
