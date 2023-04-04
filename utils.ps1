Function Write-Info {
  [CmdletBinding()]
  param(
    [Parameter()]
    [String] $msg
  )
  Write-Host $msg -ForegroundColor Green
}