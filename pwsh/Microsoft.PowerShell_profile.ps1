using namespace System.Management.Automation
using namespace System.Management.Automation.Language

if ($host.Name -eq 'ConsoleHost')
{
	#oh-my-posh init pwsh --config "C:\Program Files (x86)\oh-my-posh\themes\robbyrussel.omp.json" | Invoke-Expression
	Import-Module -Name PSReadLine
	# Shows navigable menu of all options when hitting Tab
	Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

	# Autocompletion for arrow keys
	Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
	Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
	Import-Module -Name Terminal-Icons

	#Set-PSReadLineOption -EditMode Vi -ViModeIndicator Cursor
	Set-PSReadLineOption -PredictionSource History
	#Set-PSReadlineKeyHandler -Chord "Ctrl+Oem4" -Function ViCommandMode

	New-Alias vi C:\Windows\vim.bat
	New-Alias vim neovide

	Function OpenNotesNvim
	{
		neovide $env:HOMEPATH\notes
	}
	New-Alias notes OpenNotesNvim

	Function OpenNvimConfig
	{
		neovide $env:LOCALAPPDATA\nvim
	}
	New-Alias nvimconf OpenNvimConfig
}

# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# powershell completion for kubectl                              -*- shell-script -*-

function __kubectl_debug {
    if ($env:BASH_COMP_DEBUG_FILE) {
        "$args" | Out-File -Append -FilePath "$env:BASH_COMP_DEBUG_FILE"
    }
}

filter __kubectl_escapeStringWithSpecialChars {
    $_ -replace '\s|#|@|\$|;|,|''|\{|\}|\(|\)|"|`|\||<|>|&','`$&'
}

[scriptblock]$__kubectlCompleterBlock = {
    param(
            $WordToComplete,
            $CommandAst,
            $CursorPosition
        )

    # Get the current command line and convert into a string
    $Command = $CommandAst.CommandElements
    $Command = "$Command"

    __kubectl_debug ""
    __kubectl_debug "========= starting completion logic =========="
    __kubectl_debug "WordToComplete: $WordToComplete Command: $Command CursorPosition: $CursorPosition"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CursorPosition location, so we need
    # to truncate the command-line ($Command) up to the $CursorPosition location.
    # Make sure the $Command is longer then the $CursorPosition before we truncate.
    # This happens because the $Command does not include the last space.
    if ($Command.Length -gt $CursorPosition) {
        $Command=$Command.Substring(0,$CursorPosition)
    }
    __kubectl_debug "Truncated command: $Command"

    $ShellCompDirectiveError=1
    $ShellCompDirectiveNoSpace=2
    $ShellCompDirectiveNoFileComp=4
    $ShellCompDirectiveFilterFileExt=8
    $ShellCompDirectiveFilterDirs=16

    # Prepare the command to request completions for the program.
    # Split the command at the first space to separate the program and arguments.
    $Program,$Arguments = $Command.Split(" ",2)

    $RequestComp="$Program __complete $Arguments"
    __kubectl_debug "RequestComp: $RequestComp"

    # we cannot use $WordToComplete because it
    # has the wrong values if the cursor was moved
    # so use the last argument
    if ($WordToComplete -ne "" ) {
        $WordToComplete = $Arguments.Split(" ")[-1]
    }
    __kubectl_debug "New WordToComplete: $WordToComplete"


    # Check for flag with equal sign
    $IsEqualFlag = ($WordToComplete -Like "--*=*" )
    if ( $IsEqualFlag ) {
        __kubectl_debug "Completing equal sign flag"
        # Remove the flag part
        $Flag,$WordToComplete = $WordToComplete.Split("=",2)
    }

    if ( $WordToComplete -eq "" -And ( -Not $IsEqualFlag )) {
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go method.
        __kubectl_debug "Adding extra empty parameter"
        # We need to use `"`" to pass an empty argument a "" or '' does not work!!!
        $RequestComp="$RequestComp" + ' `"`"'
    }

    __kubectl_debug "Calling $RequestComp"
    # First disable ActiveHelp which is not supported for Powershell
    $env:KUBECTL_ACTIVE_HELP=0

    #call the command store the output in $out and redirect stderr and stdout to null
    # $Out is an array contains each line per element
    Invoke-Expression -OutVariable out "$RequestComp" 2>&1 | Out-Null

    # get directive from last line
    [int]$Directive = $Out[-1].TrimStart(':')
    if ($Directive -eq "") {
        # There is no directive specified
        $Directive = 0
    }
    __kubectl_debug "The completion directive is: $Directive"

    # remove directive (last element) from out
    $Out = $Out | Where-Object { $_ -ne $Out[-1] }
    __kubectl_debug "The completions are: $Out"

    if (($Directive -band $ShellCompDirectiveError) -ne 0 ) {
        # Error code.  No completion.
        __kubectl_debug "Received error from custom completion go code"
        return
    }

    $Longest = 0
    $Values = $Out | ForEach-Object {
        #Split the output in name and description
        $Name, $Description = $_.Split("`t",2)
        __kubectl_debug "Name: $Name Description: $Description"

        # Look for the longest completion so that we can format things nicely
        if ($Longest -lt $Name.Length) {
            $Longest = $Name.Length
        }

        # Set the description to a one space string if there is none set.
        # This is needed because the CompletionResult does not accept an empty string as argument
        if (-Not $Description) {
            $Description = " "
        }
        @{Name="$Name";Description="$Description"}
    }


    $Space = " "
    if (($Directive -band $ShellCompDirectiveNoSpace) -ne 0 ) {
        # remove the space here
        __kubectl_debug "ShellCompDirectiveNoSpace is called"
        $Space = ""
    }

    if ((($Directive -band $ShellCompDirectiveFilterFileExt) -ne 0 ) -or
       (($Directive -band $ShellCompDirectiveFilterDirs) -ne 0 ))  {
        __kubectl_debug "ShellCompDirectiveFilterFileExt ShellCompDirectiveFilterDirs are not supported"

        # return here to prevent the completion of the extensions
        return
    }

    $Values = $Values | Where-Object {
        # filter the result
        $_.Name -like "$WordToComplete*"

        # Join the flag back if we have an equal sign flag
        if ( $IsEqualFlag ) {
            __kubectl_debug "Join the equal sign flag back to the completion value"
            $_.Name = $Flag + "=" + $_.Name
        }
    }

    if (($Directive -band $ShellCompDirectiveNoFileComp) -ne 0 ) {
        __kubectl_debug "ShellCompDirectiveNoFileComp is called"

        if ($Values.Length -eq 0) {
            # Just print an empty string here so the
            # shell does not start to complete paths.
            # We cannot use CompletionResult here because
            # it does not accept an empty string as argument.
            ""
            return
        }
    }

    # Get the current mode
    $Mode = (Get-PSReadLineKeyHandler | Where-Object {$_.Key -eq "Tab" }).Function
    __kubectl_debug "Mode: $Mode"

    $Values | ForEach-Object {

        # store temporary because switch will overwrite $_
        $comp = $_

        # PowerShell supports three different completion modes
        # - TabCompleteNext (default windows style - on each key press the next option is displayed)
        # - Complete (works like bash)
        # - MenuComplete (works like zsh)
        # You set the mode with Set-PSReadLineKeyHandler -Key Tab -Function <mode>

        # CompletionResult Arguments:
        # 1) CompletionText text to be used as the auto completion result
        # 2) ListItemText   text to be displayed in the suggestion list
        # 3) ResultType     type of completion result
        # 4) ToolTip        text for the tooltip with details about the object

        switch ($Mode) {

            # bash like
            "Complete" {

                if ($Values.Length -eq 1) {
                    __kubectl_debug "Only one completion left"

                    # insert space after value
                    [System.Management.Automation.CompletionResult]::new($($comp.Name | __kubectl_escapeStringWithSpecialChars) + $Space, "$($comp.Name)", 'ParameterValue', "$($comp.Description)")

                } else {
                    # Add the proper number of spaces to align the descriptions
                    while($comp.Name.Length -lt $Longest) {
                        $comp.Name = $comp.Name + " "
                    }

                    # Check for empty description and only add parentheses if needed
                    if ($($comp.Description) -eq " " ) {
                        $Description = ""
                    } else {
                        $Description = "  ($($comp.Description))"
                    }

                    [System.Management.Automation.CompletionResult]::new("$($comp.Name)$Description", "$($comp.Name)$Description", 'ParameterValue', "$($comp.Description)")
                }
             }

            # zsh like
            "MenuComplete" {
                # insert space after value
                # MenuComplete will automatically show the ToolTip of
                # the highlighted value at the bottom of the suggestions.
                [System.Management.Automation.CompletionResult]::new($($comp.Name | __kubectl_escapeStringWithSpecialChars) + $Space, "$($comp.Name)", 'ParameterValue', "$($comp.Description)")
            }

            # TabCompleteNext and in case we get something unknown
            Default {
                # Like MenuComplete but we don't want to add a space here because
                # the user need to press space anyway to get the completion.
                # Description will not be shown because that's not possible with TabCompleteNext
                [System.Management.Automation.CompletionResult]::new($($comp.Name | __kubectl_escapeStringWithSpecialChars), "$($comp.Name)", 'ParameterValue', "$($comp.Description)")
            }
        }

    }
}

Register-ArgumentCompleter -CommandName 'kubectl' -ScriptBlock $__kubectlCompleterBlock


Register-ArgumentCompleter -Native -CommandName 'wezterm' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'wezterm'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-') -or
                $element.Value -eq $wordToComplete) {
                break
        }
        $element.Value
    }) -join ';'

    $completions = @(switch ($command) {
        'wezterm' {
            [CompletionResult]::new('--config-file', 'config-file', [CompletionResultType]::ParameterName, 'Specify the configuration file to use, overrides the normal configuration file resolution')
            [CompletionResult]::new('--config', 'config', [CompletionResultType]::ParameterName, 'Override specific configuration values')
            [CompletionResult]::new('-n', 'n', [CompletionResultType]::ParameterName, 'Skip loading wezterm.lua')
            [CompletionResult]::new('--skip-config', 'skip-config', [CompletionResultType]::ParameterName, 'Skip loading wezterm.lua')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Print version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version information')
            [CompletionResult]::new('start', 'start', [CompletionResultType]::ParameterValue, 'Start the GUI, optionally running an alternative program')
            [CompletionResult]::new('ssh', 'ssh', [CompletionResultType]::ParameterValue, 'Establish an ssh session')
            [CompletionResult]::new('serial', 'serial', [CompletionResultType]::ParameterValue, 'Open a serial port')
            [CompletionResult]::new('connect', 'connect', [CompletionResultType]::ParameterValue, 'Connect to wezterm multiplexer')
            [CompletionResult]::new('ls-fonts', 'ls-fonts', [CompletionResultType]::ParameterValue, 'Display information about fonts')
            [CompletionResult]::new('show-keys', 'show-keys', [CompletionResultType]::ParameterValue, 'Show key assignments')
            [CompletionResult]::new('cli', 'cli', [CompletionResultType]::ParameterValue, 'Interact with experimental mux server')
            [CompletionResult]::new('imgcat', 'imgcat', [CompletionResultType]::ParameterValue, 'Output an image to the terminal')
            [CompletionResult]::new('set-working-directory', 'set-working-directory', [CompletionResultType]::ParameterValue, 'Advise the terminal of the current working directory by emitting an OSC 7 escape sequence')
            [CompletionResult]::new('record', 'record', [CompletionResultType]::ParameterValue, 'Record a terminal session as an asciicast')
            [CompletionResult]::new('replay', 'replay', [CompletionResultType]::ParameterValue, 'Replay an asciicast terminal session')
            [CompletionResult]::new('shell-completion', 'shell-completion', [CompletionResultType]::ParameterValue, 'Generate shell completion information')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'wezterm;start' {
            [CompletionResult]::new('--cwd', 'cwd', [CompletionResultType]::ParameterName, 'Specify the current working directory for the initially spawned program')
            [CompletionResult]::new('--class', 'class', [CompletionResultType]::ParameterName, 'Override the default windowing system class. The default is "org.wezfurlong.wezterm". Under X11 and Windows this changes the window class. Under Wayland this changes the app_id. This changes the class for all windows spawned by this instance of wezterm, including error, update and ssh authentication dialogs')
            [CompletionResult]::new('--workspace', 'workspace', [CompletionResultType]::ParameterName, 'Override the default workspace with the provided name. The default is "default"')
            [CompletionResult]::new('--position', 'position', [CompletionResultType]::ParameterName, 'Override the position for the initial window launched by this process.')
            [CompletionResult]::new('--no-auto-connect', 'no-auto-connect', [CompletionResultType]::ParameterName, 'If true, do not connect to domains marked as connect_automatically in your wezterm configuration file')
            [CompletionResult]::new('--always-new-process', 'always-new-process', [CompletionResultType]::ParameterName, 'If enabled, don''t try to ask an existing wezterm GUI instance to start the command.  Instead, always start the GUI in this invocation of wezterm so that you can wait for the command to complete by waiting for this wezterm process to finish')
            [CompletionResult]::new('-e', 'e', [CompletionResultType]::ParameterName, 'Dummy argument that consumes "-e" and does nothing. This is meant as a compatibility layer for supporting the widely adopted standard of passing the command to execute to the terminal via a "-e" option. This works because we then treat the remaining cmdline as trailing options, that will automatically be parsed via the existing "prog" option. This option exists only as a fallback. It is recommended to pass the command as a normal trailing command instead if possible')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information (use `--help` for more detail)')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information (use `--help` for more detail)')
            break
        }
        'wezterm;ssh' {
            [CompletionResult]::new('-o', 'o', [CompletionResultType]::ParameterName, 'Override specific SSH configuration options. `wezterm ssh` is able to parse some (but not all!) options from your `~/.ssh/config` and `/etc/ssh/ssh_config` files. This command line switch allows you to override or otherwise specify ssh_config style options')
            [CompletionResult]::new('--ssh-option', 'ssh-option', [CompletionResultType]::ParameterName, 'Override specific SSH configuration options. `wezterm ssh` is able to parse some (but not all!) options from your `~/.ssh/config` and `/etc/ssh/ssh_config` files. This command line switch allows you to override or otherwise specify ssh_config style options')
            [CompletionResult]::new('--class', 'class', [CompletionResultType]::ParameterName, 'Override the default windowing system class. The default is "org.wezfurlong.wezterm". Under X11 and Windows this changes the window class. Under Wayland this changes the app_id. This changes the class for all windows spawned by this instance of wezterm, including error, update and ssh authentication dialogs')
            [CompletionResult]::new('--position', 'position', [CompletionResultType]::ParameterName, 'Override the position for the initial window launched by this process.')
            [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterName, 'Enable verbose ssh protocol tracing. The trace information is printed to the stderr stream of the process')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information (use `--help` for more detail)')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information (use `--help` for more detail)')
            break
        }
        'wezterm;serial' {
            [CompletionResult]::new('--baud', 'baud', [CompletionResultType]::ParameterName, 'Set the baud rate.  The default is 9600 baud')
            [CompletionResult]::new('--class', 'class', [CompletionResultType]::ParameterName, 'Override the default windowing system class. The default is "org.wezfurlong.wezterm". Under X11 and Windows this changes the window class. Under Wayland this changes the app_id. This changes the class for all windows spawned by this instance of wezterm, including error, update and ssh authentication dialogs')
            [CompletionResult]::new('--position', 'position', [CompletionResultType]::ParameterName, 'Override the position for the initial window launched by this process.')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information (use `--help` for more detail)')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information (use `--help` for more detail)')
            break
        }
        'wezterm;connect' {
            [CompletionResult]::new('--class', 'class', [CompletionResultType]::ParameterName, 'Override the default windowing system class. The default is "org.wezfurlong.wezterm". Under X11 and Windows this changes the window class. Under Wayland this changes the app_id. This changes the class for all windows spawned by this instance of wezterm, including error, update and ssh authentication dialogs')
            [CompletionResult]::new('--workspace', 'workspace', [CompletionResultType]::ParameterName, 'Override the default workspace with the provided name. The default is "default"')
            [CompletionResult]::new('--position', 'position', [CompletionResultType]::ParameterName, 'Override the position for the initial window launched by this process.')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information (use `--help` for more detail)')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information (use `--help` for more detail)')
            break
        }
        'wezterm;ls-fonts' {
            [CompletionResult]::new('--text', 'text', [CompletionResultType]::ParameterName, 'Explain which fonts are used to render the supplied text string')
            [CompletionResult]::new('--codepoints', 'codepoints', [CompletionResultType]::ParameterName, 'Explain which fonts are used to render the specified unicode code point sequence. Code points are comma separated hex values')
            [CompletionResult]::new('--list-system', 'list-system', [CompletionResultType]::ParameterName, 'Whether to list all fonts available to the system')
            [CompletionResult]::new('--rasterize-ascii', 'rasterize-ascii', [CompletionResultType]::ParameterName, 'Show rasterized glyphs for the text in --text or --codepoints using ascii blocks')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
            break
        }
        'wezterm;show-keys' {
            [CompletionResult]::new('--key-table', 'key-table', [CompletionResultType]::ParameterName, 'In lua mode, show only the named key table')
            [CompletionResult]::new('--lua', 'lua', [CompletionResultType]::ParameterName, 'Show the keys as lua config statements')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
            break
        }
        'wezterm;cli' {
            [CompletionResult]::new('--class', 'class', [CompletionResultType]::ParameterName, 'When connecting to a gui instance, if you started the gui with `--class SOMETHING`, you should also pass that same value here in order for the client to find the correct gui instance')
            [CompletionResult]::new('--no-auto-start', 'no-auto-start', [CompletionResultType]::ParameterName, 'Don''t automatically start the server')
            [CompletionResult]::new('--prefer-mux', 'prefer-mux', [CompletionResultType]::ParameterName, 'Prefer connecting to a background mux server. The default is to prefer connecting to a running wezterm gui instance')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'list windows, tabs and panes')
            [CompletionResult]::new('list-clients', 'list-clients', [CompletionResultType]::ParameterValue, 'list clients')
            [CompletionResult]::new('proxy', 'proxy', [CompletionResultType]::ParameterValue, 'start rpc proxy pipe')
            [CompletionResult]::new('tlscreds', 'tlscreds', [CompletionResultType]::ParameterValue, 'obtain tls credentials')
            [CompletionResult]::new('move-pane-to-new-tab', 'move-pane-to-new-tab', [CompletionResultType]::ParameterValue, 'Move a pane into a new tab')
            [CompletionResult]::new('split-pane', 'split-pane', [CompletionResultType]::ParameterValue, 'split the current pane.
Outputs the pane-id for the newly created pane on success')
            [CompletionResult]::new('spawn', 'spawn', [CompletionResultType]::ParameterValue, 'Spawn a command into a new window or tab
Outputs the pane-id for the newly created pane on success')
            [CompletionResult]::new('send-text', 'send-text', [CompletionResultType]::ParameterValue, 'Send text to a pane as though it were pasted. If bracketed paste mode is enabled in the pane, then the text will be sent as a bracketed paste')
            [CompletionResult]::new('activate-pane-direction', 'activate-pane-direction', [CompletionResultType]::ParameterValue, 'Activate an adjacent pane in the specified direction')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'wezterm;cli;list' {
            [CompletionResult]::new('--format', 'format', [CompletionResultType]::ParameterName, 'Controls the output format. "table" and "json" are possible formats')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
            break
        }
        'wezterm;cli;list-clients' {
            [CompletionResult]::new('--format', 'format', [CompletionResultType]::ParameterName, 'Controls the output format. "table" and "json" are possible formats')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
            break
        }
        'wezterm;cli;proxy' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
            break
        }
        'wezterm;cli;tlscreds' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
            break
        }
        'wezterm;cli;move-pane-to-new-tab' {
            [CompletionResult]::new('--pane-id', 'pane-id', [CompletionResultType]::ParameterName, 'Specify the pane that should be moved. The default is to use the current pane based on the environment variable WEZTERM_PANE')
            [CompletionResult]::new('--window-id', 'window-id', [CompletionResultType]::ParameterName, 'Specify the window into which the new tab will be created. If omitted, the window associated with the current pane is used')
            [CompletionResult]::new('--workspace', 'workspace', [CompletionResultType]::ParameterName, 'If creating a new window, override the default workspace name with the provided name.  The default name is "default"')
            [CompletionResult]::new('--new-window', 'new-window', [CompletionResultType]::ParameterName, 'Create tab in a new window, rather than the window currently containing the pane')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
            break
        }
        'wezterm;cli;split-pane' {
            [CompletionResult]::new('--pane-id', 'pane-id', [CompletionResultType]::ParameterName, 'Specify the pane that should be split. The default is to use the current pane based on the environment variable WEZTERM_PANE')
            [CompletionResult]::new('--cells', 'cells', [CompletionResultType]::ParameterName, 'The number of cells that the new split should have. If omitted, 50% of the available space is used')
            [CompletionResult]::new('--percent', 'percent', [CompletionResultType]::ParameterName, 'Specify the number of cells that the new split should have, expressed as a percentage of the available space')
            [CompletionResult]::new('--cwd', 'cwd', [CompletionResultType]::ParameterName, 'Specify the current working directory for the initially spawned program')
            [CompletionResult]::new('--move-pane-id', 'move-pane-id', [CompletionResultType]::ParameterName, 'Instead of spawning a new command, move the specified pane into the newly created split')
            [CompletionResult]::new('--horizontal', 'horizontal', [CompletionResultType]::ParameterName, 'Equivalent to `--right`. If neither this nor any other direction is specified, the default is equivalent to `--bottom`')
            [CompletionResult]::new('--left', 'left', [CompletionResultType]::ParameterName, 'Split horizontally, with the new pane on the left')
            [CompletionResult]::new('--right', 'right', [CompletionResultType]::ParameterName, 'Split horizontally, with the new pane on the right')
            [CompletionResult]::new('--top', 'top', [CompletionResultType]::ParameterName, 'Split vertically, with the new pane on the top')
            [CompletionResult]::new('--bottom', 'bottom', [CompletionResultType]::ParameterName, 'Split vertically, with the new pane on the bottom')
            [CompletionResult]::new('--top-level', 'top-level', [CompletionResultType]::ParameterName, 'Rather than splitting the active pane, split the entire window')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
            break
        }
        'wezterm;cli;spawn' {
            [CompletionResult]::new('--pane-id', 'pane-id', [CompletionResultType]::ParameterName, 'Specify the current pane. The default is to use the current pane based on the environment variable WEZTERM_PANE. The pane is used to determine the current domain and window')
            [CompletionResult]::new('--domain-name', 'domain-name', [CompletionResultType]::ParameterName, 'domain-name')
            [CompletionResult]::new('--window-id', 'window-id', [CompletionResultType]::ParameterName, 'Specify the window into which to spawn a tab. If omitted, the window associated with the current pane is used. Cannot be used with `--workspace` or `--new-window`')
            [CompletionResult]::new('--cwd', 'cwd', [CompletionResultType]::ParameterName, 'Specify the current working directory for the initially spawned program')
            [CompletionResult]::new('--workspace', 'workspace', [CompletionResultType]::ParameterName, 'When creating a new window, override the default workspace name with the provided name.  The default name is "default". Requires `--new-window`')
            [CompletionResult]::new('--new-window', 'new-window', [CompletionResultType]::ParameterName, 'Spawn into a new window, rather than a new tab')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
            break
        }
        'wezterm;cli;send-text' {
            [CompletionResult]::new('--pane-id', 'pane-id', [CompletionResultType]::ParameterName, 'Specify the target pane. The default is to use the current pane based on the environment variable WEZTERM_PANE')
            [CompletionResult]::new('--no-paste', 'no-paste', [CompletionResultType]::ParameterName, 'Send the text directly, rather than as a bracketed paste')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
            break
        }
        'wezterm;cli;activate-pane-direction' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
            break
        }
        'wezterm;cli;help' {
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'list windows, tabs and panes')
            [CompletionResult]::new('list-clients', 'list-clients', [CompletionResultType]::ParameterValue, 'list clients')
            [CompletionResult]::new('proxy', 'proxy', [CompletionResultType]::ParameterValue, 'start rpc proxy pipe')
            [CompletionResult]::new('tlscreds', 'tlscreds', [CompletionResultType]::ParameterValue, 'obtain tls credentials')
            [CompletionResult]::new('move-pane-to-new-tab', 'move-pane-to-new-tab', [CompletionResultType]::ParameterValue, 'Move a pane into a new tab')
            [CompletionResult]::new('split-pane', 'split-pane', [CompletionResultType]::ParameterValue, 'split the current pane.
Outputs the pane-id for the newly created pane on success')
            [CompletionResult]::new('spawn', 'spawn', [CompletionResultType]::ParameterValue, 'Spawn a command into a new window or tab
Outputs the pane-id for the newly created pane on success')
            [CompletionResult]::new('send-text', 'send-text', [CompletionResultType]::ParameterValue, 'Send text to a pane as though it were pasted. If bracketed paste mode is enabled in the pane, then the text will be sent as a bracketed paste')
            [CompletionResult]::new('activate-pane-direction', 'activate-pane-direction', [CompletionResultType]::ParameterValue, 'Activate an adjacent pane in the specified direction')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'wezterm;cli;help;list' {
            break
        }
        'wezterm;cli;help;list-clients' {
            break
        }
        'wezterm;cli;help;proxy' {
            break
        }
        'wezterm;cli;help;tlscreds' {
            break
        }
        'wezterm;cli;help;move-pane-to-new-tab' {
            break
        }
        'wezterm;cli;help;split-pane' {
            break
        }
        'wezterm;cli;help;spawn' {
            break
        }
        'wezterm;cli;help;send-text' {
            break
        }
        'wezterm;cli;help;activate-pane-direction' {
            break
        }
        'wezterm;cli;help;help' {
            break
        }
        'wezterm;imgcat' {
            [CompletionResult]::new('--width', 'width', [CompletionResultType]::ParameterName, 'Specify the display width; defaults to "auto" which automatically selects an appropriate size.  You may also use an integer value `N` to specify the number of cells, or `Npx` to specify the number of pixels, or `N%` to size relative to the terminal width')
            [CompletionResult]::new('--height', 'height', [CompletionResultType]::ParameterName, 'Specify the display height; defaults to "auto" which automatically selects an appropriate size.  You may also use an integer value `N` to specify the number of cells, or `Npx` to specify the number of pixels, or `N%` to size relative to the terminal height')
            [CompletionResult]::new('--no-preserve-aspect-ratio', 'no-preserve-aspect-ratio', [CompletionResultType]::ParameterName, 'Do not respect the aspect ratio.  The default is to respect the aspect ratio')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
            break
        }
        'wezterm;set-working-directory' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
            break
        }
        'wezterm;record' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
            break
        }
        'wezterm;replay' {
            [CompletionResult]::new('--explain', 'explain', [CompletionResultType]::ParameterName, 'Explain what is being sent/received')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
            break
        }
        'wezterm;shell-completion' {
            [CompletionResult]::new('--shell', 'shell', [CompletionResultType]::ParameterName, 'Which shell to generate for')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help information')
            break
        }
        'wezterm;help' {
            [CompletionResult]::new('start', 'start', [CompletionResultType]::ParameterValue, 'Start the GUI, optionally running an alternative program')
            [CompletionResult]::new('ssh', 'ssh', [CompletionResultType]::ParameterValue, 'Establish an ssh session')
            [CompletionResult]::new('serial', 'serial', [CompletionResultType]::ParameterValue, 'Open a serial port')
            [CompletionResult]::new('connect', 'connect', [CompletionResultType]::ParameterValue, 'Connect to wezterm multiplexer')
            [CompletionResult]::new('ls-fonts', 'ls-fonts', [CompletionResultType]::ParameterValue, 'Display information about fonts')
            [CompletionResult]::new('show-keys', 'show-keys', [CompletionResultType]::ParameterValue, 'Show key assignments')
            [CompletionResult]::new('cli', 'cli', [CompletionResultType]::ParameterValue, 'Interact with experimental mux server')
            [CompletionResult]::new('imgcat', 'imgcat', [CompletionResultType]::ParameterValue, 'Output an image to the terminal')
            [CompletionResult]::new('set-working-directory', 'set-working-directory', [CompletionResultType]::ParameterValue, 'Advise the terminal of the current working directory by emitting an OSC 7 escape sequence')
            [CompletionResult]::new('record', 'record', [CompletionResultType]::ParameterValue, 'Record a terminal session as an asciicast')
            [CompletionResult]::new('replay', 'replay', [CompletionResultType]::ParameterValue, 'Replay an asciicast terminal session')
            [CompletionResult]::new('shell-completion', 'shell-completion', [CompletionResultType]::ParameterValue, 'Generate shell completion information')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'wezterm;help;start' {
            break
        }
        'wezterm;help;ssh' {
            break
        }
        'wezterm;help;serial' {
            break
        }
        'wezterm;help;connect' {
            break
        }
        'wezterm;help;ls-fonts' {
            break
        }
        'wezterm;help;show-keys' {
            break
        }
        'wezterm;help;cli' {
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'list windows, tabs and panes')
            [CompletionResult]::new('list-clients', 'list-clients', [CompletionResultType]::ParameterValue, 'list clients')
            [CompletionResult]::new('proxy', 'proxy', [CompletionResultType]::ParameterValue, 'start rpc proxy pipe')
            [CompletionResult]::new('tlscreds', 'tlscreds', [CompletionResultType]::ParameterValue, 'obtain tls credentials')
            [CompletionResult]::new('move-pane-to-new-tab', 'move-pane-to-new-tab', [CompletionResultType]::ParameterValue, 'Move a pane into a new tab')
            [CompletionResult]::new('split-pane', 'split-pane', [CompletionResultType]::ParameterValue, 'split the current pane.
Outputs the pane-id for the newly created pane on success')
            [CompletionResult]::new('spawn', 'spawn', [CompletionResultType]::ParameterValue, 'Spawn a command into a new window or tab
Outputs the pane-id for the newly created pane on success')
            [CompletionResult]::new('send-text', 'send-text', [CompletionResultType]::ParameterValue, 'Send text to a pane as though it were pasted. If bracketed paste mode is enabled in the pane, then the text will be sent as a bracketed paste')
            [CompletionResult]::new('activate-pane-direction', 'activate-pane-direction', [CompletionResultType]::ParameterValue, 'Activate an adjacent pane in the specified direction')
            break
        }
        'wezterm;help;cli;list' {
            break
        }
        'wezterm;help;cli;list-clients' {
            break
        }
        'wezterm;help;cli;proxy' {
            break
        }
        'wezterm;help;cli;tlscreds' {
            break
        }
        'wezterm;help;cli;move-pane-to-new-tab' {
            break
        }
        'wezterm;help;cli;split-pane' {
            break
        }
        'wezterm;help;cli;spawn' {
            break
        }
        'wezterm;help;cli;send-text' {
            break
        }
        'wezterm;help;cli;activate-pane-direction' {
            break
        }
        'wezterm;help;imgcat' {
            break
        }
        'wezterm;help;set-working-directory' {
            break
        }
        'wezterm;help;record' {
            break
        }
        'wezterm;help;replay' {
            break
        }
        'wezterm;help;shell-completion' {
            break
        }
        'wezterm;help;help' {
            break
        }
    })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}
