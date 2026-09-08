# Veri katmanı — TanStack Query + HTTP (mobil)

Web'deki ilkelerin çoğu aynı; mobilde farklılaşan kısımlar burada.

> **Sürüm önce.** TanStack Query v4 → v5 farkları (`gcTime`, `isPending`,
> nesne imzası) mobilde de geçerli. `package.json`'daki majoru gör.

## Katman sırası

```
types/<alan>.ts        backend'in gerçekten döndürdüğü şekil
api/…                  HTTP çağrıları — tek client örneği
query/keys.ts          query key factory'leri
hooks/…                useQuery / useMutation
schemas/…              form doğrulaması
```

## Mobilde farklı olanlar

- **Ağ her an kesilir.** `onlineManager` ile bağlantı durumunu Query'ye bağla;
  offline'da sonsuz spinner yerine anlamlı bir durum göster.
- **Uygulama arka plana gider.** `focusManager` ile `AppState`'i bağla, aksi
  halde web'deki odak-refetch davranışı hiç çalışmaz.
- **Kalıcı cache** (`persistQueryClient` + AsyncStorage/MMKV) mobilde web'den
  çok daha değerli: kullanıcı uygulamayı açar açmaz veri görür. Kurulduysa
  cache sürümünü (`buster`) şema değişince artır, yoksa eski şekildeki veri
  yeni koda düşer.
- **Timeout ve retry** web'dekinden cömert olmalı; mobil ağ yavaş ve dalgalı.
- **Token saklama**: `expo-secure-store` (hassas) veya AsyncStorage (hassas
  olmayan). Token'ı asla düz AsyncStorage'a yazma.

## HTTP client

- Tek örnek, tek dosya. Ekrandan doğrudan `fetch` çağırma.
- Ortak davranışlar interceptor'da: token, dil, 401 → oturum kapatma.
- Hata mesajı çözümü tek fonksiyonda; ekran içinde metin üretme.
- Base URL ortam değişkeninden gelir ve `EXPO_PUBLIC_*` ile başlıyorsa
  **pakette açıktır** — oraya sır koyma.

## Formlar

- react-hook-form + şema doğrulama. Şema ayrı dosyada, ekran içinde değil.
- Klavye açıkken gönder butonunun görünür kaldığından emin ol.
- Sunucu doğrulama hatalarını alanlara eşle; tek bir uyarıya düşürme.
