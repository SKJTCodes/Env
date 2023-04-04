# Setup Variables - User specified
$DevFolder = "D:\Dev"  # Location of folder to setup environment in
$SetupDrive = "E:"  # Set Drive Letter as a shortcut to DevFolder

$Env:SETENVPATH = "$SetupDrive/SetEnv"

Write-Verbose "Original Development Path: $DevFolder"
Write-Verbose "New Dev Path: $SetupDrive"
