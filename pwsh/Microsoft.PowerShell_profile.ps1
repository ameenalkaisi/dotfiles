if ($host.Name -eq 'ConsoleHost') {
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

	Function OpenNotesNvim { neovide C:\Users\ameen\notes }
	New-Alias notes OpenNotesNvim

	Function OpenNvimConfig { neovide C:\Users\ameen\AppData\Local\nvim }
	New-Alias nvimconf OpenNvimConfig
}
