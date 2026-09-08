# Next.js / React / Tailwind katmanı

> **Sürüm önce.** `package.json`'daki `next`, `react`, `tailwindcss` majorlarını
> oku. Next 13→16 arasında App Router API'leri, `params`/`searchParams`'ın
> senkron/asenkron oluşu, cache davranışı ve metadata API'si değişti; Tailwind
> 3→4 arasında yapılandırma dosyadan CSS'e taşındı. **Kod yazmadan önce o
> sürümün dokümanına bak** — context7, ya da varsa `node_modules/next/dist/docs/`.
> Proje kökünde `AGENTS.md` varsa önceliklidir.

## Nerede ne durur

Projeye göre değişir, `.claude/yap.md` gerçek yolları verir. Yaygın düzen:

```
src/app/…                 App Router — route grupları, layout, page, loading, error
src/components/ui/…       primitive'ler (radix/shadcn üslubu)
src/components/shared/…   projeye özel paylaşılan bileşenler
src/components/<alan>/…   alana özel bileşenler
src/features/<alan>/…     alanın hook'ları / iş mantığı
src/lib/…                 altyapı: api client, auth, query, utils
src/stores/…              zustand
```

Yeni bileşen yazmadan önce **paylaşılan katalogu tara** — liste, filtre, boş
durum, hata durumu, sayfalama, onay dialogu, tarih alanı gibi şeyler bu
projelerde çoğunlukla zaten yazılmıştır. `.claude/yap.md` katalogu tutar.

## Server / client sınırı

- Varsayılan server component. `"use client"` yalnız gerçekten gerektiğinde:
  state, effect, event handler, tarayıcı API'si, context tüketimi.
- Veri çeken hook'lar (TanStack Query) client tarafındadır; onları çağıran
  bileşen de client olur. Sınırı **yaprağa yakın** tut — bütün sayfayı client
  yapmak yerine sadece etkileşimli parçayı ayır.
- Server component'ten client component'e geçen prop serileştirilebilir olmalı.

## Yönlendirme ve yetki

- Rol bazlı panellerde route grubu başına izin: `(dashboard)/admin`,
  `(dashboard)/consultant` gibi. Guard tek bir yerde tanımlanır
  (`lib/auth/roles.ts` benzeri), bileşen içine dağıtılmaz.
- Frontend guard'ı **görsel bir kolaylıktır, güvenlik değildir.** Aynı kontrol
  backend'de de olmalı — biri olmadan diğerini eklemek açık bırakır.

## Durum yönetimi

- **Sunucu verisi** → TanStack Query. Global store'a kopyalama.
- **UI durumu** (tema, dil, sidebar, seçili sekme) → zustand.
- **Form durumu** → react-hook-form. Ayrı state tutma.
- Aynı veriyi hem query hem store'da tutmak bu projelerde tekrar eden bir hata
  kaynağı; tek kaynak seç.

## Tailwind

- v4'te yapılandırma CSS'te (`@theme`), `tailwind.config` yok sayılabilir.
  v3'te config dosyasında. Hangisinde olduğunu **dosyaya bakarak** anla.
- `clsx` + `tailwind-merge` (çoğunlukla `cn()` yardımcısı) varsa koşullu sınıfları
  onunla birleştir, string şablonu ile değil.
- `cva` (class-variance-authority) varsa varyantlı bileşenleri onunla yaz.

## Erişilebilirlik ve UX — atlanmayacak asgariler

- Etkileşimli her şey klavyeyle erişilebilir; `div` üzerine `onClick` takıp bırakma.
- Form alanının etiketi bağlı olsun; hata metni alana `aria-describedby` ile bağlı.
- Yükleniyor / boş / hata üç durumu da olsun — sadece mutlu yol yeterli değil.
- Dialog/sheet açıldığında odak içeri, kapanınca tetikleyene döner (radix bunu
  kendisi yapar; elle yazılan dialog'da sen yaparsın).

## Test

- Bileşen testi: Testing Library. Projenin kendi render yardımcısı varsa
  (i18n/query sağlayıcılarını saran) **onu kullan**, çıplak `render` değil —
  aksi halde sağlayıcı eksikliğinden patlar.
- Kullanıcı davranışını test et, iç state'i değil. `getByRole` tercih et.
- E2E: Playwright. Canlı tarayıcı gerekiyorsa `playwright` MCP'si var.
