$PipeIn = @($Input)
$ArgsIn = $args[0]

IF ($PipeIn) { $ComputerList = $PipeIn }
ELSE { $ComputerList = @($ArgsIn) }

$ResultsFile = ".\Results.csv"

$Header_CSV = "Computer,HasFilter,HasService,HasDriver"

FOREACH ($Computer IN $ComputerList)
{
	ping $Computer -n 1 -w 2500 > $NUL
	IF (!($?))
	{	#Computer is offline
		Write-Host $Computer -ForegroundColor Red
		$HasFilter = $NULL ; $HasService = $NULL ; $HasDriver = $NULL
	}
	ELSE
	{
		Write-Host $Computer -ForegroundColor Green
		$HasFilter = (REG QUERY "\\$Computer\HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e967-e325-11ce-bfc1-08002be10318}" /v UpperFilters 2>&1 | Select-String UpperFilters | Select-String "InDskFlt") -Or $False
		$HasService = (REG QUERY "\\$Computer\HKLM\SYSTEM\CurrentControlSet\Services\InDskFlt" /v Start 2>&1 | Select-String "0x0") -Or $False
		$HasDriver = Test-Path "\\$Computer\c$\Windows\System32\Drivers\InDskFlt.sys"
	}

	$Results = "$Computer,$HasFilter,$HasService,$HasDriver"

	IF (!(Test-Path ($ResultsFile))) { $Header_CSV | Out-File $ResultsFile -Encoding "ASCII" }

	#Append results to file. The try-catch handles file lock when multiple processes are trying to write simultaneously
	$Written = $FALSE
	WHILE (!$Written)
	{
		Try { $Results | Out-File $ResultsFile -Encoding "ASCII" -Append ; $Written = $TRUE }
		Catch { $Written = $FALSE }
	}
}