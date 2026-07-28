local h = require("test.helper")

return function()
	local fake = h.fake_sops()
	local sops = h.setup()
	sops.disable()

	local encrypted = h.temp_file("secret file%.yml", h.marker_lines())
	local decrypted = vim.fs.joinpath(vim.fs.dirname(encrypted), ".decrypted~secret file%.yml")
	local session = vim.fn.tempname() .. ".vim"
	vim.cmd.edit(vim.fn.fnameescape(encrypted))
	sops.edit()

	vim.cmd("mksession! " .. vim.fn.fnameescape(session))

	local contents = table.concat(vim.fn.readfile(session), "\n")
	h.assert_eq(contents:find(vim.fn.fnameescape(decrypted), 1, true), nil)
	h.assert_eq(contents:find(vim.fn.fnameescape(encrypted), 1, true) ~= nil, true)
	h.assert_eq(vim.api.nvim_buf_get_name(0), encrypted)

	vim.api.nvim_buf_delete(0, { force = true })
	sops.enable()
	vim.cmd.source(session)
	h.assert_eq(vim.api.nvim_buf_get_name(0), encrypted)
	h.assert_eq(vim.api.nvim_buf_get_lines(0, 0, -1, false), { "decrypted" })
	h.assert_eq(vim.b.sops, "d")
	fake.cleanup()
end
