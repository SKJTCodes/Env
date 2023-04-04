Function Write-Info {
  [CmdletBinding()]
  param(
    [Parameter()]
    [String] $msg
  )
  Write-Host $msg -ForegroundColor Green
}

Function Find-Env-Path {
  param(
    [String] $Path
  )
  # Process Argument
  $ParsedPath = $Path.Replace("\", "/")
  $SplitPath = $ParsedPath -split '/'
  $envName, $subPath = $SplitPath

  $envObj = Get-ChildItem env:\ | Where-Object {$_.Name -eq $envName}
  $envDontExist = $null -eq $envObj

  # If env exist
  If(!$envDontExist){
    $envPath = $envObj.Value
    $subPath = ,$envPath + $subPath
    $newPath = $subPath -join "/"
  } else {
    $newPath = $Path
  }

  return $newPath
}