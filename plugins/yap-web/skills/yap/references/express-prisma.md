# Ayrı backend katmanı — Express + Prisma (+ kuyruk, soket)

Bu referans, frontend'den **ayrı bir repo/klasörde** Express backend'i olan
projeler içindir. Next.js route handler'ı kullanan projelerde de aynı ilkeler
geçerli; gerçek yollar `.claude/yap.md` dosyasında.

## Katman sırası

```
routes/           mount + yetki + doğrulama zinciri
  middleware/     format/zorunluluk kontrolleri — controller temiz kalsın
  controllers/    iş akışı, sorgu, cevap
  services/       dış entegrasyon, mail, ödeme, bildirim
utils/            ortak yardımcılar (cevap zarfı, prisma örneği, çeviri)
prisma/schema.prisma   tek kaynak
```

## Cevap zarfı

Projenin bir cevap yardımcısı varsa (`responseHelper` benzeri) controller
**elle `res.json` yazmaz**. Zarfın şekli frontend tipleriyle sözleşmedir;
uç başına yeni zarf uydurmak sessiz hatalara yol açar.

Hata cevabında makine-okunur bir `code` alanı varsa **anlamlı doldur** —
frontend o kodla kendi çevirisini arıyor.

## Yetki

- Rol kontrolü route seviyesinde middleware ile; controller içine dağıtma.
- Kimlik doğrulama hatası (token yok/bozuk) ile yetki hatası (rolü yetmiyor)
  farklı durum kodlarıdır ve frontend bunlara farklı tepki verir. Mevcut
  uçların hangisini ne zaman döndürdüğüne bak, aynısını yap.
- Kaynak sahipliği kontrolünü unutma: rolü doğru olan kullanıcı **başkasının**
  kaydına erişebiliyorsa açık var.

## Route yazımı

- Sabit path'ler `/:id` kalıbından **önce** tanımlanır; yoksa `/ara` çağrısı
  id değeri "ara" sanılır.
- Her router'ın başında ortak middleware (dil, oturum) tek yerde.

## Prisma

- Client tek yerden import edilir; her dosyada yeni bir örnek bağlantı sızdırır.
- Şema değişimi: düzenle → `prisma validate` → **kullanıcıdan onay al** →
  `prisma migrate dev --name <ad>` → gerekiyorsa veri taşıma (backfill) script'i.
- Var olan sütunu silmek veya yeniden adlandırmak veri kaybıdır; migration'ı
  üretmeden önce ne kaybedileceğini söyle.
- N+1'e dikkat: döngü içinde sorgu yerine `include` ya da `in` ile toplu çek.
- Sayfalı listede `skip`/`take` ile birlikte toplam sayıyı da döndür.

## Kuyruk ve zamanlanmış işler

- Çok replikalı çalışan bir API'de **in-process cron kullanma** — her replika
  aynı işi tetikler. Kuyruk (BullMQ vb.) üzerinden tekilleştir.
- Cron ifadesine **her zaman saat dilimi** ver; UTC container'da günlük iş
  gece yarısından kayar.
- İş gövdesi yeniden çalıştırılabilir (idempotent) olsun; kuyruk aynı işi
  tekrar deneyebilir.
- Redis kalıpları için `redis-core` ve `redis-connections` skill'leri var.

## Gerçek zamanlı

- Soket olayları çok replikalı ortamda adapter (Redis vb.) ister; yoksa
  kullanıcı yanlış replikaya bağlıysa olayı almaz.
- Olay adlarını ve payload şeklini frontend tipleriyle birlikte güncelle.

## Test

- Uygulamayı dinlemeye açmadan kurabilen bir fabrika (`createApp()`) üzerinden
  test et; supertest bunu doğrudan kullanır.
- Cevap gövdesinin şeklini donduran "golden" testler varsa, şekli bilerek
  değiştirdiğinde onları da bilerek güncelle — sessizce ezme.
