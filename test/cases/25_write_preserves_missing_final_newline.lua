local h = require("test.helper")

return function()
	local fake = h.fake_sops()
	vim.env.NVIM_FAKE_DECRYPT_TEXT = "plain"
	vim.env.NVIM_FAKE_DECRYPT_NO_EOL = "1"
	local sops = h.setup()
	sops.disable()

	local encrypted = h.temp_file("secret.yml", h.marker_lines())
	vim.cmd.edit(vim.fn.fnameescape(encrypted))
	sops.edit()
	vim.cmd.write()

	h.assert_eq(vim.bo.endofline, false)
	h.assert_eq(vim.fn.getfsize(encrypted), 5)
	fake.cleanup()
end
