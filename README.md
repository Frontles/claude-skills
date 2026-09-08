# claude-skills

Claude Code için kişisel eklenti deposu (marketplace). İçinde iki plugin var:

| Plugin | Kime |
|---|---|
| **yap-web** | Next.js + React + TypeScript web projeleri — ayrı Express/Prisma backend'i olanlar dahil |
| **yap-mobile** | Expo + React Native mobil projeleri |

İkisi de **`yap`** adında bir skill sunar. Bir projede yalnız biri kurulu olacağı
için, hangi projede olursan ol yazacağın komut aynı:

```
/yap görev teslim ekranına platform filtresi ekle
```

---

## Ne işe yarar

Claude Code'a bir görev verdiğinde model işe nereden başlayacağını her seferinde
yeniden keşfeder: hangi klasör ne yapıyor, hangi bileşen zaten var, hangi sırayla
yazılmalı, hangi komutla doğrulanır. Aynı projede çalışsan bile bu keşif her
oturumda sıfırdan başlar ve her seferinde biraz farklı sonuçlanır.

`/yap` bunu sabitler. Çağırdığında:

1. **Sınıflandırır** — UI mi, veri mi, backend mi, full-stack mi, bugfix mi
2. **Projenin kendi kurallarını okur** — `.claude/yap.md`
3. **Sürümü tespit eder** — `package.json`'dan Next 13 mü 16 mı, TanStack 4 mü 5 mi,
   Expo 50 mi 54 mü; sonra `context7` ile **o sürümün** dokümanına gider
4. **Gereken diğer skill'leri kendisi çağırır** — UI işiyse `frontend-design`,
   kuyruk işiyse `redis-core`, tarayıcı gerekiyorsa `playwright`
5. **Planı gösterir, onay ister**
6. **Katman sırasıyla uygular** — veri önce, ekran sonra
7. **Doğrular** — typecheck → lint → test, kırmızıysa devam etmez
8. **Kapatır** — ne yapıldığını dosya yollarıyla söyler, atlanan varsa açıkça yazar

Sen sadece `/yap` yazarsın. 3, 4 ve 5. adımları tetiklemen gerekmez.

### Neden sürüm bilgisi plugin'in içinde değil

Bu depo hiçbir sürüme özel API bilgisi taşımaz. Gerçek projeler Next 13'ten 16'ya,
Tailwind 3'ten 4'e, TanStack Query 4'ten 5'e, zod 3'ten 4'e, Expo 50'den 54'e
dağılıyor ve bunların arasında breaking change var. Plugin'e "Next şöyle çalışır"
yazmak, eski projelerde yanlış kod üretmek demek. Onun yerine skill sürümü tespit
edip canlı dokümana gidiyor. Sürümden bağımsız kalan şeyler — katman sırası,
tuzaklar, doğrulama disiplini — plugin'de duruyor.

### İki katman

**Katman 1 — plugin (bu depo, tüm projelerde ortak):** görev sınıflandırma,
katman sırası, sürüm tespiti, doğrulama disiplini, stack kalıpları, "asla yapma"
listesi.

**Katman 2 — `.claude/yap.md` (her projede tek dosya):** o projenin gerçek
yolları, gerçek komutları, bileşen kataloğu, domain kuralları.

İkinci katmanı `/yap-init` üretir: projeyi tarar ve bulduğunu yazar. Aynı stack'e
sahip iki proje bile birbirinden çok farklı çıkar — biri `npm run typecheck`
kullanırken diğeri `type-check`, birinde merkezi query key dosyası varken
diğerinde 39 dosyaya dağılmış, birinde roller global iken diğerinde kaynak
başına. Bu yüzden proje bilgisi plugin'e gömülmez.

---

## Kurulum

### 1. Yeni bir makinede (bir kez)

```bash
git clone https://github.com/<kullanıcı>/claude-skills.git
cd claude-skills

powershell -ExecutionPolicy Bypass -File bootstrap.ps1   # Windows
bash bootstrap.sh                                        # macOS / Linux
```

Bootstrap marketplace adresini klonun kendi `origin`'inden okur, elle doldurman
gereken yer yok. Yaptıkları:

- Bu depoyu marketplace olarak ekler
- Birlikte kullanılan 12 resmi plugin'i kurar (aşağıda liste)
- `typescript-lsp`'in beklediği `typescript-language-server`'ı global kurar

Elle yapmak istersen tek gereken satır:

```bash
claude plugin marketplace add <kullanıcı>/claude-skills
```

### 2. Yeni bir projede (bir kez)

```bash
cd projem
claude plugin install yap-web@claude-skills --scope project        # mobilse yap-mobile
claude plugin marketplace add <kullanıcı>/claude-skills --scope project
```

Sonra Claude Code oturumunda:

```
/yap-init          # projeyi tarar, .claude/yap.md üretir — bir kez
/yap <görev>       # bundan sonrası hep bu
```

`/yap-init`'in ürettiği dosyayı bir kez oku; yanlış veya eksik bir şey görürsen
düzelt. `/yap` oradaki bilgiyi doğru kabul eder.

### 3. Commit'le ki bir daha uğraşma

Yukarıdaki iki komut projenin `.claude/settings.json` dosyasına yazılır:
`enabledPlugins` ve `extraKnownMarketplaces`. Bunları ve `.claude/yap.md`'yi
projeye commit'lersen, o projeyi klonlayan her makine — ve her ekip arkadaşın —
kurulumu hazır bulur.

> `enabledPlugins` tek başına yetmez. Klonlayan makine "yap-web açık" bilgisini
> görür ama marketplace'i tanımadığı için bulamaz. İkisi birlikte commit'lenmeli.

### Neyin nerede durduğu

| Ne | Nerede | Yeni makinede |
|---|---|---|
| Plugin içerikleri | bu depo | `marketplace add` ile gelir |
| 12 resmi plugin | makine (user scope) | `bootstrap` ile kurulur |
| `typescript-language-server` | makine (global npm) | `bootstrap` ile kurulur |
| Hangi plugin hangi projede | proje `.claude/settings.json` | commit'liyse klonla gelir |
| Projeye özel bilgi | proje `.claude/yap.md` | commit'liyse klonla gelir |

---

## Bootstrap'in kurduğu resmi plugin'ler

`/yap` bunları gerektiğinde kendisi çağırır; sen yazmazsın.

| Plugin | Ne veriyor |
|---|---|
| `context7` | Sürüme özel canlı dokümantasyon — bu kurulumun kalbi |
| `typescript-lsp` | `.ts/.tsx/.js` sembol takibi, referans bulma |
| `playwright` | Tarayıcı otomasyonu, e2e, canlı doğrulama |
| `github` | PR ve issue yönetimi |
| `frontend-design` | UI kalitesi |
| `modern-web-guidance` | Chrome ekibinden güncel web pratikleri |
| `redis-development` | Redis / BullMQ / socket adapter kalıpları (8 skill) |
| `security-guidance` | Edit ve commit'te otomatik güvenlik taraması (hook) |
| `pr-review-toolkit` | `/review-pr` + 6 inceleme ajanı |
| `commit-commands` | `/commit`, `/commit-push-pr` |
| `skill-creator` | Skill yazma ve iyileştirme |
| `claude-md-management` | `CLAUDE.md` bakımı |

---

## Depo yapısı

```
.claude-plugin/marketplace.json     plugin kataloğu
bootstrap.ps1 / bootstrap.sh        yeni makine kurulumu
plugins/
├── yap-web/
│   ├── .claude-plugin/plugin.json
│   ├── commands/yap-init.md        projeyi tarayıp .claude/yap.md üretir
│   └── skills/yap/
│       ├── SKILL.md                yönlendirme mantığı
│       └── references/
│           ├── nextjs-app.md       App Router, server/client sınırı, Tailwind, erişilebilirlik
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
            ├── native-ui.md        NativeWind, iOS/Android farkları, erişilebilirlik
            ├── native.md           config plugin, izinler, SDK yükseltme, EAS
            └── i18n.md
```

İki plugin **tek bir dosyayı bile paylaşmaz**; aynı ada sahip dosyaların içerikleri
ayrıdır. Tek depoda durmalarının sebebi tek `marketplace add` yetmesi.

## Güncelleme

```bash
claude plugin update yap-web
```

Değişiklikten sonra manifest'leri doğrula:

```bash
claude plugin validate plugins/yap-web
claude plugin validate .
```

## Katkı / düzenleme kuralı

- **Projeye özel bilgi buraya girmez** — o `.claude/yap.md` dosyasının işi.
- **Sürüme özel API detayı buraya girmez** — o `context7`'nin işi.
- Buraya giren şey: sürümler değişse de doğru kalan kalıplar, sıralar ve tuzaklar.
