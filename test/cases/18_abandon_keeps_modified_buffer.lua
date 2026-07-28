local h = require("test.helper")

return function()
	local fake = h.fake_sops()
	local sops = h.setup()

	sops.disable()
	local encrypted = h.temp_file("secret.yml", h.marker_lines())
	vim.cmd.edit(vim.fn.fnameescape(encrypted))
	sops.edit()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_lines(0, 0, -1, false, { "changed" })

	vim.cmd.enew()
	local unloaded = pcall(vim.cmd.bunload, bufnr)

	h.assert_eq(unloaded, false)
	h.assert_eq(vim.api.nvim_buf_get_name(bufnr), encrypted)
	h.assert_eq(vim.b[bufnr].sops, "d")
	fake.cleanup()
end
