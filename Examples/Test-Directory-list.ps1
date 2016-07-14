<#
    Test-Directory-list
#>

# Include
. .\..\Set-String.ps1

# Process
Set-String -Path .\ -FileType txt -List @{ 'sad' = 'happy'; 'me' = 'you'; 'regular' = 'special' }
