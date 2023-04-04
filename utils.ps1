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
    [String] $Path,
    [Boolean] $envOnly
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
    if($envOnly){
      write-Error "Not a Global Environment Variable: $Path"
    }
    $newPath = $Path
  }

  return $newPath
}