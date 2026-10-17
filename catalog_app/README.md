# Mini Katalog Uygulaması

Ürün kataloğunu keşfetmek, ürünleri sepete eklemek, demo checkout akışını tamamlamak ve geçmiş siparişleri görüntülemek için geliştirilmiş çok platformlu bir Flutter uygulaması.

## İçindekiler

- [Özellikler](#özellikler)
- [Kullanıcı Akışı](#kullanıcı-akışı)
- [Proje Mimarisi](#proje-mimarisi)
- [Klasör Yapısı](#klasör-yapısı)
- [Veri Saklama ve Güvenlik](#veri-saklama-ve-güvenlik)
- [Teknolojiler](#teknolojiler)
- [Kurulum ve Çalıştırma](#kurulum-ve-çalıştırma)
- [Testler](#testler)
- [Bilinen Sınırlar](#bilinen-sınırlar)

## Özellikler

- Yerel hesap oluşturma ve kayıtlı kullanıcı bilgileriyle giriş
- WantAPI üzerinden ürün kataloğunu yükleme
- Ürün adı, sloganı ve açıklamasına göre arama
- Ürün detaylarını inceleme ve ürünleri sepete ekleme
- Uygulama yeniden başlatıldığında sepeti geri yükleme
- İletişim, adres ve ödeme alanlarını içeren checkout formu
- Tamamlanan siparişleri cihazda saklama ve sipariş geçmişinde görüntüleme
- Sipariş numarası, tarih, ürünler, toplam tutar ve teslimat adresi ayrıntıları

## Kullanıcı Akışı

1. İlk kullanımda kullanıcı kayıt olur ve giriş ekranından oturum açar.
2. Uygulama açılırken kayıtlı oturum ve sepet yüklenir.
3. Ana ekranda ürünler görüntülenir; arama ile katalog daraltılabilir.
4. Ürün detayından sepete ekleme yapılır; sepet miktarı üst bardaki rozetle gösterilir.
5. Checkout formu geçerliyse sipariş yerel geçmişe kaydedilir ve sepet temizlenir.
6. Ana ekrandaki siparişler simgesinden geçmiş açılır; satır genişletilerek ürün ve teslimat bilgileri görülür.

## Proje Mimarisi

Uygulama, ekranları, veri modellerini, tekrar kullanılabilir arayüz parçalarını ve depolama/API işlemlerini ayrı sorumluluklarda tutar.

| Katman | Sorumluluk |
| --- | --- |
| `views/` | Ekranların yerleşimi, kullanıcı etkileşimleri ve ekranlar arası gezinme |
| `components/` | Ürün kartı, ürün görseli ve sipariş geçmişi satırı gibi tekrar kullanılan arayüz parçaları |
| `models/` | API ürünleri ve sipariş kayıtları için JSON dönüşümü olan veri sınıfları |
| `services/` | WantAPI erişimi, yerel depolama, sepet ve sipariş geçmişi işlemleri |
| `main.dart` | Flutter başlangıcı, sepet/oturum yükleme ve başlangıç ekranının seçimi |

Önemli veri akışları:

- `HomeScreen` -> `ApiService` -> WantAPI -> `Products`/`Data` modelleri
- Ürün detay ekranı -> `CartManager` -> SharedPreferences sepet kaydı
- Checkout ekranı -> `OrderHistoryService` -> sipariş kaydı -> sepetin temizlenmesi
- Uygulama başlangıcı -> sepet ve oturumun okunması -> giriş veya katalog ekranı

## Klasör Yapısı

```text
catalog_app/
├── lib/
│   ├── components/
│   │   ├── order_history_item.dart
│   │   ├── product_card.dart
│   │   └── product_image.dart
│   ├── models/
│   │   ├── order_model.dart
│   │   └── products_model.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── cart_manager.dart
│   │   ├── local_storage_service.dart
│   │   └── order_history_service.dart
│   ├── views/
│   │   ├── cart_screen.dart
│   │   ├── checkout_screen.dart
│   │   ├── home_screen.dart
│   │   ├── login_screen.dart
│   │   ├── order_history_screen.dart
│   │   ├── products_detail_screen.dart
│   │   └── register_screen.dart
│   └── main.dart
├── test/
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
├── analysis_options.yaml
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

### Önemli Dosyalar

- `lib/services/api_service.dart`: `https://wantapi.com/products.php` adresinden ürünleri getirir.
- `lib/services/local_storage_service.dart`: Oturum ve kullanıcı metaverisini, ayrıca güvenli parola erişimini yönetir.
- `lib/services/cart_manager.dart`: Sepet içeriğini yükler, değiştirir, kaydeder ve toplamı hesaplar.
- `lib/services/order_history_service.dart`: Siparişleri yerel depolamaya yazar ve geçmiş için okur.
- `lib/models/order_model.dart`: Sipariş ve sipariş kalemlerinin serileştirilmesini sağlar.


## Veri Saklama ve Güvenlik

- Kullanıcı adı/e-posta gibi hesap metaverileri ve oturum bayrağı `SharedPreferences` içinde tutulur.
- Parolalar `flutter_secure_storage` aracılığıyla platformun güvenli saklama alanına yazılır.
- Sepet ve sipariş geçmişi yerel JSON kayıtları olarak cihazda saklanır; sunucuya senkronize edilmez.
- Checkout formundaki kart numarası ve güvenlik kodu sipariş kaydına eklenmez.
- Sipariş geçmişi cihazdaki yerel depolamaya bağlıdır; uygulamanın kaldırılması veya uygulama verisinin silinmesi bu kayıtları silebilir.

## Teknolojiler

- Flutter 3.41.6 (stable)
- Dart 3.11.4
- `http`: ürün API istekleri
- `shared_preferences`: oturum, sepet ve sipariş geçmişi kayıtları
- `flutter_secure_storage`: parola saklama
- `flutter_test`: widget ve servis davranışlarının test edilmesi

## Kurulum ve Çalıştırma

Gereksinimler:

- Flutter 3.41.6 veya uyumlu daha yeni bir Flutter SDK
- SDK ile gelen Dart 3.11.4 veya uyumlu sürüm
- Ürün kataloğu için internet bağlantısı
- Android Studio, Xcode veya hedef platform için uygun Flutter cihaz/araç kurulumu

Depo kökünden proje klasörüne geçip bağımlılıkları yükleyin:

```bash
cd catalog_app
flutter pub get
```

Bağlı cihazları listeleyin ve uygulamayı başlatın:

```bash
flutter devices
flutter run
```

Belirli bir cihaza çalıştırmak için:

```bash
flutter run -d <device-id>
```

İlk açılışta kayıt ekranından yerel hesap oluşturup giriş yapın. Sonraki açılışlarda geçerli oturum bulunursa katalog ekranı açılır.

## Testler

Statik analiz için:

```bash
flutter analyze
```

## Bilinen Sınırlar

- Checkout bir demo akışıdır; gerçek ödeme sağlayıcısına bağlanmaz ve ödeme almaz.
- Hesaplar, sepet ve siparişler cihazla sınırlıdır; farklı cihazlar arasında eşitlenmez.
- Ürün kataloğunun yüklenmesi WantAPI servisine ve internet bağlantısına bağlıdır.
