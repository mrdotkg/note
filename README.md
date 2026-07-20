# note

A tiny, zero-dependency daily notes tool — one script for bash (WSL/Linux/macOS), one for PowerShell (native Windows). No plugins, no databases, no config files. Just plain text, dated by day, wherever you want it.

## What it does

- `note something you want to jot down` — appends the text to today's note file
- `Get-Clipboard | note` (PowerShell) or `pbpaste | note` (bash) — appends piped/multiline input
- `note` (no args, no pipe) — opens today's file in your editor

Files are saved as `YYYY-MM-DD[.ext]` in `NOTE_DIR` (or the current directory if unset).

## Configure

| Variable    | Purpose                                              | Default              |
|-------------|-------------------------------------------------------|-----------------------|
| `NOTE_DIR`  | Where daily files are saved                            | current directory     |
| `NOTE_EXT`  | Extension for note files (e.g. `txt`, `md`)            | none — no extension   |
| `EDITOR`    | Editor opened when `note` runs with no args/input      | `notepad` / `nano`    |

## Install — PowerShell (Windows)

1. Save `note.ps1` somewhere permanent, e.g. `C:\Users\<you>\scripts\note.ps1`
2. Add this to your PowerShell profile (`notepad $PROFILE`):

   ```powershell
   Set-Alias -Name note -Value "C:\Users\<you>\scripts\note.ps1"
   ```
3. Restart your terminal.

> Use `Set-Alias`, not a wrapper `function`. A function like `function note { & note.ps1 @args }` does **not** forward pipeline input — `Get-Clipboard | note` would silently fail to append the clipboard. `Set-Alias` calls the script directly, so piping works as expected.

If scripts are blocked, run once:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

## Install — bash (WSL / Linux / macOS)

1. Save `note.sh` somewhere permanent, e.g. `~/scripts/note.sh`
2. Make it executable and alias it in `~/.bashrc`:

   ```bash
   chmod +x ~/scripts/note.sh
   alias note="$HOME/scripts/note.sh"
   ```
3. Reload: `source ~/.bashrc`

> Editing `note.sh` on Windows? Make sure it's saved with LF line endings, not CRLF — a stray `\r` in the shebang will break it (`env: 'sh\r': No such file or directory`). Fix with `sed -i 's/\r$//' note.sh` if this happens.

## Example setup (bash + PowerShell sharing one folder)

**`~/.bashrc` (WSL):**
```bash
export NOTE_DIR="/mnt/c/Users/<you>/Github/notes"
export NOTE_EXT="txt"
export EDITOR="nvim"
alias note="$HOME/scripts/note.sh"
```

**PowerShell `$PROFILE`:**
```powershell
$env:NOTE_DIR = "C:\Users\<you>\Github\notes"
$env:NOTE_EXT = "txt"
$env:EDITOR = "nvim"
Set-Alias -Name note -Value "C:\Users\<you>\scripts\note.ps1"
```

Same `NOTE_DIR`, same files — jot from either shell, land in one place.

## Why this exists

Most "note-taking apps" want you to pick a format, learn a query language, or sync through someone else's cloud. This is the opposite bet: notes are just dated `.txt` files on disk, `note` is under 30 lines in either shell, and there's nothing to break, update, or migrate away from ten years from now. If you can `cat`, `grep`, or `Select-String` a text file, you already know how to use your whole notes archive.

## Credits

Ported and extended from [nickjj/notes](https://github.com/nickjj/notes) by [Nick Janetakis](https://nickjanetakis.com/) — adapted into a cross-shell (bash + PowerShell) pair with configurable directory and extension, so it runs natively on both WSL and Windows with zero extra installs.
