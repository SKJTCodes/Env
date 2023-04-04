# Setup Script Folder / Repo Folder
$Env:PRODPATH = "$SetupDrive\Prod"
$Env:REPOPATH = "$SetupDrive\Repo"
$Env:DEVPATH = "$SetupDrive\Dev"

# Check If E drive is setup. E drive is where i do my Development
If(!(Test-Path $SetupDrive)){
  write-info("$SetupDrive is not setup. Setting up $SetupDrive ...")
  # New-PsDrive -Name $SetupDrive.replace(":", "") -PSProvider FileSystem -Root $DevFolder
  subst $SetupDrive $DevFolder
  # New-Item -ItemType Junction -Path $SetupDrive -Target $DevFolder

  # Create Folders if dont exist
  write-Info("Creating Folder if don't exist ...
  ")
  $FolderList = @($Env:PRODPATH, $Env:REPOPATH, $Env:DEVPATH)
  Foreach ($FPath in $FolderList) {
    If(!(Test-Path $FPath)){
      New-Item -Path $FPath -ItemType Directory
    }
  }
}

# Show Available Commands
write-info "Commands:
setenv - Update SetEnv.ps1 script
open - Open Dev folder, param: [projName]
cproj - Create Project Folders, param: [projName]
"

# Show Current Apps
write-info "List of Projects in Dev ($Env:DEVPATH): "
$projs = Get-ChildItem -Directory -Path $Env:DEVPATH
Foreach ($proj in $projs) {
  Write-Info " - $proj"
}
Write-Info ""

