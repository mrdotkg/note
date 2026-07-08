# Note

A zero dependency PowerShell script that makes it really simple to manage your
text notes on Windows, with no extra installation or configuration.

Instead of trying to impose a whole bunch of rules and syntax requirements,
this tool does its best to get out of your way.

It tries to do everything possible so that if you're working in a terminal, you
can save whatever text you want into a file. This could come from typing a
sentence out, pasting something from your clipboard or saving the output of a
program.

## Design Goals and Philosophy

When it comes to jotting down notes it's always best to do everything possible
to keep friction low.

That means not worrying about specific file types, formatting, tagging,
check boxes, syntax rules and a bunch of other things that delay you from
getting something out of your head and into a document.

### Text is amazing for notes because:

- You can use `Select-String` (or `grep` if you have it) to search through it later
- Even with notes dating back years, you're only using a tiny amount of disk space
- It's really easy to back up and sync to other devices using Drop Box or similar tools

Since it's unstructured text you can use this tool for whatever type of note
taking you want. You can keep track of general thoughts, create a diary or make
plan files similar to what John Carmack did [for a number of
years](https://github.com/ESWAT/john-carmack-plan-archive).

### Your notes are organized by auto-dated files

Let's say it's December 25th, 2019. If you were to run `note hello world` it
would create a `2019-12.txt` file in your `NOTES_DIRECTORY` (this is
something you can configure). It would then append `hello world` to the end of
the file.

If you run `note something else` on the next day it will still append to the
same file and continue appending to that file until the next months hits. For
example, on January 1st 2020 any `note` commands will append to a
`2020-01.txt` file.

There's other things you can do such as piping input to it, or running the
script without any arguments to open the file in your configured `$env:EDITOR`
but let's first go over installing it before we get to that.

### What is this script not good for?

Depending on how you work, it's probably not ideal for grouping up a bunch of
extended thoughts about a specific topic.

For example, if you were planning to write a book and you spent 3 months
gathering info about what you're writing about then you would end up with a
bunch of isolated date formatted files that was mixed in with everything else.

In those cases, I recommend you make a new script called `book` which basically
does what this script does except it always dumps everything to 1 specific file
of your choosing which isn't dated.

## Installation

This is a pure PowerShell script, so it runs on Windows out of the box with no
extra tools, WSL, or Git Bash needed.

### 1. Save the script

Save `note.ps1` somewhere permanent, for example:

```
C:\Users\<you>\scripts\note.ps1
```

### 2. Add a `note` command to your profile

Open your PowerShell profile:

```powershell
notepad $PROFILE
```

Add this line (adjust the path to wherever you saved the script):

```powershell
function note { & "C:\Users\<you>\scripts\note.ps1" @args }
```

Save the file and restart your terminal (or run `. $PROFILE` to reload it).

### 3. Allow the script to run (one time only)

If you get an error saying scripts are disabled, run this once:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

### Configuration

By default it will use `$HOME\notes` as your notes directory and if that
directory doesn't exist beforehand, this script will allow you to create it
with a `y/n` prompt when you first run the program.

You can customize your notes path by setting an environment variable in your
PowerShell profile:

```powershell
$env:NOTES_DIRECTORY = "D:\example"
```

Also, if you want this script to open your notes in your code editor you'll
want to set `$env:EDITOR` in your profile too:

```powershell
$env:EDITOR = "nvim"
```

If `$env:EDITOR` isn't set, it falls back to opening the file in Notepad.

*If you change your profile, don't forget to restart your terminal.*

## Usage Examples

There's 3 ways of using this script:

- `note something you want to jot down`
  - Appends whatever arguments you add as text into the dated file

- `Get-Clipboard | note`
  - Pipes and appends anything (in this case your clipboard's contents) into the dated file

- `note`
  - Opens the dated file in your configured `$env:EDITOR` (or Notepad)

That's really all there is to it. With the above 3 ways of adding notes you'll
find yourself adding all sorts of different types of notes with very little
friction.

You also have the power of PowerShell at your fingertips to manipulate these
files however you see fit. For example you can run `Get-Content 2019-*.txt |
Set-Content 2019.txt` to create a yearly file.

## Credits

This is a PowerShell port of [nickjj/notes](https://github.com/nickjj/notes),
a POSIX shell script originally written by [Nick
Janetakis](https://nickjanetakis.com/). All credit for the original design and
philosophy goes to him — this version just adapts it to run natively on
Windows.
