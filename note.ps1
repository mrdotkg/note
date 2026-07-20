<#
.SYNOPSIS
    Append quick notes from the terminal into a daily note file.
.DESCRIPTION
    Usage:
      note something you want to jot down   (appends the text to today's file)
      Get-Clipboard | note                  (appends piped/multiline input)
      note                                  (opens today's file in your editor)
    Produces:
      YYYY-MM-DD[.ext] in $env:NOTE_DIR (defaults to the current directory)
      Extension comes from $env:NOTE_EXT (e.g. "txt" or "md"); unset = no extension.
#>
[CmdletBinding()]
param(
    [Parameter(ValueFromPipeline = $true)]
    [string[]]$PipedText,

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Text
)

begin {
    $CollectedPiped = @()
}

process {
    if ($PipedText) { $CollectedPiped += $PipedText }
}

end {
    $ErrorActionPreference = "Stop"

    $NoteDir = if ($env:NOTE_DIR) { $env:NOTE_DIR } else { (Get-Location).Path }
    New-Item -ItemType Directory -Path $NoteDir -Force | Out-Null

    $NoteExt = if ($env:NOTE_EXT) { "." + $env:NOTE_EXT.TrimStart(".") } else { "" }
    $NotePath = Join-Path $NoteDir ((Get-Date -Format "yyyy-MM-dd") + $NoteExt)

    if ($Text.Count -gt 0) {
        Add-Content -Path $NotePath -Value (($Text -join " ") + "`n")
    }
    elseif ($CollectedPiped.Count -gt 0) {
        Add-Content -Path $NotePath -Value (($CollectedPiped -join "`n") + "`n")
    }
    else {
        $Editor = if ($env:EDITOR) { $env:EDITOR } else { "notepad" }
        & $Editor $NotePath
    }
}
