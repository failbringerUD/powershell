#########################################################
# Title: PS Event Viewer                                #
# Created by: Nathan Kasco - https://nkasco.com         #
# Date: 4/25/2018                                       #
#########################################################

$ErrorActionPreference = "SilentlyContinue"

function Get-LogResults{
    Param
    (
        [String]
            $ComputerName = $env:COMPUTERNAME,
        [String]
            $LogName,
        [int[]]
            $EventID,
        [String[]]
            $EntryType,
        [DateTime]
           $Time = (Get-Date).AddDays(-2),
        [String[]]
           $Source,
        [String[]]
          $Keyword
    )

    #Build query
    $Params = @{}
    if($EventID) { $Params["InstanceID"] = $EventID }
    if($EntryType) { $Params["EntryType"] = $EntryType }
    if($Source) { $Params["Source"] = $Source }
    if($Keyword) { $Params["Message"] = $Keyword }
    Get-EventLog -ComputerName $ComputerName -LogName $LogName -After $Time @Params
}

function Save-Results{
    if($Script:Results -ne $null){
        $SavePath = Select-FolderDialog

        if($SavePath){
            $Script:Results | Export-Csv "$SavePath\EventViewerResults.csv" -NoTypeInformation
        }
    }
}

Function Start-BackgroundJob {
	param(
		[ScriptBlock]
			$Job = {},
		[HashTable]
			$JobVariables = @{}
	)
    
    #Create our runspace & a powershell object to run in
	$Runspace = [runspacefactory]::CreateRunspace()
	$Runspace.Open()
	
	$Powershell = [powershell]::Create()
	$Powershell.Runspace = $Runspace
    
    #Add code for the function to be run
	$Powershell.AddScript($Job) | Out-Null
    
    #Send variables across pipeline 1 by 1 and make them available for our imported function
	foreach ($Variable in $JobVariables.GetEnumerator()) {
		$Powershell.AddParameter($Variable.Name, $Variable.Value) | Out-Null
	}
	
	#Start job
	$BackgroundJob = $Powershell.BeginInvoke()
    
	#Wait for code to complete and keep UI responsive
	do {
		[System.Windows.Forms.Application]::DoEvents()
		Start-Sleep -Milliseconds 1
	} while (!$BackgroundJob.IsCompleted)
    
    $Result = $Powershell.EndInvoke($BackgroundJob)
	
	#Clean up
	$Powershell.Dispose() | Out-Null
	$Runspace.Close() | Out-Null
    
    #Return our results to the GUI
	$Result
}

Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
 
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
 
function Show-Console {
   $consolePtr = [Console.Window]::GetConsoleWindow()
  #5 show
 [Console.Window]::ShowWindow($consolePtr, 5) > $Null
}
 
function Hide-Console {
    $consolePtr = [Console.Window]::GetConsoleWindow()
  #0 hide
 [Console.Window]::ShowWindow($consolePtr, 0) > $Null
}

Function Select-FolderDialog{
    param([string]$Description="Select Folder",[string]$RootFolder="Desktop")

    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null     

    $objForm = New-Object System.Windows.Forms.FolderBrowserDialog
    $objForm.Rootfolder = $RootFolder
    $objForm.Description = $Description
    $Show = $objForm.ShowDialog()
    if($Show -eq "OK") {
        Return $objForm.SelectedPath
    }
}

Hide-Console

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$ListViewLogResults_CellPainting = [System.Windows.Forms.DataGridViewCellPaintingEventHandler]{		
    if ($_.RowIndex -ge 0 -and $_.ColumnIndex -ge 0 -and $TextBoxFind.Text -ne "")
    {
        $_.Handled = $true
        $_.PaintBackground($_.CellBounds, $true)
        
        if ($sw = $TextBoxFind.Text)
        {
            [string]$val = $_.FormattedValue
            [int]$sindx = $val.ToLower().IndexOf($sw.ToLower())
            [int]$sCount = 1
            while ($sindx -ge 0)
            {
                $hl_rect = New-Object System.Drawing.Rectangle
                $hl_rect.Y = $_.CellBounds.Y + 2
                $hl_rect.Height = $_.CellBounds.Height - 5
                
                $sBefore = $val.Substring(0, $sindx)
                $sWord = $val.Substring($sindx, $sw.Length)
                $s1 = [System.Windows.Forms.TextRenderer]::MeasureText($_.Graphics, $sBefore, $_.CellStyle.Font, $_.CellBounds.Size)
                $s2 = [System.Windows.Forms.TextRenderer]::MeasureText($_.Graphics, $sWord, $_.CellStyle.Font, $_.CellBounds.Size)
                
                if ($s1.Width -gt 5)
                {
                    $hl_rect.X = $_.CellBounds.X + $s1.Width - 5
                    $hl_rect.Width = $s2.Width - 6
                }
                else
                {
                    $hl_rect.X = $_.CellBounds.X + 2
                    $hl_rect.Width = $s2.Width - 6
                }
                
                    $hl_brush = new-object System.Drawing.SolidBrush Yellow

                
                $_.Graphics.FillRectangle($hl_brush, $hl_rect)
                
                $hl_brush.Dispose()
                $sindx = $val.ToLower().IndexOf($sw.ToLower(), $sCount++)
            }
            
            $_.PaintContent($_.CellBounds)
        }
        
    }
}

#Create Form Objects
$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '800,600'
$Form.text                       = "PS Event Viewer"
$Form.TopMost                    = $false
$Form.MaximizeBox                = $false
$Form.SizeGripStyle              = "Hide"
$Form.FormBorderStyle = "FixedDialog"

$TextBoxKeywords                 = New-Object system.Windows.Forms.TextBox
$TextBoxKeywords.multiline       = $false
$TextBoxKeywords.width           = 99
$TextBoxKeywords.height          = 20
$TextBoxKeywords.location        = New-Object System.Drawing.Point(79,189)
$TextBoxKeywords.Font            = 'Microsoft Sans Serif,10'

$TextBoxEventID                  = New-Object system.Windows.Forms.TextBox
$TextBoxEventID.multiline        = $false
$TextBoxEventID.width            = 107
$TextBoxEventID.height           = 20
$TextBoxEventID.location         = New-Object System.Drawing.Point(71,159)
$TextBoxEventID.Font             = 'Microsoft Sans Serif,10'

$TextBoxSource                   = New-Object system.Windows.Forms.TextBox
$TextBoxSource.multiline         = $false
$TextBoxSource.width             = 116
$TextBoxSource.height            = 20
$TextBoxSource.location          = New-Object System.Drawing.Point(62,129)
$TextBoxSource.Font              = 'Microsoft Sans Serif,10'

$ComboBoxTime                    = New-Object system.Windows.Forms.ComboBox
$ComboBoxTime.width              = 130
$ComboBoxTime.height             = 20
$ComboBoxTime.location           = New-Object System.Drawing.Point(48,47)
$ComboBoxTime.Font               = 'Microsoft Sans Serif,10'
$ComboBoxTime.DropDownStyle      = 'DropDownList'
$TimePickerOptions               = "Today", "Last 2 days", "Last 3 days"
foreach($Picker in $TimePickerOptions){
    $ComboBoxTime.Items.Add($Picker)
}
$ComboBoxTime.SelectedIndex      = 2

$ComboBoxLogPicker               = New-Object system.Windows.Forms.ComboBox
$ComboBoxLogPicker.width         = 101
$ComboBoxLogPicker.height        = 20
$ComboBoxLogPicker.location      = New-Object System.Drawing.Point(77,14)
$ComboBoxLogPicker.Font          = 'Microsoft Sans Serif,10'
$LogPickerOptions                = "Application", "Security", "Setup", "System"
foreach($Picker in $LogPickerOptions){
    $ComboBoxLogPicker.Items.Add($Picker)
}
$ComboBoxLogPicker.DropDownStyle = 'DropDownList'
$ComboBoxLogPicker.SelectedIndex = 0

$TextBoxMachine                  = New-Object system.Windows.Forms.TextBox
$TextBoxMachine.multiline        = $false
$TextBoxMachine.text             = "Machine"
$TextBoxMachine.width            = 100
$TextBoxMachine.height           = 20
$TextBoxMachine.location         = New-Object System.Drawing.Point(691,6)
$TextBoxMachine.Font             = 'Microsoft Sans Serif,11'

$ButtonSave                      = New-Object system.Windows.Forms.Button
$ButtonSave.text                 = "Save Results"
$ButtonSave.width                = 180
$ButtonSave.height               = 30
$ButtonSave.location             = New-Object System.Drawing.Point(4,249)
$ButtonSave.Font                 = 'Microsoft Sans Serif,10'

$ButtonSubmit                    = New-Object system.Windows.Forms.Button
$ButtonSubmit.text               = "Fetch Results"
$ButtonSubmit.width              = 180
$ButtonSubmit.height             = 30
$ButtonSubmit.location           = New-Object System.Drawing.Point(4,216)
$ButtonSubmit.Font               = 'Microsoft Sans Serif,10'

$ButtonFind                      = New-Object system.Windows.Forms.Button
$ButtonFind.text                 = "Find"
$ButtonFind.width                = 43
$ButtonFind.height               = 22
$ButtonFind.location             = New-Object System.Drawing.Point(137,503)
$ButtonFind.Font                 = 'Microsoft Sans Serif,10'

$TextBoxFind                     = New-Object system.Windows.Forms.TextBox
$TextBoxFind.multiline           = $false
$TextBoxFind.width               = 116
$TextBoxFind.height              = 20
$TextBoxFind.location            = New-Object System.Drawing.Point(15,503)
$TextBoxFind.Font                = 'Microsoft Sans Serif,12'

$ButtonView1                     = New-Object system.Windows.Forms.Button
$ButtonView1.text                = "Traditional"
$ButtonView1.width               = 72
$ButtonView1.height              = 30
$ButtonView1.location            = New-Object System.Drawing.Point(8,561)
$ButtonView1.Font                = 'Microsoft Sans Serif,9'

$ButtonView2                     = New-Object system.Windows.Forms.Button
$ButtonView2.text                = "Side By Side"
$ButtonView2.width               = 86
$ButtonView2.height              = 30
$ButtonView2.location            = New-Object System.Drawing.Point(91,561)
$ButtonView2.Font                = 'Microsoft Sans Serif,9'

$LabelViewSetting                = New-Object system.Windows.Forms.Label
$LabelViewSetting.text           = "View Options:"
$LabelViewSetting.AutoSize       = $true
$LabelViewSetting.width          = 25
$LabelViewSetting.height         = 10
$LabelViewSetting.location       = New-Object System.Drawing.Point(8,541)
$LabelViewSetting.Font           = 'Microsoft Sans Serif,10'

$TextBoxLogResult                = New-Object system.Windows.Forms.TextBox
$TextBoxLogResult.multiline      = $true
$TextBoxLogResult.width          = 605
$TextBoxLogResult.height         = 278
$TextBoxLogResult.location       = New-Object System.Drawing.Point(187,313)
$TextBoxLogResult.Font           = 'Microsoft Sans Serif,10'
$TextBoxLogResult.ReadOnly       = $true
$TextBoxLogResult.ScrollBars     = "Vertical"

$ListViewLogResults              = New-Object System.Windows.Forms.DataGridView
$ListViewLogResults.text         = "listView"
$ListViewLogResults.width        = 605
$ListViewLogResults.height       = 269
$ListViewLogResults.location     = New-Object System.Drawing.Point(187,33)
$ListViewLogResults.MultiSelect  = $False
$ListViewLogResults.AutoSizeRowsMode = "DataGridViewAutoSizeRowsMode.None"
$ListViewLogResults.AllowUserToResizeRows = $False

$LabelTime                       = New-Object system.Windows.Forms.Label
$LabelTime.text                  = "Time:"
$LabelTime.AutoSize              = $true
$LabelTime.width                 = 25
$LabelTime.height                = 10
$LabelTime.location              = New-Object System.Drawing.Point(6,51)
$LabelTime.Font                  = 'Microsoft Sans Serif,10'

$LabelLogPicker                  = New-Object system.Windows.Forms.Label
$LabelLogPicker.text             = "Log Name:"
$LabelLogPicker.AutoSize         = $true
$LabelLogPicker.width            = 25
$LabelLogPicker.height           = 10
$LabelLogPicker.location         = New-Object System.Drawing.Point(6,16)
$LabelLogPicker.Font             = 'Microsoft Sans Serif,10'

$CheckBoxCritical                = New-Object system.Windows.Forms.CheckBox
$CheckBoxCritical.text           = "Critical"
$CheckBoxCritical.AutoSize       = $false
$CheckBoxCritical.width          = 63
$CheckBoxCritical.height         = 20
$CheckBoxCritical.location       = New-Object System.Drawing.Point(12,78)
$CheckBoxCritical.Font           = 'Microsoft Sans Serif,9'

$CheckBoxWarning                 = New-Object system.Windows.Forms.CheckBox
$CheckBoxWarning.text            = "Warning"
$CheckBoxWarning.AutoSize        = $false
$CheckBoxWarning.width           = 83
$CheckBoxWarning.height          = 20
$CheckBoxWarning.location        = New-Object System.Drawing.Point(91,78)
$CheckBoxWarning.Font            = 'Microsoft Sans Serif,9'

$CheckBoxError                   = New-Object system.Windows.Forms.CheckBox
$CheckBoxError.text              = "Error"
$CheckBoxError.AutoSize          = $false
$CheckBoxError.width             = 62
$CheckBoxError.height            = 20
$CheckBoxError.location          = New-Object System.Drawing.Point(12,103)
$CheckBoxError.Font              = 'Microsoft Sans Serif,9'

$CheckBoxInformation             = New-Object system.Windows.Forms.CheckBox
$CheckBoxInformation.text        = "Information"
$CheckBoxInformation.AutoSize    = $false
$CheckBoxInformation.width       = 87
$CheckBoxInformation.height      = 20
$CheckBoxInformation.location    = New-Object System.Drawing.Point(91,103)
$CheckBoxInformation.Font        = 'Microsoft Sans Serif,9'

$LabelSource                     = New-Object system.Windows.Forms.Label
$LabelSource.text                = "Source:"
$LabelSource.AutoSize            = $true
$LabelSource.width               = 25
$LabelSource.height              = 10
$LabelSource.location            = New-Object System.Drawing.Point(12,132)
$LabelSource.Font                = 'Microsoft Sans Serif,10'

$LabelEventID                    = New-Object system.Windows.Forms.Label
$LabelEventID.text               = "Event ID:"
$LabelEventID.AutoSize           = $true
$LabelEventID.width              = 25
$LabelEventID.height             = 10
$LabelEventID.location           = New-Object System.Drawing.Point(12,163)
$LabelEventID.Font               = 'Microsoft Sans Serif,10'

$LabelKeywords                   = New-Object system.Windows.Forms.Label
$LabelKeywords.text              = "Keywords:"
$LabelKeywords.AutoSize          = $true
$LabelKeywords.width             = 25
$LabelKeywords.height            = 10
$LabelKeywords.location          = New-Object System.Drawing.Point(12,192)
$LabelKeywords.Font              = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($TextBoxKeywords,$TextBoxEventID,$TextBoxSource,$ComboBoxTime,$ComboBoxLogPicker,$TextBoxMachine,$ButtonSave,$ButtonSubmit,$ButtonFind,$TextBoxFind,$ButtonView1,$ButtonView2,$LabelViewSetting,$TextBoxLogResult,$ListViewLogResults,$LabelTime,$LabelLogPicker,$CheckBoxCritical,$CheckBoxWarning,$CheckBoxError,$CheckBoxInformation,$LabelSource,$LabelEventID,$LabelKeywords))

$ListViewLogResults.Columns.Add("Type","Type")
$ListViewLogResults.Columns.Add("DateTime","DateTime")
$ListViewLogResults.Columns.Add("ID","ID")
$ListViewLogResults.Columns.Add("Source","Source")
$ListViewLogResults.Columns.Add("Message","Message")

#Form Events
$Form.Add_FormClosing({
    #Handles a hung GUI
    Stop-Process -Id $PID
})

$ButtonSubmit.Add_Click({
    $ButtonSubmit.Enabled = $False
    $ButtonSubmit.Text = "Loading..."

    #Build params
    $Params = @{}

    $EntryTypeBuilder = @()
    if($CheckBoxInformation.Checked) { $EntryTypeBuilder += "Information" }
    if($CheckBoxCritical.Checked) { $EntryTypeBuilder += "Error" }
    if($CheckBoxWarning.Checked) { $EntryTypeBuilder += "Warning" }
    if($CheckBoxError.Checked) { $EntryTypeBuilder += "Error" }
    switch($ComboBoxTime.SelectedItem.ToString()){
        "Today"{
            $Params["Time"] = Get-Date
        }

        "Last 2 days"{
            $Params["Time"] = (Get-Date).AddDays(-1)
        }

        "Last 3 days"{
            $Params["Time"] = (Get-Date).AddDays(-2)
        }
    }
    if($EntryTypeBuilder) { 
        $Params["EntryType"] = $EntryTypeBuilder
    } else {
        #Defaults to information if nothing was specified
        $Params["EntryType"] = "Information"
    }

    if($TextBoxMachine.Text -ne "Machine"){
        $Params["ComputerName"] = $TextBoxMachine.Text
    }
    $Params["LogName"] = $ComboBoxLogPicker.SelectedItem.ToString()
    if($TextBoxSource.Text -ne ""){ $Params["Source"] = $TextBoxSource.Text }
    if($TextBoxEventID.Text -ne ""){ $Params["EventID"] = $TextBoxEventID.Text }
    if($TextBoxKeywords.Text -ne ""){ $Params["Keyword"] = $TextBoxKeywords.Text }

    $Script:Results = Start-BackgroundJob -Job ${Function:Get-LogResults} -JobVariables $Params

    $Form.SuspendLayout()
    $ListViewLogResults.Rows.Clear()
    $TextBoxLogResult.Text = ""
    #Update the GUI
    foreach($Result in $Results){
        $ListViewLogResults.Rows.Add($Result.EntryType,$Result.TimeGenerated,$Result.InstanceId,$Result.Source,$Result.Message)
    }
    $Form.ResumeLayout()

    $ButtonSubmit.Text = "Fetch Results"
    $ButtonSubmit.Enabled = $True
})

$ListViewLogResults.Add_CellPainting($ListViewLogResults_CellPainting)

$TextBoxMachine.Add_Enter({
    if($TextBoxMachine.Text -eq "Machine") { $TextBoxMachine.Clear() }
})

$TextBoxMachine.Add_Leave({
    if($TextBoxMachine.Text -eq "") { $TextBoxMachine.Text = "Machine" }
})

$TextBoxFind.Add_TextChanged{
    $ListViewLogResults.Refresh()
    $ListViewLogResults.DataSource.DefaultView.RowFilter = "EntryID LIKE '*$($TextBoxFind.Text)*'"
}

$ButtonSave.Add_Click({
    Save-Results
})

$ListViewLogResults.Add_SelectionChanged({
    $Row = $ListViewLogResults.SelectedRows

    $TextBoxLogResult.Text = $Row.Cells[4].Value
})

$ButtonView2.Add_Click({
    $Form.SuspendLayout()
    $ListViewLogResults.width        = 392
    $ListViewLogResults.height       = 561
    $ListViewLogResults.location     = New-Object System.Drawing.Point(187,33)

    $TextBoxLogResult.width          = 208
    $TextBoxLogResult.height         = 561
    $TextBoxLogResult.location       = New-Object System.Drawing.Point(584,33)
    $Form.ResumeLayout()
})

$ButtonView1.Add_Click({
    $Form.SuspendLayout()
    $ListViewLogResults.width        = 605
    $ListViewLogResults.height       = 269
    $ListViewLogResults.location     = New-Object System.Drawing.Point(187,33)

    $TextBoxLogResult.width          = 605
    $TextBoxLogResult.height         = 278
    $TextBoxLogResult.location       = New-Object System.Drawing.Point(187,313)
    $Form.ResumeLayout()
})

#Show the form
[void]$Form.ShowDialog()