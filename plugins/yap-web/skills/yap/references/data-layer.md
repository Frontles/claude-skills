# Veri katmanı — TanStack Query + HTTP + zod

> **Sürüm önce.** TanStack Query v4→v5'te `useQuery` imzası nesne biçimine geçti,
> `isLoading`/`isPending` anlamı değişti, `cacheTime` → `gcTime` oldu, `onSuccess`
> query'den kaldırıldı. zod 3→4 arasında da API farkları var.
> `package.json`'daki majoru gör, gerekirse context7'den doğrula.

## Katman sırası

```
types/<alan>.ts          backend'in gerçekten döndürdüğü şekil
lib/api/endpoints/…      HTTP çağrıları — tek bir client örneği üzerinden
lib/query/keys.ts        query key factory'leri
features/<alan>/hooks.ts useQuery / useMutation
schemas/<alan>.ts        zod — form doğrulaması
```

## Tipler

- Tipi **controller'a bakarak** yaz. `select`/`include` ne dönüyorsa o.
  Tahminle yazılan tip derlenir ama çalışma anında `undefined` verir.
- Backend'in zarfını (`{ success, data }`, sayfalı zarf vb.) tek yerde tipleyip
  her yerde onu kullan; endpoint başına yeni zarf tipi uydurma.
- Alan adlarını olduğu gibi taşı — `snake_case` geliyorsa `snake_case` kalır.

## HTTP client

- **Tek örnek**, tek dosya. Bileşenden doğrudan `fetch`/`axios` çağırma.
- Ortak davranışlar interceptor'da toplanır: token ekleme, dil header'ı,
  401 → oturum kapatma, hata bildirimi. Bunları bileşende tekrarlama.
- Form gönderiminde global hata bildirimi (toast) genelde **istenmez** —
  hata alan seviyesinde gösterilir. Projenin bunun için bir bayrağı olabilir
  (`silent: true` gibi); `.claude/yap.md` dosyasına bak.
- Hata mesajı çözümü tek bir fonksiyonda toplanır; bileşen içinde metin üretme.

## Query key'leri

- Alan başına bir factory, **tek dosyada**. Hook içinde dizi literali yazma —
  invalidation zamanı hangi key'in nereye dokunduğu bulunamaz hale gelir.
- Factory bir kök (`all`) barındırsın; invalidation onun üzerinden yapılır.
- Parametreli liste key'i parametreleri içermeli, yoksa filtre değişince
  eski sonuç gösterilir.

## Query / mutation

- `enabled` ile bağımlı sorguyu koru (`enabled: !!id`) — tanımsız id ile
  istek atma.
- Ağır sorgulara (dashboard, rapor, istatistik) `staleTime` ver; varsayılan 0 +
  odak-refetch bu uçları gereksiz yere döver.
- Mutation sonrası **etkilenen** key'leri invalidate et; her şeyi değil.
- Optimistic update yazıyorsan `onError` içinde geri alma da yaz.
- Infinite query'de `getNextPageParam` sayfalı zarftan türetilir; son sayfada
  tanımsız döndür ki dursun.

## Formlar

- react-hook-form + zod resolver. Şema `schemas/` altında, bileşen içinde değil —
  aynı şema hem formda hem başka yerde kullanılabilsin.
- Şemadan tip türet (`z.infer`), tipi elle ikinci kez yazma.
- Sunucu tarafı doğrulama hataları alanlara eşlenmeli; genel bir toast'a düşürüp
  kullanıcıyı hangi alanın yanlış olduğu konusunda karanlıkta bırakma.
