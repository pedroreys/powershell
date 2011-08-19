## Connect-Computer.ps1
## Interact with a service on a remote TCP port
param(
    [string] $remoteHost = "localhost",
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
