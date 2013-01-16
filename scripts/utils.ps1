#creates a function to have mklink working within powershell. 
#No need to "Well, actually" me. I know it's not technically within powershell, but you get the idea
function mklink($link,$target)
{
	cmd /c mklink $link $target
}

#Powershel doesn't have telnet client. Windows 7 have telnet client disabled by default.
# This is a function that I found on http://bit.ly/posh-telnet to connect to a server via TCP.
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

function reload {
    @(
        $Profile.AllUsersAllHosts,
        $Profile.AllUsersCurrentHost,
        $Profile.CurrentUserAllHosts,
        $Profile.CurrentUserCurrentHost
    ) | % {
        if(Test-Path $_){
            Write-Verbose "Running $_"
            . $_
        }
    }    
}