<#
    Test-Directory-csv
#>

# Include
. .\..\Set-String.ps1

# Process
Set-String -Path .\ -FileType txt -List .\Example-FindReplaceList.csv
