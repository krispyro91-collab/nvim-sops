local h = require("test.helper")

return function()
	local fake = h.fake_sops()
	vim.env.NVIM_FAKE_DECRYPT_TEXT = "plain"
	local sops = h.setup()

	sops.disable()
	local encrypted = h.temp_file("secret.yml", h.marker_lines())
	vim.cmd.edit(vim.fn.fnameescape(encrypted))

	sops.enable({ bang = true })

	h.assert_eq(vim.api.nvim_buf_get_name(0), encrypted)
	h.assert_eq(vim.api.nvim_buf_get_lines(0, 0, -1, false), { "plain" })
	h.assert_eq(vim.bo.buftype, "")
	h.assert_eq(vim.bo.swapfile, false)
	h.assert_eq(vim.bo.undofile, false)
	fake.cleanup()
end
