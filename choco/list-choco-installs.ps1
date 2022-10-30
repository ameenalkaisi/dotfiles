#!/usr/bin/env powershell -File
choco list -lo -r -y | % { "choco install $($_.SubString(0, $_.IndexOf("|"))) -y" } | Out-File Install.ps1
