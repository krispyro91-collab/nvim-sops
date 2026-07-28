local h = require("test.helper")

return function()
	local path = vim.env.PATH
	local notify = vim.notify
	local age_key = vim.env.SOPS_AGE_KEY_FILE
	h.fake_sops()
	h.capture_notify()
	vim.env.SOPS_AGE_KEY_FILE = "changed"

	h.reset()

	h.assert_eq(vim.env.PATH, path)
	h.assert_eq(vim.notify, notify)
	h.assert_eq(vim.env.SOPS_AGE_KEY_FILE, age_key)
end
