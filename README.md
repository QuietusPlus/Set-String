# Set-String

Replaces one or multiple specified strings within a file or a directory of files.

## Examples

### Single File

```PowerShell
C:\PS> Set-String -Path .\Examples\Example-FileToProcess.txt -Find 'sad' -Replace 'happy'
```

### Directory of Files (Filtered)

```PowerShell
C:\PS> Set-String -Path .\Examples -FileType txt -Find 'sad' -Replace 'happy'
```

### Multiple Strings: Hashtable

```PowerShell
C:\PS> Set-String -Path .\Examples -FileType txt -List @{ 'sad' = 'happy'; 'me' = 'you'; 'regular' = 'special' }
```

### Multiple Strings: Comma Separated Values (.csv)

```PowerShell
C:\PS> Set-String -Path .\Examples -FileType txt -List .\Examples\Example-FindReplaceList.csv
```

The example .csv is available at the following location: [Example-FindReplaceList.csv](Examples/Example-FindReplaceList.csv)
