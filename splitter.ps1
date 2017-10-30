$linecount = 0
$filenumber = 1

#Make sure to add "split_this_" in front of the error logs

$folder = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

$PMlogFile = Get-ChildItem $folder -Filter "split_this_pm*.log" | Where-Object {$_.Name -notlike "*error*"} | % {$_.Name}
$PMErrorlogFile = Get-ChildItem $folder -Filter "split_this_pm_error*.log" | Where-Object {$_.Name -like "*error*"} | % {$_.Name}
$destinationPath = "C:\Users\singhn15\Desktop\test\logSplits"

# Number of lines to split by
[int]$splitLines=15000

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
                                                Write-Host "Writing part: $destinationPath\$filebasename`_part$filenumber.log"
                                }
                }
}

PMSplit $PMlogFile $destinationPath $splitLines
PMErrorSplit $PMErrorlogFile $destinationPath $splitLines
