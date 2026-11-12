# check.ps1 – local feedback loop. Run from the repository root:
#   pwsh ./check.ps1                    (checks modules/network)
#   pwsh ./check.ps1 -Folder module-08  (checks another folder)
param([string]$Folder = "modules/network")

$steps = [ordered]@{
  "fmt"      = { terraform fmt -check -diff -recursive }
  "init"     = { terraform init -backend=false -input=false > $null }
  "validate" = { terraform validate }
  "tflint"   = { tflint --init > $null; tflint }
  "checkov"  = { checkov -d . }
  "test"     = { terraform test }
}

Push-Location $Folder
try {
  foreach ($name in $steps.Keys) {
    Write-Host "`n== $name ==" -ForegroundColor Cyan
    & $steps[$name]
    if ($LASTEXITCODE -ne 0) {
      Write-Host "`n✗ Stopped at $name" -ForegroundColor Red
      exit 1
    }
  }
  Write-Host "`n✓ All checks passed" -ForegroundColor Green
}
finally {
  Pop-Location
}