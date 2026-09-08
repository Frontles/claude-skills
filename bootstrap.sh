#!/usr/bin/env bash
# Yeni bir macOS/Linux makinesini hazırlar.
#   bash bootstrap.sh
#
# Kurulanlar makine geneli (user scope). Proje bazlı kurulum için README'ye bak.

set -euo pipefail

# GitHub kullanıcı adın — kendi repo'nu push ettikten sonra burayı doldur.
MARKETPLACE_REPO="KULLANICI/claude-skills"

echo
echo "== 1/3  Marketplace'ler =="
claude plugin marketplace add anthropics/claude-plugins-official >/dev/null 2>&1 || true

if [[ "$MARKETPLACE_REPO" == KULLANICI/* ]]; then
  echo "  ! bootstrap.sh icindeki MARKETPLACE_REPO doldurulmamis - kendi marketplace'in atlandi"
else
  claude plugin marketplace add "$MARKETPLACE_REPO"
fi

echo
echo "== 2/3  Resmi plugin'ler =="

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
for p in context7 typescript-lsp playwright github \
         frontend-design modern-web-guidance redis-development \
         security-guidance pr-review-toolkit commit-commands \
         skill-creator claude-md-management; do
  echo "  -> $p"
  claude plugin install "$p@claude-plugins-official" 2>&1 | tail -1
done

echo
echo "== 3/3  Ön koşullar =="
if command -v typescript-language-server >/dev/null 2>&1; then
  echo "  typescript-language-server zaten kurulu"
else
  echo "  -> npm i -g typescript-language-server typescript"
  npm i -g typescript-language-server typescript
fi

echo
echo "Bitti."
echo "Her projede bir kez:"
echo "  claude plugin install yap-web@claude-skills --scope project    # mobilse yap-mobile"
echo "  claude plugin marketplace add $MARKETPLACE_REPO --scope project"
echo "  ...sonra oturumda:  /yap-init"
echo "Bu ikisi projenin .claude/settings.json dosyasina yazilir; commit'lersen"
echo "bir sonraki makinede tekrar calistirman gerekmez."
