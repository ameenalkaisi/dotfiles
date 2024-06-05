M = {}

local function mkdir_p(path)
    -- Recursively create directories as needed
    local current = ""
    for dir in string.gmatch(path, "([^/]+)") do
        current = current .. dir .. "/"
        -- Use OS-specific command to create the directory
        if not os.execute('mkdir "' .. current .. '" 2>nul') and not os.execute('mkdir -p "' .. current .. '"') then
            print("Error: Could not create directory " .. current)
            return false
        end
    end
    return true
end

M.touch_file = function(filename, content)
    -- Extract the directory path
    local path = string.match(filename, "(.*/)")
    if path then
        mkdir_p(path)
    end

    -- Attempt to open the file in read mode
    local file = io.open(filename, "r")

    if file then
        -- File exists, close the file
        file:close()
    else
        -- File doesn't exist, create the file
        file = io.open(filename, "w")
        if file then
            if content then
                file:write(content)
            end
            file:close()
        else
            error("Error: Could not create file " .. filename)
        end
    end
end

return M
