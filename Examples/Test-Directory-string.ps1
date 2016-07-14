<#
    Test-Directory-string
#>

# Include
. .\..\Set-String.ps1

# Process
Set-String -Path .\ -FileType txt -Find 'sad' -Replace 'happy'
