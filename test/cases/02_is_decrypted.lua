local h = require("test.helper")

return function()
	local fake = h.fake_sops()
	local sops = h.setup()
	sops.disable()

	local plain = h.temp_file("secret.yml", { "secret" })
	vim.cmd.edit(vim.fn.fnameescape(plain))
	h.assert_eq(sops.is_decrypted(), false)

	local encrypted = h.temp_file("encrypted.yml", h.marker_lines())
	vim.cmd.edit(vim.fn.fnameescape(encrypted))
	sops.edit()
	h.assert_eq(sops.is_decrypted(), true)
	h.assert_eq(vim.b.sops, "d")
	fake.cleanup()
end
