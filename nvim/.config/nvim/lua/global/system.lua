M = {}

M.cursys = ""
M.home_path = ""

local sysname = vim.loop.os_uname().sysname
if sysname == "Darwin" then
	M.cursys = "Mac"
elseif sysname == "Linux" then
	M.cursys = "Linux"
elseif sysname:find("Windows") and true or false then
	M.cursys = "Windows"
end

if M.cursys == "Windows" then
	M.home_path = os.getenv("UserProfile")
else
	M.home_path = os.getenv("HOME")
end

return M
