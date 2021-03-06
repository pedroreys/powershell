function ImportVerbose{
   [CmdletBinding()]
   param([string]$functionName)
   Write-Verbose "Importing function '$functionName'"
}

#creates a function to have mklink working within powershell. 
#No need to "Well, actually" me. I know it's not technically within powershell, but you get the idea
ImportVerbose("mklink")
function mklink($link,$target)
{
	cmd /c mklink $link $target
}

#Powershel doesn't have telnet client. Windows 7 have telnet client disabled by default.
# This is a function that I found on http://bit.ly/posh-telnet to connect to a server via TCP.
ImportVerbose("telnet")
function telnet
{
	<# 
	.SYNOPSIS
	This is a telnet client
	
	.DESCRIPTION
	This function is used to connect to a server via TCP.
	By default it connects to "localhost" on port 23.
	
	.PARAMETER remoteHost
	Address of the remote host to connect to
	
	.PARAMETER port
	Port on the server to connect into
	
	.Example
	telnet www.example.com 1234 
	Connects to server www.example.com on port 1234
	
	.Example 
	telnet -H www.example.com 
	Connects to server www.example.com on port 23
	
	.Example
	telnet -p 8086
	Connects to localhost on port 8086
	
	.LINK
	http://bit.ly/posh-telnet	
	#>
	
	param(
			[alias("H")]
			[string] $remoteHost = "localhost",
			
			[alias("p")]
			[int] $port = 23			
		 ) 
	
		
	try
	{
		## Open the socket, and connect to the computer on the specified port
		write-host "Connecting to $remoteHost on port $port"
		$socket = new-object System.Net.Sockets.TcpClient($remoteHost, $port)
		if($socket -eq $null) { return; } 

		$stream = $socket.GetStream()
		$writer = new-object System.IO.StreamWriter($stream) 

		$buffer = new-object System.Byte[] 1024
		$encoding = new-object System.Text.AsciiEncoding 

		while($true)
		{
		   ## Allow data to buffer for a bit
		   start-sleep -m 500 

		   ## Read all the data available from the stream, writing it to the
		   ## screen when done.
		   while($stream.DataAvailable)
		   {
			  $read = $stream.Read($buffer, 0, 1024)
			  write-host -n ($encoding.GetString($buffer, 0, $read))
		   } 

		   ## Read the user's command, quitting if they hit ^D
		   $command = read-host 

		   ## Write their command to the remote host
		   $writer.WriteLine($command)
		   $writer.Flush()
		}
	}
	finally
	{
		## Close the streams
		$writer.Close()
		$stream.Close()
	}
		
		
}

ImportVerbose("Get-DotNetFxVersion")
function Get-DotNetFxVersion(){
    Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse |
    Get-ItemProperty -name Version -EA 0 |
    Where { $_.PSChildName -match '^(?!S)\p{L}'} |
    Select PSChildName, Version
}

# Overrides cd so that it runs a profile script whenever user changes into a user directory
# The intention for this is to make sure that I can, for example, set environment variables specific
# to a project that I'm working on whenever I go into the projects directory

ImportVerbose("Change-DirectoryWithInitScript")
function Change-DirectoryWithInitScript(){
    [CmdletBinding()]
    param(
        $path
    )

    if(Test-Path $path){
        $path = Resolve-Path $path
        $initScript = Get-ChildItem -Path $path -Filter .init.ps1 | % { $_.FullName } 
	     
        if($initScript){
            Write-Verbose "Executing: $initScript"
            & $initScript
        }
        
        Set-Location $path
	     Get-ChildItem
    } else {
      Set-Location $path
    }
}

function Get-Definition(){
    [CmdletBinding()]
    param(
        [string]$cmdName
    )

    $cmd = Get-Command $cmdName

    Write-Verbose "Command Type is $($cmd.CommandType)"
    if($cmd.CommandType -eq "Alias") {
        Write-Verbose "Returning definition of ResolvedCommand $($cmd.ResolvedCommandName)"
	$cmd = $cmd.ResolvedCommand
    }

    Write-Host $cmd.Definition
    
}

Set-Alias -Name def -Value Get-Definition -Force -Option AllScope -Scope Global

Write-Verbose "Changing 'cd' alias to 'Change-DirectoryWithInitScript'"
Set-Item alias:cd -Value 'Change-DirectoryWithInitScript'

ImportVerbose("GitVerbose")
function Git-Verbose(){
   [CmdletBinding()]
   param(
      $disable
   )
   
   Write-Host "Disable: $disable"
   $value = 1;
   if($disable){
      $value = 0
   }
   Write-Host "Setting GIT_CURL_VERBOSE=$value"
   $env:GIT_CURL_VERBOSE=$value
}

Set-Alias -Name gitVerbose -Value Git-Verbose -Force -Option AllScope -Scope Global
