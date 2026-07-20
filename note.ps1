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
$ErrorActionPreference = "Stop"

$NoteDir = if ($env:NOTE_DIR) { $env:NOTE_DIR } else { (Get-Location).Path }
New-Item -ItemType Directory -Path $NoteDir -Force | Out-Null

$NoteExt = if ($env:NOTE_EXT) { "." + $env:NOTE_EXT.TrimStart(".") } else { "" }
$NotePath = Join-Path $NoteDir ((Get-Date -Format "yyyy-MM-dd") + $NoteExt)

# No param() block on purpose: $args holds positional text ("note hello world"),
# $input holds piped pipeline objects (Get-Clipboard | note). Declaring a typed
# param() here would make PowerShell try (and fail) to bind piped input to it.
$Piped = @($input)

if ($args.Count -gt 0) {
    Add-Content -Path $NotePath -Value (($args -join " ") + "`n")
}
elseif ($Piped.Count -gt 0) {
    Add-Content -Path $NotePath -Value (($Piped -join "`n") + "`n")
}
else {
    $Editor = if ($env:EDITOR) { $env:EDITOR } else { "notepad" }
    & $Editor $NotePath
}
