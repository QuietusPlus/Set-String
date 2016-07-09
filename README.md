# Set-String

Replaces one or multiple specified strings within a file or a directory of files.

## Examples

### Single File

```PowerShell
C:\PS> Set-String -Path C:\Path\To\File.txt -Find 'Find this text' -Replace 'Replace with this'
```

### Directory of Files (Filtered)

```PowerShell
C:\PS> Set-String -Path C:\Path\To\Directory -FileType txt -Find 'Find this text' -Replace 'Replace with this'
```

### Multiple Strings: Hashtable

```PowerShell
C:\PS> Set-String -Path C:\Path\To\Directory -FileType txt -List @{ 'Original String 1' = 'Replaced String 1', 'Original String 2' = 'Replaced String 2', 'Original String 3' = 'Replaced String 3' }
```

### Multiple Strings: Comma Separated Values (.csv)

```PowerShell
C:\PS> Set-String -Path C:\Path\To\Directory -FileType txt -List .\Examples\CommaSeparatedValues.csv
```
