local h = require("test.helper")

return function()
	local fake = h.fake_sops()
	local sops = h.setup()

	local encrypted = h.temp_file("secret.yml", h.marker_lines())
	vim.cmd.edit(vim.fn.fnameescape(encrypted))
	local calls = h.read_calls(fake)
	vim.api.nvim_exec_autocmds("BufReadPost", { buffer = 0 })

	h.assert_eq(vim.api.nvim_buf_get_name(0), encrypted)
	h.assert_eq(vim.b.sops, "d")
	h.assert_eq(h.read_calls(fake), calls)

	vim.api.nvim_buf_set_lines(0, 0, -1, false, { "changed" })
	sops.edit()
	h.assert_eq(vim.api.nvim_buf_get_lines(0, 0, -1, false), { "changed" })
	h.assert_eq(vim.bo.modified, true)
	h.assert_eq(h.read_calls(fake), calls)
	fake.cleanup()
end
