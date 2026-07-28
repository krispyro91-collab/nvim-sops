local h = require("test.helper")

return function()
	local fake = h.fake_sops()
	vim.env.NVIM_FAKE_DECRYPT_TEXT = "first"
	h.setup()

	local encrypted = h.temp_file("secret.yml", h.marker_lines())
	vim.cmd.edit(vim.fn.fnameescape(encrypted))
	vim.env.NVIM_FAKE_DECRYPT_TEXT = "second"
	vim.cmd.edit()

	h.assert_eq(vim.api.nvim_buf_get_name(0), encrypted)
	h.assert_eq(vim.api.nvim_buf_get_lines(0, 0, -1, false), { "second" })
	h.assert_eq(vim.b.sops, "d")
	fake.cleanup()
end
