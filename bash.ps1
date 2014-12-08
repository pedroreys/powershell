Write-Verbose "Running .bash.ps1"

Write-Verbose "Sourcing posh-git\profile.example.ps1" 
. $HOME\.powershell\posh-git\profile.example.ps1

Write-Verbose "Sourcing posh-hg\profile.example.ps1"
. $HOME\.powershell\posh-hg\profile.example.ps1

Write-Verbose "Sourcing scripts/alias.ps1"
. $HOME\.powershell\scripts\alias.ps1 

Write-Verbose "Sourcing scripts/util.ps1"
. $HOME\.powershell\scripts\utils.ps1

Write-Verbose "Finished running .bash.ps1"
