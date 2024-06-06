M = {}

M.touch_file = function(filename, content)
    -- Extract the directory path
    local path = string.match(filename, "(.*/)")
    if path then
        os.execute('mkdir -p "' .. path .. '"')
    end

    -- Attempt to open the file in read mode
    local file = io.open(filename, "r")

    if file then
        -- File exists, close the file
        vim.cmd(string.format("source %s", filename))
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
