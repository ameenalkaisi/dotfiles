M = {}
M.cursys = ""

local sysname = vim.loop.os_uname().sysname
if sysname == 'Darwin' then
	M.cursys = 'Mac'
elseif sysname == 'Linux' then
	M.cursys = 'Linux'
elseif sysname:find 'Windows' and true or false then
	M.cursys = 'Windows'
end

return M
