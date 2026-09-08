---
name: yap
description: Web projelerinde (Next.js + React + TypeScript; opsiyonel ayrı Express/Prisma backend) görev orchestrator'ı. Görevi sınıflandırır, projenin kendi kurallarını `.claude/yap.md` dosyasından okur, kullanılan sürümleri tespit edip doğru dokümana gider, katman sırasıyla uygular ve doğrular. Kullanıcı "/yap <görev>" ile çağırır; yeni özellik, bug fix, refactor, test yazma, migrasyon gibi tüm işler için.
---

# /yap — web görev orchestrator'ı

Bu skill genel iskelettir. Projeye özel her şey **`.claude/yap.md`** dosyasındadır.

---

## Adım 0 — Proje katmanını yükle (atlanamaz)

1. **`.claude/yap.md` oku.** Yoksa kullanıcıya söyle: *"Bu projede `.claude/yap.md`
   yok — `/yap-init` çalıştırırsan projeyi tarayıp oluştururum."* Sonra ya
   `/yap-init` öner ya da tek seferlik bir tarama yapıp devam et; ama proje
   kurallarını **uydurma**.
2. **Sürümleri tespit et.** `package.json` oku, şunları not al:
   `next`, `react`, `typescript`, `tailwindcss`, `@tanstack/react-query`,
   `zod`, `react-hook-form`, `next-intl`/`i18next`, `@prisma/client`, `vitest`/`jest`.
3. **Sürüm bilgisine ihtiyaç duyduğun her an `context7` MCP'sini kullan.**
   Bu kural pazarlığa açık değil: bu projeler Next 13'ten 16'ya, Tailwind 3'ten
   4'e, TanStack Query 4'ten 5'e, zod 3'ten 4'e kadar dağılıyor. **Hatırladığın
   API'ye güvenme** — major sürümler arasında breaking change var.
   Proje `AGENTS.md` veya `node_modules/next/dist/docs/` barındırıyorsa onu da oku.
4. **Paket yöneticisini tespit et.** `packageManager` alanı → lock dosyası →
   `Dockerfile`/CI'daki komut. Çelişki varsa **deploy'un kullandığı kazanır**;
   kullanıcıya çelişkiyi bildir. Birden fazla lock dosyası varsa karıştırma.

## Adım 1 — Sınıflandır

| Tip | İşaretler | Yüklenecek referans | Ek skill |
|---|---|---|---|
| **UI** | ekran, bileşen, stil, metin; yeni veri yok | `nextjs-app.md` | `frontend-design` (yeni tasarım), `modern-web-guidance` |
| **Veri** | yeni alan/uç/sorgu, cache, form doğrulama | `data-layer.md` | — |
| **Backend** | ayrı Express/Prisma repo'su ya da route handler | `express-prisma.md` | `redis-core` (kuyruk/cache varsa) |
| **Full-stack** | yeni veri kullanıcıya görünecek | üçü birden | yukarıdakiler |
| **Çeviri** | çok dilli metin | `i18n.md` | — |
| **Bugfix** | "çalışmıyor", hata mesajı, ekran görüntüsü | ilgili referans | `playwright` MCP (tarayıcıda tekrar üretilecekse) |
| **Test** | test yazma/düzeltme | ilgili referansın test bölümü | `pr-test-analyzer` ajanı |

`.claude/yap.md` kendi sınıflarını ekliyorsa (ör. "para işi", "migrasyon")
**onlar bu tablonun üstündedir.**

## Adım 2 — Planı sun, onay al

Dosya değiştirmeden önce göster:

1. **Sınıf** ve **etkilenen dosyalar** — yol vererek, tahminle değil, arayarak
2. **Sıra** — aşağıdaki katman sırası
3. **Riskler** — yıkıcı migration, para/ödeme akışı, mevcut çeviri anahtarlarının
   kırılması, yetki kontrolünün gevşemesi, public API sözleşmesinin değişmesi
4. **Doğrulama planı** — hangi komutlar çalışacak

Onay alma istisnası: kullanıcı "direkt yap" dediyse veya iş tek satırlık bariz
bir düzeltmeyse.

## Adım 3 — Uygula

**Veri önce, ekran sonra.** Tipik sıra:

```
şema/model → backend ucu → doğrulama → tip → API çağrısı →
cache key → hook → form şeması → bileşen → sayfa → çeviri → test
```

Ayrı backend repo'su varsa **önce backend biter ve testi geçer**, sonra frontend
başlar. Frontend tipini backend'in gerçekten döndürdüğü şekle göre yaz —
controller'daki `select`/`include`'a bak, tahmin etme.

Kurallar:
- **Mevcut helper'ı kullan, yenisini yazma.** Yeni bir yardımcı/bileşen yazmadan
  önce `.claude/yap.md`'deki katalogu ve komşu dosyaları tara.
- **Yorum dilini ve üslubunu çevredeki koddan al.** Yorum *neden*'i anlatır,
  ne yaptığını değil.
- **Alan adlarını katmanlar arasında yeniden adlandırma.** Backend `snake_case`
  dönüyorsa tip de `snake_case` olur; ara katmanda camelCase'e çevirmek sözleşmeyi
  bozar ve sessiz hatalara yol açar.
- **Sürüm-hassas API yazmadan önce dokümanı aç** (Adım 0.3).

## Adım 4 — Doğrula

`.claude/yap.md`'de yazan komutları çalıştır. Yoksa `package.json` script'lerinden
türet — tipik olarak: `typecheck` → `lint` → `test` → (gerektiğinde) `e2e`.

Bir doğrulama kırmızıysa sonrakine geçme; önce onu düzelt. Geçmeden "bitti" deme.
Test çalıştıramadıysan bunu **açıkça söyle**, geçmiş gibi davranma.

## Adım 5 — Kapat

- Ne yaptığını **dosya yollarıyla** özetle; atladığın veya bloke olan parça varsa
  açıkça söyle
- Commit **sadece kullanıcı isterse**. Birden fazla repo değiştiyse her birine
  ayrı commit. Mesajı çevredeki git log üslubuna uydur (`git log --oneline -10`)
- İnceleme istenirse `/review-pr` ya da pr-review-toolkit ajanları
  (`code-reviewer`, `silent-failure-hunter`, `type-design-analyzer`)

---

## Değişmezler

1. **`.env*` dosyalarını okuma, yazma, içeriğini yansıtma.** (`.env.example` serbest.)
2. **Yıkıcı veritabanı komutunu onaysız çalıştırma** — `migrate`, `db push
   --accept-data-loss`, `reset`, `drop`.
3. **Yetkiyi gevşetme.** Yeni uç eklerken rol/oturum kontrolünü mevcut uçlarla
   aynı seviyede tut; frontend guard'ı ile backend kontrolünü birlikte güncelle.
4. **Çeviri anahtarını tek tarafta bırakma** — tüm dil dosyalarına ekle.
5. **Lock dosyalarını karıştırma.** Projenin tek bir paket yöneticisi vardır.
6. **Sürümü hatırladığını sanma.** Emin değilsen context7'ye sor.
7. **`.claude/yap.md` ile çelişme.** Proje katmanı bu dosyayı ezer.
