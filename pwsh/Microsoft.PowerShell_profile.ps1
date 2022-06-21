if ($host.Name -eq 'ConsoleHost') {
	oh-my-posh init pwsh --config "C:\Program Files (x86)\oh-my-posh\themes\huvix.omp.json" | Invoke-Expression
	Import-Module -Name PSReadLine
	Import-Module -Name Terminal-Icons
	
	Set-PSReadLineOption -EditMode Vi -ViModeIndicator Cursor
	Set-PSReadLineOption -PredictionSource History
	Set-PSReadlineKeyHandler -Chord "Ctrl+Oem4" -Function ViCommandMode
}
