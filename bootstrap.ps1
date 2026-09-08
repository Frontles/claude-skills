# Yeni bir Windows makinesini hazırlar.
#   powershell -ExecutionPolicy Bypass -File bootstrap.ps1
#
# Kurulanlar makine geneli (user scope). Proje bazlı kurulum için README'ye bak.

$ErrorActionPreference = 'Stop'

# GitHub kullanıcı adın — kendi repo'nu push ettikten sonra burayı doldur.
$MarketplaceRepo = 'KULLANICI/claude-skills'

Write-Host "`n== 1/3  Marketplace'ler ==" -ForegroundColor Cyan

# Resmi marketplace çoğu kurulumda hazır gelir; yoksa ekler.
claude plugin marketplace add anthropics/claude-plugins-official 2>&1 | Out-Null

if ($MarketplaceRepo -like 'KULLANICI/*') {
  Write-Host "  ! bootstrap.ps1 icindeki `$MarketplaceRepo doldurulmamis - kendi marketplace'in atlandi" -ForegroundColor Yellow
} else {
  claude plugin marketplace add $MarketplaceRepo
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
Write-Host "Her projede bir kez:" -ForegroundColor Green
Write-Host "  claude plugin install yap-web@claude-skills --scope project    # mobilse yap-mobile"
Write-Host "  claude plugin marketplace add $MarketplaceRepo --scope project"
Write-Host "  ...sonra oturumda:  /yap-init"
Write-Host "Bu ikisi projenin .claude/settings.json dosyasina yazilir; commit'lersen"
Write-Host "bir sonraki makinede tekrar calistirman gerekmez."
