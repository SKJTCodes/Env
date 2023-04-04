# Open Folder Explorer
function e {
  param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [string[]] $Path
  )
  # Process Argument
  $ParsedPath = $Path.Replace("\", "/")
  $SplitPath = $ParsedPath -split '/'
  $envName, $subPath = $SplitPath

  $envObj = Get-ChildItem env:\ | Where-Object {$_.Name -eq $envName}
  $envDontExist = $envObj -eq ""
  write-host $envDontExist  # TODO: Returns false when suppose to be true
  # If env exist
  If(!$envDontExist){
    $envPath = $envObj.Value
    write-host $envPath
  } else {
    explorer $Path
  }
  
  # $envPath = Get-ChildItem env:\ | Where-Object {$_.Name -eq $EnvName}
  # $envExist = $envPath -eq ""
  # if ($envExist) {

  # }
  # Push-Location "$Path"
  # explorer .
  # Pop-Location
}

# Open SetEnv script
function setenv {
  code -n $Env:SETENVPATH
}

# Open Development Project
function open {
  param($ProjName)
  
  $projPath = "$Env:DEVPATH/$ProjName"
  # Open all relevant Software
  OpenDevSoft $projPath
}

# Create Project Folder
function cproj {
  param($ProjName)

  # Create Git Repo
  cgit("$ProjName.git")
  $repoPath = "$Env:REPOPATH/$ProjName.git"

  $projPath = "$Env:DEVPATH/$ProjName"
  New-Item -Path $projPath -ItemType Directory
  Push-Location $projPath
  
  # Create Robot text file
  Copy-Item $Env:SETENVPATH/README.md ./README.md

  # Set Git
  git init
  git remote add "repo" "$repoPath"
  git add .
  git commit -m "Initial Commit"

  git branch --set-upstream-to repo master
  git push --set-upstream repo master

  Pop-Location

  # Open all relevant Software
  OpenDevSoft $projPath
}

# Create Git Repository
function cgit{
  param($gitName)

  # Check if folder exist, if don't create folder
  Assert-FolderExists -Path "$Env:REPOPATH/$gitName"

  Push-Location "$Env:REPOPATH/$gitName"
  git init --bare  
  Pop-Location
  return "$Env:REPOPATH/$gitName"
}

# Check if folder exist
function Assert-FolderExists{
  param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [string[]] $Path
  )

  process{
    foreach($_ in $Path){
      $exists = Test-Path -Path $_ -PathType Container
      if (!$exists){
        write-warning "$_ did not exist. Folder created."
        $null = New-Item -Path $_ -ItemType Directory
      }
      else{
        write-error "$_ already exist."
      }
    }
  }
}

function OpenDevSoft{
  param($projPath)

  start-process PowerShell -argumentlist "-noExit", "-command", "set-location $projPath"
  code -n $projPath
}