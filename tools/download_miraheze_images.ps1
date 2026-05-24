# Download selected BattleChip images from Miraheze
# Run from project root: pwsh .\tools\download_miraheze_images.ps1

$images = @{
  # Core set: BattleChip001 - BattleChip012
  "BattleChip001.png" = "https://megaman.miraheze.org/wiki/Special:FilePath/BattleChip001.png"
  "BattleChip002.png" = "https://megaman.miraheze.org/wiki/Special:FilePath/BattleChip002.png"
  "BattleChip003.png" = "https://megaman.miraheze.org/wiki/Special:FilePath/BattleChip003.png"
  "BattleChip004.png" = "https://megaman.miraheze.org/wiki/Special:FilePath/BattleChip004.png"
  "BattleChip005.png" = "https://megaman.miraheze.org/wiki/Special:FilePath/BattleChip005.png"
  "BattleChip006.png" = "https://megaman.miraheze.org/wiki/Special:FilePath/BattleChip006.png"
  "BattleChip007.png" = "https://megaman.miraheze.org/wiki/Special:FilePath/BattleChip007.png"
  "BattleChip008.png" = "https://megaman.miraheze.org/wiki/Special:FilePath/BattleChip008.png"
  "BattleChip009.png" = "https://megaman.miraheze.org/wiki/Special:FilePath/BattleChip009.png"
  "BattleChip010.png" = "https://megaman.miraheze.org/wiki/Special:FilePath/BattleChip010.png"
  "BattleChip011.png" = "https://megaman.miraheze.org/wiki/Special:FilePath/BattleChip011.png"
  "BattleChip012.png" = "https://megaman.miraheze.org/wiki/Special:FilePath/BattleChip012.png"
}

$assetsDir = Join-Path $PSScriptRoot "..\assets\images"
if (-not (Test-Path $assetsDir)) { New-Item -ItemType Directory -Path $assetsDir | Out-Null }

foreach ($name in $images.Keys) {
  $url = $images[$name]
  $out = Join-Path $assetsDir $name
  Write-Host "Downloading $url -> $out"
  try {
    Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing -ErrorAction Stop
  } catch {
    $err = $_
    Write-Warning ('Failed to download ' + $url + ': ' + $err.ToString())
  }
}

Write-Host "Done. Remember to add attribution: CC BY-SA 4.0 (Miraheze / contributors)."