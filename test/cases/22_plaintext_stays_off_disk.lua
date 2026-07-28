local h = require("test.helper")

return function()
	local fake = h.fake_sops()
	local sops = h.setup()
	sops.disable()

	local encrypted = h.temp_file("secret.yml", h.marker_lines())
	local decrypted = vim.fs.joinpath(vim.fs.dirname(encrypted), ".decrypted~secret.yml")
	vim.cmd.edit(vim.fn.fnameescape(encrypted))
	sops.edit()
	vim.api.nvim_buf_set_lines(0, 0, -1, false, { "changed" })
	vim.cmd.write()

	h.assert_eq(vim.api.nvim_buf_get_name(0), encrypted)
	h.assert_eq(vim.fn.filereadable(decrypted), 0)
	fake.cleanup()
end
