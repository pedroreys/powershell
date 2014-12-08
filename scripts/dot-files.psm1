Push-Location $psScriptRoot

$orig_cd = (Get-Alias -Name 'cd').Definition

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
   Write-Verbose "Unloading Module"
   Set-Item alias:cd -Value $orig_cd
}

. .\alias.ps1

. .\utils.ps1

Pop-Location

Export-ModuleMember -Function * -Alias *