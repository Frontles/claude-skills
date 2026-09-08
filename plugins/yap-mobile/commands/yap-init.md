---
description: Bu mobil projeyi tarar ve /yap'ın kullanacağı .claude/yap.md proje katmanını oluşturur
---

# /yap-init — proje katmanını üret (mobil)

Bu projede `.claude/yap.md` yoksa (ya da eskiyse) onu üretmek için buradasın.
`/yap` genel iskelettir; projeye özel her şey o dosyada durur. **Doğru dosya
üretmenin tek yolu projeyi gerçekten taramaktır — şablon doldurma.**

## 1. Tara

Şunları oku, tahmin etme:

- `package.json` — script'ler, bağımlılıklar ve **majorları**
- `app.json` / `app.config.js|ts` — uygulama adı, slug, sürüm, `plugins` dizisi,
  izinler, `scheme` (deep link), `EXPO_PUBLIC_*` değişkenleri
- `eas.json` — build profilleri; hangi profil hangi ortamı kullanıyor
- **Managed mi bare mi** — `ios/` ve `android/` klasörleri var mı
- Paket yöneticisi — `packageManager`, lock dosyaları. Birden fazlaysa not düş
- Klasör ağacı — `app/` route ağacı, bileşenler, hook'lar, api katmanı
- Stil sistemi — NativeWind var mı, hangi major; yoksa `StyleSheet` düzeni ne
- Veri katmanı — api client, query key dosyası, hook'lar, kalıcı cache kurulumu
- Depolama — `expo-secure-store`, AsyncStorage, MMKV; token nerede duruyor
- Oturum akışı — guard nerede, splash nasıl yönetiliyor
- Çeviri — hangi kütüphane, hangi dosyalar, cihaz dili nasıl okunuyor
- Native modüller — hangi `expo-*` paketleri, hangi config plugin'ler, hangi izinler
- Test — hangi runner, kurulum dosyaları; e2e var mı (Detox/Maestro)
- `git log --oneline -20` — commit mesajı dili ve üslubu

Aynı anda birden fazla arama çalıştır; tek tek gitme.

## 2. Sor (yalnızca koddan çıkmayanı)

- Hangi platform öncelikli, hangisinde daha çok sorun çıkıyor?
- Yayında mı, hangi store'larda, OTA güncelleme kullanılıyor mu?
- Devam eden bir SDK yükseltmesi veya refactor var mı?
- Dokunulmaması gereken bir alan var mı?

Cevaplar birkaç satırsa uydurma; yazmadığın şeyi dosyaya koyma.

## 3. Yaz

`.claude/yap.md` üret. Şu bölümler olsun, **hepsi bu projenin gerçeğiyle dolu**:

```markdown
# <proje> — /yap proje katmanı

## Yapı
<managed/bare, klasörler, route ağacı — gerçek yollarla>

## Sürümler ve paket yöneticisi
<Expo SDK, RN, React, router, query, stil sistemi; çelişki varsa açıkça yaz>

## Komutlar
<doğrulama sırası: typecheck → lint → test → expo-doctor; gerçek script adlarıyla>
<hangi doğrulama cihaz/simülatör ister — ayrı listele>

## Katman sırası
<bu projede yeni bir ekran hangi sırayla yazılır — gerçek klasör adlarıyla>

## Bileşen kataloğu
<ihtiyaç → bileşen tablosu; yenisini yazmadan önce buraya bakılır>

## Sözleşmeler
<api zarfı, hata biçimi, token nerede durur, çeviri dosyaları listesi>

## Native yapılandırma
<config plugin'ler, izinler ve neden istendikleri, deep link scheme>

## Değişmezler
<bu projeye özel "asla yapma" maddeleri>
```

Kurallar:

- **Bulmadığın şeyi yazma.** Boş bölüm, uydurulmuş bölümden iyidir.
- **Yol ver.** "ekranlar app klasöründe" değil, `app/(tabs)/index.tsx`.
- **Genel tavsiye yazma.** `/yap`'ın kendisinde zaten var; buraya sadece bu
  projeye özgü olan girer.
- **Kısa tut.** Hedef 100-150 satır.
- Dosyanın dili projenin dili olsun (commit mesajları hangi dildeyse).

## 4. Doğrula ve bitir

- Dosyaya yazdığın komutları **bir kez çalıştır** ki gerçekten çalışıyor olsunlar.
  Cihaz gerektirenleri çalıştıramazsın — onları "cihazda denenecek" diye işaretle.
- Kullanıcıya özetle: hangi yapı bulundu, hangi bölümler dolduruldu, hangileri
  boş kaldı ve neden.
- Şunu hatırlat: bundan sonra bu projede sadece `/yap <görev>` yazması yeterli.
