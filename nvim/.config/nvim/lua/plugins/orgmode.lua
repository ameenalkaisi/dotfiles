return {
    "nvim-orgmode/orgmode",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        local orgmode = require("orgmode")

        orgmode.setup_ts_grammar()
        orgmode.setup({
            org_agenda_files = { "~/notes/agenda/*" },
            org_default_notes_file = "~/notes/refile.org",
        })
    end,
}
