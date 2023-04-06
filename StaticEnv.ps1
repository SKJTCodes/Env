# Setup Variables - User specified
$DevFolder = "D:\Dev"  # Location of folder to setup environment in
$SetupDrive = "E:"  # Set Drive Letter as a shortcut to DevFolder
$RepoPath = "H:\My Drive\Repo"  # Location to create Repo Folder. I'm creating it within my google drive

$Env:SETENVPATH = "$SetupDrive/SetEnv"
$ErrorActionPreference = "Stop"

Write-Verbose "Original Development Path: $DevFolder"
Write-Verbose "New Dev Path: $SetupDrive"
