####################################################################################################
# Be sure to run this script from the same directory you as the log files
# Be sure to manually add "split_this_" in front of the logs you want to split
# so that the script doesn't try to modify active CPM  log files
####################################################################################################

$linecount = 0
$filenumber = 1

$folder = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

$PMlogFile = Get-ChildItem $folder -Filter "split_this_pm*.log" | Where-Object {$_.Name -notlike "*error*"} | % {$_.Name}
$PMErrorlogFile = Get-ChildItem $folder -Filter "split_this_pm_error*.log" | Where-Object {$_.Name -like "*error*"} | % {$_.Name}
$destinationPath = "$folder\logSplits"

# Number of lines to split by
[int]$splitLines=30000

Function PMSplit($logFile, $destination, $splitLines){
                $valid = Test-Path $destination
                If ($valid -eq $False){
                                New-Item $destination -type Directory
                }
    
                $filebasename=$logFile.Split(".")[0]
    
                Write-Host "Writing part: $destination\$filebasename`_part$filenumber.log"
                $content = Get-Content $logFile | % {
                
                Add-Content $destination\$filebasename`_part$filenumber.log "$_"
                $linecount ++
                                If ($linecount -eq $splitLines) {
                                                $filenumber++
                                                $linecount = 0
                                                Write-Host "Writing part: $destination\$filebasename`_part$filenumber.log"
                                }
                }
}

Function PMErrorSplit($logFile, $destination, $splitLines){
                $splitLineErr=$splitLines/2
                $valid = Test-Path $destination
                If ($valid -eq $False){
                                New-Item $destination -type Directory
                }

                $filebasename=$logFile.Split(".")[0]
                Write-Host "Writing part: $destination\$filebasename`_part$filenumber.log"

    $content = Get-Content $logFile | % {
                
                Add-Content $destination\$filebasename`_part$filenumber.log "$_"
                $linecount ++
                                If ($linecount -eq $splitLinesErr) {
                                                $filenumber++
                                                $linecount = 0
                                                Write-Host "Writing part: $destinationPath\$filebasename`_part$filenumber.log"
                                }
                }
}

PMSplit $PMlogFile $destinationPath $splitLines
PMErrorSplit $PMErrorlogFile $destinationPath $splitLines
