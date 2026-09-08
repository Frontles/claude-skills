# Expo Router ve ekran yapısı

> **Sürüm önce.** Expo Router 2 → 6 arasında dosya konvansiyonları, tipli route'lar
> ve layout API'si değişti. `package.json`'daki `expo` ve `expo-router` majorlarını
> gör, context7'den o sürümün dokümanına bak.

## Dosya tabanlı yönlendirme

```
app/
├── _layout.tsx           kök layout — sağlayıcılar (query, tema, i18n, auth)
├── (tabs)/               sekme grubu
│   ├── _layout.tsx
│   └── index.tsx
├── (auth)/               oturum açmamış kullanıcı grubu
├── [id].tsx              dinamik route
├── +not-found.tsx
```

- Parantezli klasör (`(tabs)`) URL'e girmez, sadece gruplar.
- Sağlayıcılar kök `_layout.tsx` içinde tek yerde kurulur; ekran içinde
  tekrar sarmalama.
- Ekranlar arası veri **route parametresiyle** taşınır, global state'e
  yazıp okuyarak değil — geri/derin link durumunda ikincisi kırılır.

## Oturum ve yönlendirme

- Oturum kontrolü tek bir yerde (kök layout veya bir guard bileşeni).
  Her ekrana ayrı ayrı kontrol koyma.
- Oturum durumu belirsizken (token okunuyor) **splash'i açık tut**; yoksa
  kullanıcı bir an login ekranını görüp anasayfaya atlar.
- Derin link (deep link) ile açılan korumalı ekran: önce oturum, sonra hedefe
  yönlendir — hedefi kaybetme.

## Ekran hijyeni

- Her ekranda yükleniyor / boş / hata üç durumu da olsun.
- Liste ekranlarında `FlatList`/`FlashList` kullan; `ScrollView` içinde `map`
  büyük listeyi öldürür.
- `SafeAreaView` ve klavye davranışı (`KeyboardAvoidingView`, davranış farkı
  iOS/Android) ekran başına düşünülür.
- Geri tuşu davranışı Android'de ayrıca ele alınır.

## Performans

- Ağır bileşenlerde `memo`, listelerde `keyExtractor` ve sabit `renderItem`.
- Animasyonlar `react-native-reanimated` ile JS thread'i bloklamadan.
- Görselleri boyutlandırarak yükle; tam boy görsel listesi belleği bitirir.
