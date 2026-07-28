local h = require("test.helper")

return function()
	local fake = h.fake_sops()
	local sops = h.setup()
	sops.disable()
	local lines = h.marker_lines()
	for _ = 1, 46 do
		table.insert(lines, "plain")
	end

	local path = h.temp_file("secret.yml", lines)
	vim.cmd.edit(vim.fn.fnameescape(path))
	h.assert_eq(sops.is_encrypted(), true)

	table.insert(lines, 5, "plain")
	path = h.temp_file("secret.yml", lines)
	vim.cmd.edit(vim.fn.fnameescape(path))
	h.assert_eq(sops.is_encrypted(), false)
	fake.cleanup()
end
