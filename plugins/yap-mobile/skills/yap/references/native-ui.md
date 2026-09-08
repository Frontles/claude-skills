# Mobil arayüz

## Stil

- Projede NativeWind varsa Tailwind sınıflarıyla yaz; `StyleSheet` ile karıştırma,
  ikisi bir arada okunmaz hale gelir. Hangisinin kullanıldığını komşu dosyadan gör.
- NativeWind sürümü önemli: v2 ve v4 yapılandırması farklı (`babel.config.js`,
  `metro.config.js`, `global.css`). Kurulum dosyalarına bak.
- Web'deki her Tailwind sınıfı RN'de çalışmaz; desteklenmeyen sınıf sessizce
  yok sayılır. Beklediğin görünüm gelmiyorsa önce bunu kontrol et.

## Platform farkları — her değişiklikte düşün

| Konu | iOS | Android |
|---|---|---|
| Gölge | `shadow*` | `elevation` |
| Güvenli alan | çentik + alt çubuk | durum çubuğu, gesture bar |
| Klavye | `padding` davranışı | `height` davranışı |
| Geri | kenardan kaydırma | donanım/gesture geri tuşu |
| Font | sistem fontu farklı | ölçek farklı |

Tek platformda denenmiş bir düzeltme yarım düzeltmedir.

## Erişilebilirlik

- Dokunulabilir alan en az 44×44pt.
- `accessibilityLabel` ve `accessibilityRole` ver — ikon-only butonlarda şart.
- Kullanıcı font ölçeğini büyütmüşse düzen bozulmamalı; sabit yükseklik yerine
  içeriğe göre büyüyen kutu kullan.

## Bileşen hijyeni

- Yeni bileşen yazmadan önce `.claude/yap.md`'deki katalogu tara.
- Ekran dosyası düzenden sorumludur; iş mantığı hook'a taşınır.
- Liste öğesi bileşenlerini `memo`'la ve prop'ları sabitle, yoksa kaydırma takılır.

## Görsel ve medya

- Uzak görselleri boyutlandırarak iste; tam çözünürlük listede belleği bitirir.
- Yer tutucu ve hata durumu olsun — kopuk görsel boş kutu bırakmasın.
- `expo-image` varsa cache ve geçiş desteği için onu tercih et.
