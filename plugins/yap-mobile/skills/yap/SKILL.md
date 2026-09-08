---
name: yap
description: Expo + React Native mobil projelerinde görev orchestrator'ı. Görevi sınıflandırır, projenin kendi kurallarını `.claude/yap.md` dosyasından okur, Expo SDK ve kütüphane sürümlerini tespit edip doğru dokümana gider, katman sırasıyla uygular ve doğrular. Kullanıcı "/yap <görev>" ile çağırır; yeni ekran, bug fix, refactor, native modül entegrasyonu, sürüm yükseltme gibi tüm işler için.
---

# /yap — mobil görev orchestrator'ı

Bu skill genel iskelettir. Projeye özel her şey **`.claude/yap.md`** dosyasındadır.

---

## Adım 0 — Proje katmanını yükle (atlanamaz)

1. **`.claude/yap.md` oku.** Yoksa kullanıcıya söyle: *"Bu projede `.claude/yap.md`
   yok — `/yap-init` çalıştırırsan projeyi tarayıp oluştururum."* Proje
   kurallarını **uydurma**.
2. **Sürümleri tespit et.** `package.json` + `app.json`/`app.config.*` oku:
   `expo`, `react-native`, `react`, `expo-router`, `@tanstack/react-query`,
   `nativewind`, `i18next`, `react-native-reanimated`, `expo-*` modülleri.
3. **Sürüm bilgisine ihtiyaç duyduğun her an `context7` MCP'sini kullan.**
   Expo SDK'ları hızlı değişiyor (50 → 54 arasında router, config plugin ve
   New Architecture varsayılanları değişti). **Hatırladığın API'ye güvenme.**
   Resmi `expo` plugin'i kuruluysa onun skill'lerini de kullan.
4. **Native mi managed mi?** `ios/` ve `android/` klasörleri var mı (prebuild
   yapılmış / bare), yoksa managed mı? Bu, bir native modülün nasıl ekleneceğini
   tamamen değiştirir.
5. **Paket yöneticisini tespit et** — `packageManager`, lock dosyası, EAS
   yapılandırması. Birden fazla lock dosyası varsa karıştırma.

## Adım 1 — Sınıflandır

| Tip | İşaretler | Yüklenecek referans | Ek skill |
|---|---|---|---|
| **Ekran/UI** | yeni ekran, düzen, stil, animasyon | `expo-router.md`, `native-ui.md` | — |
| **Veri** | yeni uç, cache, form, offline | `data-layer.md` | — |
| **Native** | kamera, bildirim, konum, dosya, izin | `native.md` | `expo` plugin skill'leri |
| **Çeviri** | çok dilli metin | `i18n.md` | — |
| **Sürüm yükseltme** | Expo SDK / RN yükseltmesi | `native.md` + context7 | `expo` plugin skill'leri |
| **Bugfix** | çöküyor, beyaz ekran, platform farkı | ilgili referans | — |
| **Yayın** | build, EAS, store | `native.md` | `expo` plugin skill'leri |

`.claude/yap.md` kendi sınıflarını ekliyorsa **onlar bu tablonun üstündedir.**

## Adım 2 — Planı sun, onay al

Dosya değiştirmeden önce göster:

1. **Sınıf** ve **etkilenen dosyalar** — yol vererek, arayarak
2. **Sıra** — katman sırası
3. **Riskler** — özellikle: native yapılandırma değişikliği (prebuild/rebuild
   gerektirir), izin ekleme (store incelemesini etkiler), SDK yükseltmesi,
   kalıcı depolama şemasının değişmesi
4. **Doğrulama planı** — hangi komutlar, hangi platformlarda

Onay istisnası: kullanıcı "direkt yap" dediyse veya iş tek satırlıksa.

## Adım 3 — Uygula

```
tip → API çağrısı → cache key → hook → form şeması →
bileşen → ekran (route) → çeviri → test
```

Kurallar:
- **Her değişikliği iki platformda da düşün.** iOS ve Android farklı davranır:
  klavye, güvenli alan, geri tuşu, izin diyalogları, gölge/elevation, font.
  Sadece birinde denenmiş bir düzeltme yarım düzeltmedir.
- **Mevcut bileşeni kullan, yenisini yazma.** `.claude/yap.md`'deki katalogu tara.
- **Yorum dilini ve üslubunu çevredeki koddan al.** Yorum *neden*'i anlatır.
- **Native yapılandırmayı elle `ios/`/`android/` içinde değiştirme** (managed
  projede); config plugin ya da `app.json` üzerinden yap — yoksa bir sonraki
  prebuild değişikliği siler.

## Adım 4 — Doğrula

`.claude/yap.md`'de yazan komutları çalıştır. Tipik olarak:
`typecheck` → `lint` → `test` → `expo-doctor`.

Simülatör/cihaz gerektiren doğrulamayı **sen yapamazsın**; ne test edildiğini ve
neyin kullanıcı tarafından cihazda denenmesi gerektiğini **açıkça ayır**.
Native yapılandırma değiştiyse yeniden build gerektiğini söyle.

Bir doğrulama kırmızıysa sonrakine geçme. Geçmeden "bitti" deme.

## Adım 5 — Kapat

- Ne yaptığını **dosya yollarıyla** özetle; cihazda denenmesi gerekenleri listele
- Commit **sadece kullanıcı isterse**; mesajı çevredeki git log üslubuna uydur

---

## Değişmezler

1. **`.env*` dosyalarını ve imzalama anahtarlarını okuma, yazma, yansıtma.**
   Mobil projede sızan sır uygulamanın içinde dağıtılır — geri alınamaz.
2. **Gizli anahtarı istemciye gömme.** `EXPO_PUBLIC_*` ile başlayan her şey
   pakette açıktır; API sırrı backend'de kalır.
3. **İzin eklemeyi sessizce yapma.** Yeni izin store incelemesini ve kullanıcı
   güvenini etkiler; kullanıcıya söyle.
4. **`ios/`/`android/` içine elle yama atma** (managed projede) — prebuild siler.
5. **Çeviri anahtarını tek tarafta bırakma.**
6. **Sürümü hatırladığını sanma.** Emin değilsen context7'ye sor.
7. **`.claude/yap.md` ile çelişme.** Proje katmanı bu dosyayı ezer.
