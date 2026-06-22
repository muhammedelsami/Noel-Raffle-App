/// All user-facing Turkish copy lives here so screens stay free of magic strings.
abstract final class AppStrings {
  // App
  static const String appName = 'Noel Raffle';

  // Home
  static const String homeTitle = 'Hediye Çekilişi';
  static const String homeSubtitle = 'Çekiliş türü seçiniz';
  static const String newYearRaffle = 'Yılbaşı Çekilişi';
  static const String giftRaffle = 'Hediye Çekilişi';

  // Menu
  static const String statistics = 'İstatistiklerimiz';
  static const String about = 'Hakkımızda';
  static const String rateUs = 'Bizi Değerlendir';
  static const String website = 'Web Sitemiz';
  static const String contribute = 'Katkıda Bulun';
  static const String close = 'Kapat';
  static const String theme = 'Tema';

  // Raffle setup
  static const String raffleTitleHint = 'Çekiliş Başlığı Giriniz*';
  static const String selectRaffleType = 'Çekiliş Tipi Seçin';
  static const String selectSector = 'Sektör Seçin';
  static const String createNewYearRaffle = 'Yılbaşı Çekilişi Oluştur';
  static const String createGiftRaffle = 'Hediye Çekilişi Oluştur';

  // Participants
  static const String addParticipant = 'Yeni Katılımcı Ekle';
  static const String newParticipant = 'Yeni Katılımcı';
  static const String name = 'İsim';
  static const String surname = 'Soyisim';
  static const String email = 'E-mail';
  static const String add = 'Ekle';
  static const String save = 'Kaydet';
  static const String next = 'Devam Et';

  // Gifts
  static const String addGift = 'Yeni Hediye Ekle';
  static const String giftName = 'Hediye Adı';
  static const String giftCount = 'Hediye Sayısı';
  static const String startRaffle = 'Çekilişi Başlat';

  // Statistics
  static const String statTotalRaffle = 'Çekiliş';
  static const String statNewYearRaffle = 'Yılbaşı Çekilişi';
  static const String statGiftRaffle = 'Hediye Çekilişi';
  static const String statGiftCount = 'Hediye Sayısı';
  static const String statParticipantCount = 'Katılımcı Sayısı';

  // Success
  static const String successMessage =
      'Çekiliş başarıyla tamamlandı.\nLütfen e-postalarınızı kontrol ediniz.';

  // About
  static const String aboutText =
      'Yeni yıl, taptaze bir başlangıçtır. Geçmişi geride bırakıp yeni umutlarla '
      'dolu yarına adım atma vakti gelmiştir. İleriye umutla bakın, hayatın '
      'güzelliklerini keşfedin ve sevdiklerinizle paylaşın. Yeni yıl size '
      'mutluluk, sağlık ve başarı getirsin! 🌟 🎉';
  static const String mobileDevelopers = 'Mobile Developers';
  static const String backendDevelopers = 'BackEnd Developers';

  // Dialogs / validation
  static const String warning = 'Uyarı';
  static const String ok = 'Tamam';
  static const String enterTitle = 'Lütfen çekiliş başlığını giriniz.';
  static const String allFieldsRequired =
      'Tüm alanlar zorunludur ve e-posta geçerli olmalıdır!';
  static const String allGiftFieldsRequired = 'Tüm alanlar zorunludur!';
  static const String emailAlreadyAdded = 'Bu e-posta zaten eklendi!';
  static const String minParticipants = 'En az 3 kişi eklemelisiniz!';
  static const String minGifts = 'En az 3 hediye eklemelisiniz!';
  static const String genericError =
      'Bir hata oluştu. Lütfen tekrar deneyiniz.';
}
