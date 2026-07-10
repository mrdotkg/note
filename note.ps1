<#
.SYNOPSIS
    Append quick notes from the terminal into a daily note file.
.DESCRIPTION
    Usage:
      note something you want to jot down   (appends the text to today's file)
      Get-Clipboard | note                  (appends piped/multiline input)
      note                                  (opens today's file in your editor)
    Produces:
      YYYY-MM-DD.txt in $env:NOTE_DIR (defaults to the current directory)
#>
param(
	[Parameter(ValueFromRemainingArguments = $true)]
	[string[]]$Text
)

$ErrorActionPreference = "Stop"

$NoteDir = if ($env:NOTE_DIR) {
 $env:NOTE_DIR 
}
else {
 (Get-Location).Path 
}
if (-not (Test-Path -Path $NoteDir -PathType Container)) {
	New-Item -ItemType Directory -Path $NoteDir -Force | Out-Null
}

$NotePath = Join-Path $NoteDir ((Get-Date -Format "yyyy-MM-dd") + ".txt")

if ($Text.Count -eq 0) {
	if ([Console]::IsInputRedirected) {
		$piped = [Console]::In.ReadToEnd()
		Add-Content -Path $NotePath -Value ($piped.TrimEnd() + "`n")
	}
	else {
		$Editor = if ($env:EDITOR) {
			$env:EDITOR 
		}
		else {
			"notepad" 
		}
		& $Editor $NotePath
	}
}
else {
	Add-Content -Path $NotePath -Value (($Text -join " ") + "`n")
}
