Push-Location $psScriptRoot

Write-Verbose "Running .bash.ps1"

Write-Verbose "Sourcing posh-git\profile.example.ps1" 
. .\posh-git\profile.example.ps1

Import-Module .\scripts\dot-files -DisableNameChecking

Write-Verbose "Finished running .bash.ps1"

function Reload-Module(){
   [CmdletBinding()]
   param()
   Write-Verbose "Reloading dot-files module"
   Import-Module $psScriptRoot\scripts\dot-files -force -DisableNameChecking
}

Set-Alias -Name reload -Value Reload-Module -force -Option AllScope -Scope Global

Pop-Location