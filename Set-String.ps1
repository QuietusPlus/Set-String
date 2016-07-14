<#
    The MIT License (MIT)

    Copyright (c) 2016 QuietusPlus

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
#>

function Set-String ([string]$Path, [string]$FileType, [string]$List, [string]$Find, [string]$Replace) {
    <#
        .SYNOPSIS
            Replaces one or multiple specified strings within a file or a directory of files.

        .DESCRIPTION
            Replaces one or multiple specified strings within a file or a directory of files.

        .PARAMETER Path
            File or directory path.

        .PARAMETER FileType
            File type/extension.

        .PARAMETER List
            List of find and replace actions. Input can either be a .csv file or a hashtable.

        .PARAMETER Find
            String to find (only works if -List has been omitted)

        .PARAMETER Replace
            String to replace -Find  (only works if -List has been omitted)

        .EXAMPLE
            C:\PS> Set-String -Path C:\Path\To\File.txt -Find 'Find this text' -Replace 'Replace with this'

        .EXAMPLE
            C:\PS> Set-String -Path C:\Path\To\Directory -FileType txt -Find 'Find this text' -Replace 'Replace with this'

        .EXAMPLE
            C:\PS> Set-String -Path C:\Path\To\Directory -FileType txt -List @{ 'Original String 1' = 'Replaced String 1', 'Original String 2' = 'Replaced String 2', 'Original String 3' = 'Replaced String 3' }

        .EXAMPLE
            C:\PS> Set-String -Path C:\Path\To\Directory -FileType txt -List .\Examples\CommaSeparatedValues.csv

        .NOTES
            None

        .LINK
            https://quietusplus.github.io/Set-String/

        .LINK
            https://github.com/QuietusPlus/Set-String
    #>

    # Find and replace for a single file
    function Invoke-Replace ($FilePath, $ReplaceList) {
        # Get file and it's content
        $inputFile = Get-Item -Path $FilePath
        $content = Get-Content -Path $inputFile

        # Replace string(s) specified within the passed list
        $ReplaceList | ForEach-Object {
            $content = $content -replace $_.Find, $_.Replace
        }

        # Backup original file
        Copy-Item $FilePath "$FilePath.bak"

        # Save modified file
        Set-Content -Path $FilePath -Value $content
    }

    # Initialise find and replace object
    $inputFindReplace = @()

    # Process -List parameter
    switch ($List) {
        # Error if -List has been passed together with -Find or -Replace
        { $true -and ($Find -or $Replace) } {
            Write-Error 'Cannot process -List and -Find/-Replace at the same time.'
            break
        }

        # List is .csv
        { ($_ | Get-Item).Extension -eq '.csv' } {
            $csv = Import-Csv -Path $List
            foreach ($i in 0..$List.Count) {
                $inputFindReplace += New-Object PSObject -Property @{
                    Find = ($csv.Find)[$i]
                    Replace = ($csv.Replace)[$i]
                }; $i++
            }
            break
        }

        # List is hashtable
        { $_ -and ($List.pstypenames[0] -eq 'System.Collections.Hashtable') } {
            foreach ($i in 0..$List.Count) {
                $inputFindReplace += New-Object PSObject -Property @{
                    Find = ($List.Keys)[$i]
                    Replace = ($List.Values)[$i]
                }; $i++
            }
            break
        }

        # Otherwise use specified -Find and -Replace
        Default {
            $inputFindReplace += New-Object PSObject -Property @{
                Find = $inputFind
                Replace = $inputReplace
            }
            break
        }
    }

    # Process -Path parameter
    switch ($Path) {
        # Check if -Path is directory
        {$_ | Test-Path -PathType Container} {
            if (-not $FileType) {
                Write-Error 'Please specify -FileType when -Path is directory'
                break
            }

            foreach ($file in $(Get-ChildItem -Path $Path -Filter "*.$FileType" -Recurse).FullName) {
                Invoke-Replace -FilePath $file -ReplaceList $inputFindReplace
            }
            break
        }

        # Check if -Path is file
        {$_ | Test-Path -PathType Leaf} {
            Invoke-Replace -FilePath (Get-Item -Path $Path) -ReplaceList $inputFindReplace
            break
        }

        # Error if not a directory or file
        Default {
            Write-Error 'Supplied path is not a file or directory'
            break
        }
    }
}
