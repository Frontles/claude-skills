---
description: Bu projeyi tarar ve /yap'ın kullanacağı .claude/yap.md proje katmanını oluşturur
---

# /yap-init — proje katmanını üret

Bu projede `.claude/yap.md` yoksa (ya da eskiyse) onu üretmek için buradasın.
`/yap` genel iskelettir; projeye özel her şey o dosyada durur. **Doğru dosya
üretmenin tek yolu projeyi gerçekten taramaktır — şablon doldurma.**

## 1. Tara

Şunları oku, tahmin etme:

- `package.json` — script'ler, bağımlılıklar ve **majorları**; workspace var mı
- Paket yöneticisi — `packageManager` alanı, lock dosyaları, `Dockerfile`/CI komutu.
  **Çelişki varsa deploy'un kullandığı kazanır**; çelişkiyi rapora yaz
- Kök dosyalar — `CLAUDE.md`, `AGENTS.md`, `README.md`, `docs/`, `Dockerfile`,
  `docker-compose*.yml`, `.env.example` (gerçek `.env` DEĞİL)
- Klasör ağacı — `src/` altı 2-3 seviye; hangi düzen kullanılıyor
- Paylaşılan bileşen klasörü — **dosya dosya listele**, isimlerinden ne işe
  yaradıklarını çıkar
- Veri katmanı — api client, endpoint klasörü, query key dosyası, hook'lar, şemalar
- Yetki — rol sabitleri, guard dosyası, middleware
- Çeviri — hangi kütüphane, hangi dosyalar, anahtar ağacının üst seviyesi
- Ayrı backend var mı — kardeş klasör, `prisma/schema.prisma`, route/controller ağacı
- Test — hangi runner, kurulum dosyaları, özel render yardımcısı, e2e
- `git log --oneline -20` — commit mesajı dili ve üslubu
- `git remote -v` — kaç repo, nereye bağlı

Aynı anda birden fazla arama çalıştır; tek tek gitme.

## 2. Sor (yalnızca koddan çıkmayanı)

Kodda bulunamayan ama kritik olan şeyler için kullanıcıya sor. Tipik olarak:

- Bu projede özel dikkat isteyen alan hangisi (para, ödeme, yetki, kota)?
- Devam eden bir migrasyon/refactor var mı, hangi doküman anlatıyor?
- Kaçınılması gereken bir şey var mı (dokunulmayacak dosya, eski API)?

Cevaplar birkaç satırsa uydurma; yazmadığın şeyi dosyaya koyma.

## 3. Yaz

`.claude/yap.md` üret. Şu bölümler olsun, **hepsi bu projenin gerçeğiyle dolu**:

```markdown
# <proje> — /yap proje katmanı

## Yapı
<repo sayısı, klasörler, ne nerede — gerçek yollarla>

## Sürümler ve paket yöneticisi
<tespit edilenler; çelişki varsa açıkça yaz>

## Komutlar
<doğrulama sırası: typecheck → lint → test → e2e; gerçek script adlarıyla>

## Katman sırası
<bu projede yeni bir özellik hangi sırayla yazılır — gerçek klasör adlarıyla>

## Paylaşılan bileşen kataloğu
<ihtiyaç → bileşen tablosu; yenisini yazmadan önce buraya bakılır>

## Sözleşmeler
<api zarfı, hata biçimi, rol matrisi, çeviri dosyaları listesi>

## Domain kuralları
<bu projede bozulmaması gereken iş kuralları; yoksa bölümü koyma>

## Değişmezler
<bu projeye özel "asla yapma" maddeleri>
```

Kurallar:

- **Bulmadığın şeyi yazma.** Boş bölüm, uydurulmuş bölümden iyidir.
- **Yol ver.** "bileşenler paylaşılan klasörde" değil, `src/components/shared/`.
- **Genel tavsiye yazma.** "Temiz kod yaz" gibi satırlar `/yap`'ın kendisinde
  zaten var; buraya sadece bu projeye özgü olan girer.
- **Kısa tut.** Hedef 100-150 satır. Uzarsa referans dosyalarına böl
  (`.claude/yap/` klasörü) ve ana dosyadan bağla.
- Dosyanın dili projenin dili olsun (commit mesajları hangi dildeyse).

## 4. Doğrula ve bitir

- `.claude/yap.md` yazıldıktan sonra **doğrulama komutlarını bir kez çalıştır**
  ki dosyaya yazdığın komutlar gerçekten çalışıyor olsun. Çalışmıyorsa düzelt.
- Kullanıcıya özetle: hangi yapı bulundu, hangi bölümler dolduruldu, hangileri
  boş kaldı ve neden.
- Şunu hatırlat: bundan sonra bu projede sadece `/yap <görev>` yazması yeterli.
