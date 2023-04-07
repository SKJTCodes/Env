# Open Folder Explorer
function e {
  param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [string] $Path
  )
  $newPath = Find-Env-Path $Path

  Push-Location $newPath
  explorer .
  Pop-Location
}

# Change Directory
function d {
  param(
    [String] $Path
  )
  $newPath = Find-Env-Path $Path
  Set-Location $newPath
}

# Open SetEnv script
function setenv {
  code -n $Env:SETENVPATH
}

# Open Development Project
function open {
  param($ProjName)
  
  $projPath = Find-Env-Path $ProjName -envOnly $true
  # Open all relevant Software
  OpenDevSoft $projPath
}

# Create Project Folder
function cproj {
  param($ProjName, $Type)
  # Create Git Repo
  cgit("$ProjName.git")
  $repoPath = "$Env:REPOPATH/$ProjName.git"

  $projPath = "$Env:DEVPATH/$ProjName"
  New-Item -Path $projPath -ItemType Directory
  Push-Location $projPath

  Add-Proj-Template $projPath $Type

  # Create Robot text file
  Copy-Item $Env:SETENVPATH/README_Tem.md ./README.md
  if($type = "python"){
    # Set Git
    git init
  }

  git add .
  git commit -m "Initial Commit"
  git remote add "repo" "$repoPath"
  # git branch --set-upstream-to repo master
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

# Create template for project
function Add-Proj-Template {
  param($Path, $Type)
  Push-Location $Path
  if ($Type = 'react'){
    npx create-react-app .
  } elseif($Type = 'python'){
    write-host "$Type To Be Implemented ..."
  } else {
    write-error "$Type does not exist"
  }

  Pop-Location
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

  # start-process PowerShell -argumentlist "-noExit", "-command", "set-location $projPath"
  code -n $projPath
}