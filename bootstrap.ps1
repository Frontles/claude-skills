# Yeni bir Windows makinesini hazırlar.
#   powershell -ExecutionPolicy Bypass -File bootstrap.ps1
#
# Marketplace adresini bu klonun kendi origin'inden okur — elle doldurman
# gereken bir yer yok. Kurulanlar makine geneli (user scope).

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

Write-Host "`n== 1/3  Marketplace'ler ==" -ForegroundColor Cyan

# Resmi marketplace çoğu kurulumda hazır gelir; yoksa ekler.
claude plugin marketplace add anthropics/claude-plugins-official 2>&1 | Out-Null

# Kendi marketplace'imiz: origin URL'inden kullanıcı/repo çıkar.
$origin = git remote get-url origin 2>$null
if ($origin -match 'github\.com[:/]([^/]+)/([^/.]+)') {
  $repo = "$($Matches[1])/$($Matches[2])"
  Write-Host "  -> $repo"
  claude plugin marketplace add $repo
} else {
  Write-Host "  ! origin bir GitHub adresi degil, yerel klasor olarak ekleniyor" -ForegroundColor Yellow
  $repo = '<kullanici>/claude-skills'
  claude plugin marketplace add $PSScriptRoot
}

Write-Host "`n== 2/3  Resmi plugin'ler ==" -ForegroundColor Cyan

# context7      : surume ozel canli dokumantasyon (Next/React/TanStack/Tailwind/Prisma/Expo)
# typescript-lsp: .ts/.tsx/.js sembol takibi
# playwright    : tarayici otomasyonu / e2e
# github        : PR ve issue
# frontend-design, modern-web-guidance : UI kalitesi ve guncel web pratikleri
# redis-development : Redis / BullMQ / socket adapter kaliplari
# security-guidance : edit ve commit'te otomatik guvenlik taramasi (hook)
# pr-review-toolkit : inceleme ajanlari + /review-pr
# commit-commands   : /commit, /commit-push-pr
# skill-creator, claude-md-management : skill ve proje hafizasi bakimi
$plugins = @(
  'context7', 'typescript-lsp', 'playwright', 'github',
  'frontend-design', 'modern-web-guidance', 'redis-development',
  'security-guidance', 'pr-review-toolkit', 'commit-commands',
  'skill-creator', 'claude-md-management'
)

foreach ($p in $plugins) {
  Write-Host "  -> $p"
  claude plugin install "$p@claude-plugins-official" 2>&1 | Select-Object -Last 1
}

Write-Host "`n== 3/3  Ön koşullar ==" -ForegroundColor Cyan

# typescript-lsp bu ikisini PATH'te bekler.
if (Get-Command typescript-language-server -ErrorAction SilentlyContinue) {
  Write-Host "  typescript-language-server zaten kurulu"
} else {
  Write-Host "  -> npm i -g typescript-language-server typescript"
  npm i -g typescript-language-server typescript
}

Write-Host "`nBitti." -ForegroundColor Green
Write-Host "`nHer projede bir kez:" -ForegroundColor Green
Write-Host "  claude plugin install yap-web@claude-skills --scope project    # mobilse yap-mobile"
Write-Host "  claude plugin marketplace add $repo --scope project"
Write-Host "  ...sonra oturumda:  /yap-init"
Write-Host "`nBu ikisi projenin .claude/settings.json dosyasina yazilir; commit'lersen"
Write-Host "bir sonraki makinede tekrar calistirman gerekmez."
