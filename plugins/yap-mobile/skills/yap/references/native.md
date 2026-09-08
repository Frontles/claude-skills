# Native modüller, yapılandırma ve yayın

> **Sürüm önce.** Expo SDK sürümü her şeyi belirler: hangi `expo-*` sürümü
> uyumlu, New Architecture varsayılan mı, prebuild nasıl davranıyor.
> `package.json` + `app.json`/`app.config.*` oku, context7'den doğrula.
> Resmi `expo` plugin'i kuruluysa onun skill'lerini kullan.

## Managed mi bare mi

- `ios/` ve `android/` klasörleri **yoksa** managed: native yapılandırma
  `app.json` / `app.config.js` ve config plugin'ler üzerinden yapılır.
- Klasörler **varsa** prebuild yapılmış: elle değişiklik mümkün ama bir sonraki
  `prebuild --clean` siler. Kalıcı olması gereken her şey yine config plugin'e yazılır.
- Hangisi olduğunu **bakarak** anla, varsayma.

## Yeni native yetenek ekleme

1. Uyumlu sürümü `npx expo install <paket>` ile kur (`npm install` değil —
   SDK'ya uygun sürümü o seçer).
2. Gerekiyorsa config plugin'i `app.json` içindeki `plugins` dizisine ekle.
3. İzin metinlerini (iOS `infoPlist`, Android `permissions`) **anlamlı** yaz;
   store incelemesi bunları okur.
4. Kullanıcıya söyle: yeni build gerekiyor, hot reload yetmez.

## İzinler

- Yeni izin eklemek sessiz bir değişiklik değildir — kullanıcıya bildir.
- İzni **kullanıldığı anda** iste, uygulama açılışında toptan değil.
- Reddedilme yolunu da yaz: izin yoksa ekran ne gösterecek, ayarlara nasıl
  yönlendirecek.

## Depolama

- Hassas veri (token, kimlik) → `expo-secure-store`.
- Hassas olmayan tercih/cache → AsyncStorage veya MMKV.
- Kalıcı yapının şeması değişince sürüm/migration düşün; eski cihazdaki eski
  veri yeni koda düşecek.

## Sürüm yükseltme

- `npx expo install --fix` uyumsuz paketleri hizalar.
- `npx expo-doctor` yükseltmeden sonra ilk çalıştırılacak şey.
- Yükseltme tek commit'te yapılır ve **cihazda denenir**; sen simülatörde
  doğrulayamazsın, kullanıcıya neyin denenmesi gerektiğini listele.
- Breaking change listesi için context7'den o SDK sürümünün changelog'una bak.

## Build ve yayın

- EAS yapılandırması `eas.json`; profil (development/preview/production) farkı
  ortam değişkenlerini ve imzalamayı değiştirir.
- `EXPO_PUBLIC_*` değişkenleri **pakete gömülür ve okunabilir**. Sır değildir.
- Sürüm numarası ve build numarası ayrı kavramlar; store'a çıkarken ikisini de
  düşün.
- OTA güncelleme (expo-updates) native değişiklik içeren bir sürümü taşıyamaz —
  native değiştiyse yeni build şart.
