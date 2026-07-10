# Note

A tiny, zero-dependency PowerShell script for jotting down daily text notes on Windows.

## What it does

- `note something you want to jot down` — appends the text to today's note file
- `Get-Clipboard | note` — appends piped/multiline input
- `note` — opens today's file in your editor

Files are saved as `YYYY-MM-DD.txt` in `$env:NOTE_DIR` (or the current directory if unset).

## Install

1. Save `note.ps1` somewhere permanent, e.g. `C:\Users\<you>\scripts\note.ps1`
2. Add this to your PowerShell profile (`notepad $PROFILE`):

   ```powershell
   function note { & "C:\Users\<you>\scripts\note.ps1" @args }
   ```
3. Restart your terminal.

If scripts are blocked, run once:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

## Configure (optional)

Add to your profile:

```powershell
$env:NOTE_DIR = "D:\notes"   # where daily files are saved
$env:EDITOR = "nvim"         # editor used when `note` runs with no args (defaults to notepad)
```

