function CreatePrinterPort { 
$server = $args[0] 
$port = ([WMICLASS]“.ROOTcimv2:Win32_TCPIPPrinterPort”).createInstance() 
$port.Name= $args[1] 
$port.SNMPEnabled=$false 
$port.Protocol=2 
$port.HostAddress= $args[2] 
$port.Put() 
}

function CreatePrinter { 
$server = $args[0] 
$print = ([WMICLASS]“.ROOTcimv2:Win32_Printer”).createInstance() 
$print.drivername = $args[1] 
$print.PortName = $args[1] 
$print.Shared = $true 
$print.Published = $false 
$print.Sharename = $args[3] 
$print.Location = $args[4] 
$print.Comment = $args[5] 
$print.DeviceID = $args[6] 
$print.Put() 
}

$printers = Import-Csv “c:\scripttemp\printers.csv”

foreach ($printer in $printers) { 
CreatePrinterPort $printer.Printserver $printer.Portname $printer.IPAddress 
CreatePrinter $printer.Printserver $printer.Driver $printer.Portname $printer.Sharename $printer.Location $printer.Comment $printer.Printername 
}