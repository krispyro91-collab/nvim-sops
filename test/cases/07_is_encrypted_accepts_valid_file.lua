local h = require("test.helper")

return function()
	local fake = h.fake_sops()
	local sops = h.setup()
	sops.disable()

	local path = h.temp_file("secret.yml", h.marker_lines())
	vim.cmd.edit(vim.fn.fnameescape(path))

	h.assert_eq(sops.is_encrypted(), true)
	h.assert_eq(vim.b.sops, "e")

	vim.api.nvim_buf_set_lines(0, 0, -1, false, { "plain" })
	h.assert_eq(sops.is_encrypted(), false)
	h.assert_eq(vim.b.sops, nil)
	fake.cleanup()
end
