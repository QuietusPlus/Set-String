<#
    Test-File
#>

# Include
. .\..\Set-String.ps1

# Process
Set-String -Path .\Example-FileToProcess.txt -Find 'sad' -Replace 'happy'
