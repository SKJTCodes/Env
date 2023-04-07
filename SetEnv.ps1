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
  $FolderList = @($Env:PRODPATH, $Env:DEVPATH)
  Foreach ($FPath in $FolderList) {
    If(!(Test-Path $FPath)){
      New-Item -Path $FPath -ItemType Directory | Out-Null
    }
  }
}
# Link Repo Path to SetEnv Location
If(!(Test-Path $RepoPath)){
  # if repo path dont exist stop creation
  write-warning "$RepoPath Don't exist, Repo Path not created."
} else {
  If(!(Test-Path $Env:REPOPATH)){
    New-Item -ItemType Junction -Path $Env:REPOPATH -Target $RepoPath | Out-Null
  }
}

# Show Available Commands
write-info "Commands:
setenv - Update SetEnv.ps1 script
open - Open Dev folder, param: [projName]
cproj - Create Project Folders, param: [projName, Type(react, python)]
e - Open File Explorer, param: [path]
d - Change Directory, param: [path]
"

# Show Current Apps
write-info "List of Projects in Dev ($Env:DEVPATH): "
$projs = Get-ChildItem -Directory -Path $Env:DEVPATH
Foreach ($proj in $projs) {
  Write-Info " - $proj"
  
  $envObj = Get-ChildItem env:\ | Where-Object {$_.Name -eq $proj}
  # if variable is not in global environment variable
  if($null -eq $envObj){
    New-Item -Path Env:$proj -Value "$ENV:DEVPATH/$proj" | Out-Null
  }
}
Write-Info ""

