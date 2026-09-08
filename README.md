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

Makinede bir kez:

```bash
claude plugin marketplace add <kullanıcı>/claude-skills
```

Her projede bir kez:

```bash
cd projem
claude plugin install yap-web@claude-skills --scope project    # ya da yap-mobile
```

`--scope project` ayarı projenin `.claude/settings.json` dosyasına yazılır, yani
repo'yu klonlayan herkes aynı kuruluma sahip olur. Bir projede iki plugin'den
sadece biri kurulu olduğu için `/yap` tek anlama gelir.

Sonra oturumda:

```
/yap-init          # projeyi tarar, .claude/yap.md üretir — bir kez
/yap <görev>       # bundan sonrası hep bu
```

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
