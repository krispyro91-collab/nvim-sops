local h = require("test.helper")

return function()
	local fake = h.fake_sops()
	vim.env.NVIM_FAKE_ENCRYPT_NO_CHANGES = "1"
	local messages, restore_notify = h.capture_notify()
	local sops = h.setup()

	sops.disable()
	local encrypted = h.temp_file("secret.yml", h.marker_lines())
	vim.cmd.edit(vim.fn.fnameescape(encrypted))
	sops.edit()
	vim.cmd("silent write")

	h.assert_eq(h.read_calls(fake), {
		"filestatus " .. encrypted,
		"-d --output " .. vim.fs.dirname(encrypted) .. "/.decrypted~secret.yml " .. encrypted,
		encrypted,
	})
	h.assert_eq(messages, {})
	restore_notify()
	fake.cleanup()
end
