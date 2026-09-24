// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Noel Raffle';

  @override
  String get homeTitle => 'Hediye Çekilişi';

  @override
  String get homeSubtitle => 'Çekiliş türü seçiniz';

  @override
  String get newYearRaffle => 'Yılbaşı Çekilişi';

  @override
  String get giftRaffle => 'Hediye Çekilişi';

  @override
  String get statistics => 'İstatistiklerimiz';

  @override
  String get about => 'Hakkımızda';

  @override
  String get rateUs => 'Bizi Değerlendir';

  @override
  String get website => 'Web Sitemiz';

  @override
  String get contribute => 'Katkıda Bulun';

  @override
  String get close => 'Kapat';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get language => 'Dil';

  @override
  String get raffleTitleHint => 'Çekiliş Başlığı Giriniz*';

  @override
  String get createNewYearRaffle => 'Yılbaşı Çekilişi Oluştur';

  @override
  String get createGiftRaffle => 'Hediye Çekilişi Oluştur';

  @override
  String get addParticipant => 'Yeni Katılımcı Ekle';

  @override
  String get newParticipant => 'Yeni Katılımcı';

  @override
  String get name => 'Ad Soyad';

  @override
  String get add => 'Ekle';

  @override
  String get save => 'Kaydet';

  @override
  String get next => 'Devam Et';

  @override
  String get addGift => 'Yeni Hediye Ekle';

  @override
  String get giftName => 'Hediye Adı';

  @override
  String get giftCount => 'Hediye Sayısı';

  @override
  String get startRaffle => 'Çekilişi Başlat';

  @override
  String get statTotalRaffle => 'Çekiliş';

  @override
  String get statNewYearRaffle => 'Yılbaşı Çekilişi';

  @override
  String get statGiftRaffle => 'Hediye Çekilişi';

  @override
  String get statGiftCount => 'Hediye Sayısı';

  @override
  String get statParticipantCount => 'Katılımcı Sayısı';

  @override
  String get aboutText =>
      'Yeni yıl, taptaze bir başlangıçtır. Geçmişi geride bırakıp yeni umutlarla dolu yarına adım atma vakti gelmiştir. İleriye umutla bakın, hayatın güzelliklerini keşfedin ve sevdiklerinizle paylaşın. Yeni yıl size mutluluk, sağlık ve başarı getirsin! 🌟 🎉';

  @override
  String get mobileDevelopers => 'Mobile Developers';

  @override
  String get backendDevelopers => 'BackEnd Developers';

  @override
  String get warning => 'Uyarı';

  @override
  String get ok => 'Tamam';

  @override
  String get enterTitle => 'Lütfen çekiliş başlığını giriniz.';

  @override
  String get allGiftFieldsRequired => 'Tüm alanlar zorunludur!';

  @override
  String minParticipants(int count) {
    return 'En az $count kişi eklemelisiniz!';
  }

  @override
  String minGifts(int count) {
    return 'En az $count hediye eklemelisiniz!';
  }

  @override
  String get genericError => 'Bir hata oluştu. Lütfen tekrar deneyiniz.';

  @override
  String get history => 'Geçmiş Çekilişler';

  @override
  String get viewMyResult => 'Sonucumu Gör';

  @override
  String get raffleNoteHint => 'Katılımcılara not (isteğe bağlı)';

  @override
  String get emailOptional => 'E-posta (isteğe bağlı)';

  @override
  String get nameRequired => 'Lütfen bir isim giriniz.';

  @override
  String get invalidEmail => 'E-posta adresi geçerli değil.';

  @override
  String get nameAlreadyAdded => 'Bu isim zaten eklendi!';

  @override
  String get tooManyGifts =>
      'Toplam hediye sayısı katılımcı sayısından fazla olamaz.';

  @override
  String get statsThisDevice => 'Bu cihazda';

  @override
  String get statsAllUsers => 'Tüm kullanıcılar';

  @override
  String get globalStatsError => 'Genel istatistikler şu an alınamıyor.';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get resultSecretInfo =>
      'Sonuçlar gizli! Telefonu sırayla herkese verin; herkes kendi adına dokunup kime hediye alacağını görsün.';

  @override
  String get resultGiftInfo => 'Çekiliş tamamlandı! İşte kazananlar.';

  @override
  String get tapToReveal => 'Görmek için dokun';

  @override
  String get seen => 'Görüldü';

  @override
  String revealTitle(String name) {
    return 'Sadece $name baksın!';
  }

  @override
  String revealBody(String name) {
    return 'Telefonu şimdi bu kişiye verin: $name. Hazır olunca \"Göster\"e dokunun.';
  }

  @override
  String get reveal => 'Göster';

  @override
  String get hide => 'Gizle';

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String greeting(String name) {
    return 'Merhaba $name!';
  }

  @override
  String get yourGiftee => 'Hediye alacağın kişi';

  @override
  String get yourPrize => 'Kazandığın hediye';

  @override
  String get noPrize => 'Bu sefer hediye çıkmadı. Bir dahaki sefere!';

  @override
  String get noPrizeShort => 'Hediye çıkmadı';

  @override
  String get shareResults => 'Sonuçları Paylaş';

  @override
  String get share => 'Paylaş';

  @override
  String get sendByEmail => 'E-posta ile gönder';

  @override
  String get publishOnline => 'Çevrimiçi Kod Oluştur';

  @override
  String get publishInfo =>
      'Her katılımcı için kişiye özel bir kod oluşturulur. Katılımcılar Noel Raffle uygulamasında \"Sonucumu Gör\" bölümüne kodu girerek yalnızca kendi sonucunu görür.';

  @override
  String get codesReady =>
      'Çevrimiçi kodlar hazır. Paylaş simgesiyle her katılımcıya kendi kodunu gönderin.';

  @override
  String get publishFailed =>
      'Kodlar oluşturulamadı. İnternet bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String codeLabel(String code) {
    return 'Kod: $code';
  }

  @override
  String shareSecretSantaMessage(String title, String name, String match) {
    return '🎄 $title\nMerhaba $name! Yılbaşı çekilişinde hediye alacağın kişi: $match';
  }

  @override
  String shareGiftMessage(String title, String name, String match) {
    return '🎁 $title\nMerhaba $name! Çekilişte kazandığın hediye: $match';
  }

  @override
  String shareNoPrizeMessage(String title, String name) {
    return '🎁 $title\nMerhaba $name! Bu sefer hediye çıkmadı. Bir dahaki sefere!';
  }

  @override
  String shareCodeMessage(String title, String name, String code, String url) {
    return '🎄 $title\nMerhaba $name! Çekiliş sonucunu görmek için Noel Raffle uygulamasını aç ve \"Sonucumu Gör\" bölümüne şu kodu gir: $code\n\nUygulama: $url';
  }

  @override
  String shareNoteLine(String note) {
    return 'Not: $note';
  }

  @override
  String shareAllTitle(String title) {
    return '🎁 $title — Sonuçlar';
  }

  @override
  String emailSubject(String title) {
    return '$title — Çekiliş sonucun';
  }

  @override
  String get historyEmpty => 'Henüz bir çekiliş yapmadınız.';

  @override
  String get deleteRaffleConfirm => 'Bu çekiliş geçmişten silinsin mi?';

  @override
  String get deleteRaffleCodesNote =>
      'Katılımcılara gönderilen çevrimiçi kodlar da geçersiz olacak.';

  @override
  String participantCount(int count) {
    return '$count katılımcı';
  }

  @override
  String get lookupInfo =>
      'Çekilişi düzenleyen kişinin sana gönderdiği kodu gir.';

  @override
  String get codeHint => 'Kod (ör. ABCD-EFGH)';

  @override
  String get invalidCode => 'Kod 8 karakterden oluşmalıdır (ör. ABCD-EFGH).';

  @override
  String get resultNotFound => 'Bu koda ait bir sonuç bulunamadı.';

  @override
  String get lookupFailed =>
      'Sonuç alınamadı. İnternet bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get showResult => 'Sonucu Göster';
}
