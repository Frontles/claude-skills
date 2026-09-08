# claude-skills

Kişisel Claude Code marketplace'i. İçinde iki plugin var; ikisi de `yap` adında
bir skill sunar, yani hangi projede olursan ol yazdığın komut aynı: **`/yap`**.

| Plugin | Kime |
|---|---|
| `yap-web` | Next.js + React + TypeScript web projeleri (ayrı Express/Prisma backend'i olanlar dahil) |
| `yap-mobile` | Expo + React Native mobil projeleri |

## Nasıl çalışıyor — iki katman

**Katman 1 — plugin (bu repo, tüm projelerde ortak):** görev sınıflandırma,
katman sırası, sürüm tespiti ve doküman yönlendirmesi, doğrulama disiplini,
"asla yapma" listesi, stack kalıpları.

**Katman 2 — `.claude/yap.md` (her projede tek dosya):** o projenin gerçek
yolları, gerçek komutları, bileşen kataloğu, domain kuralları.

Plugin sürümden bağımsızdır — projedeki Next 13 de olabilir Next 16 da, skill
`package.json`'ı okuyup sürümü tespit eder ve dokümanı `context7` üzerinden o
sürüme göre çeker. Eski projelerde de bu yüzden çalışır.

## Kurulum

### Yeni bir makinede (bir kez)

```bash
git clone https://github.com/<kullanıcı>/claude-skills.git
cd claude-skills
# bootstrap içindeki MARKETPLACE_REPO satırını kendi kullanıcı adınla doldur

powershell -ExecutionPolicy Bypass -File bootstrap.ps1   # Windows
bash bootstrap.sh                                        # macOS / Linux
```

Bootstrap şunları yapar: bu marketplace'i ekler, birlikte kullanılan 12 resmi
plugin'i kurar, `typescript-lsp`'in beklediği `typescript-language-server`'ı
global kurar.

Elle yapmak istersen tek gereken satır:

```bash
claude plugin marketplace add <kullanıcı>/claude-skills
```

### Yeni bir projede (bir kez)

```bash
cd projem
claude plugin install yap-web@claude-skills --scope project        # ya da yap-mobile
claude plugin marketplace add <kullanıcı>/claude-skills --scope project
```

Bu iki komut projenin `.claude/settings.json` dosyasına yazılır:
`enabledPlugins` ve `extraKnownMarketplaces`. **İkisini de commit'lersen** o
projeyi klonlayan her makine (ve her ekip arkadaşın) kurulumu hazır bulur —
tek başına `enabledPlugins` yetmez, marketplace'in de bilinmesi gerekir.

Sonra oturumda:

```
/yap-init          # projeyi tarar, .claude/yap.md üretir — bir kez
/yap <görev>       # bundan sonrası hep bu
```

`.claude/yap.md` de projeye commit'lenir; asıl proje bilgisi orada durur.

Bir projede iki plugin'den sadece biri kurulu olduğu için `/yap` tek anlama gelir.

### Neyin nerede durduğu

| Ne | Nerede | Yeni makinede |
|---|---|---|
| Plugin içerikleri | bu repo | `marketplace add` ile gelir |
| 12 resmi plugin | makine (user scope) | `bootstrap` ile kurulur |
| `typescript-language-server` | makine (global npm) | `bootstrap` ile kurulur |
| Hangi plugin hangi projede | proje `.claude/settings.json` | commit'liysen klonla gelir |
| Projeye özel bilgi | proje `.claude/yap.md` | commit'liysen klonla gelir |

## Güncelleme

```bash
claude plugin update yap-web
```

Değişiklik yaptıktan sonra manifest'i doğrula:

```bash
claude plugin validate plugins/yap-web
claude plugin validate .
```

## Yapı

```
.claude-plugin/marketplace.json     plugin kataloğu
plugins/
├── yap-web/
│   ├── .claude-plugin/plugin.json
│   ├── commands/yap-init.md        projeyi tarayıp .claude/yap.md üretir
│   └── skills/yap/
│       ├── SKILL.md                yönlendirme mantığı
│       └── references/
│           ├── nextjs-app.md       App Router, server/client sınırı, Tailwind, a11y
│           ├── data-layer.md       TanStack Query + HTTP + zod + form
│           ├── express-prisma.md   ayrı backend: route/controller, Prisma, kuyruk, soket
│           └── i18n.md             next-intl / i18next
└── yap-mobile/
    ├── .claude-plugin/plugin.json
    ├── commands/yap-init.md
    └── skills/yap/
        ├── SKILL.md
        └── references/
            ├── expo-router.md      dosya tabanlı yönlendirme, oturum, ekran hijyeni
            ├── data-layer.md       offline, kalıcı cache, güvenli depolama
            ├── native-ui.md        NativeWind, platform farkları, erişilebilirlik
            ├── native.md           config plugin, izinler, SDK yükseltme, EAS
            └── i18n.md
```

## Referans yazarken

- Projeye özel bilgi buraya **girmez** — o `.claude/yap.md` dosyasının işi.
- Sürüme özel API detayı buraya **girmez** — o context7'nin işi.
- Buraya giren şey: sürümler değişse de doğru kalan kalıplar, sıralar ve tuzaklar.
