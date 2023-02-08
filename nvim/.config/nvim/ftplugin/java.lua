-- note: if pulling this, must update  these values
local mason_location = vim.fn.stdpath("data") .. "/mason/packages"

local jdtls_install_location = mason_location .. "/jdtls"

-- if there are multiple versions, select the first one found
local equinox_launcher_jars =
    vim.split(vim.fn.glob(jdtls_install_location .. '/plugins/org.eclipse.equinox.launcher_*.jar',
        true), "\n", {})

local cur_equinox_launcher = equinox_launcher_jars[1]
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local workspace_dir = ""
local cur_config = ""
local sysname = vim.loop.os_uname().sysname
if sysname == 'Darwin' or sysname == 'Linux' then
    workspace_dir = os.getenv("HOME") .. '/var/log/jdtls/' .. project_name
    cur_config = "linux"
elseif sysname:find 'Windows' and true or false then
    require 'nvim-treesitter.install'.compilers = { "clang" }
    workspace_dir = os.getenv("UserProfile") .. '/.jdtls/' .. project_name
    cur_config = "win"
end

local bundles = {
    vim.fn.glob(mason_location .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
};

-- This is the new part
local all_jars = vim.fn.glob(mason_location .. "/java-test/extension/server/*.jar", true)
vim.list_extend(bundles,
    vim.split(all_jars, "\n", {}),
    1,
    #all_jars)

-- set up recommended convenience commands
vim.cmd [[
command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)
command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
command! -buffer JdtJol lua require('jdtls').jol()
command! -buffer JdtBytecode lua require('jdtls').javap()
command! -buffer JdtJshell lua require('jdtls').jshell()
command! -buffer JdtTestClass lua require('jdtls').test_class()
command! -buffer JdtTestNearestMethod lua require('jdtls').test_nearest_method()
]]

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {

        'java', -- or '/path/to/java17_or_newer/bin/java'
        -- depends on if `java` is in your $PATH env variable and if it points to the right version.

        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xms1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

        -- 💀
        '-jar',
        cur_equinox_launcher,
        -- jdtls_install_location .. '/plugins/org.eclipse.equinox.launcher_' .. version_number .. '.jar',
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                    ^^^^^^^^^^^^^^
        -- Must point to the                                                     Change this to
        -- eclipse.jdt.ls installation                                           the actual version


        -- 💀
        '-configuration', jdtls_install_location .. '/config_' .. cur_config,
        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
        -- Must point to the                      Change to one of `linux`, `win` or `mac`
        -- eclipse.jdt.ls installation            Depending on your system.


        -- 💀
        -- See `data directory configuration` section in the README
        '-data', workspace_dir
    },
    -- 💀
    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' }),
    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {
        }
    },
    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
        bundles = bundles
    },
    on_attach = function(client, bufnr)
        require("jdtls").setup_dap({ hotcodereplace = 'auto' })
        require('jdtls.dap').setup_dap_main_class_configs()

        require("global.lsp").on_attach(client, bufnr);
    end,
}
require('jdtls').start_or_attach(config)
