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
  String get homeTitle => 'Yeni bir çekiliş başlat';

  @override
  String get homeSubtitle => 'Etkinliğinize uygun çekiliş türünü seçin.';

  @override
  String get newYearRaffle => 'Yılbaşı Çekilişi';

  @override
  String get giftRaffle => 'Hediye Çekilişi';

  @override
  String get statistics => 'İstatistikler';

  @override
  String get about => 'Hakkımızda';

  @override
  String get rateUs => 'Bizi değerlendirin';

  @override
  String get website => 'Web sitemiz';

  @override
  String get contribute => 'GitHub\'da katkıda bulunun';

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
  String get raffleTitleHint => 'Çekiliş başlığı';

  @override
  String get addParticipant => 'Katılımcı ekle';

  @override
  String get newParticipant => 'Yeni katılımcı';

  @override
  String get name => 'Ad Soyad';

  @override
  String get add => 'Ekle';

  @override
  String get save => 'Kaydet';

  @override
  String get next => 'Devam et';

  @override
  String get addGift => 'Hediye ekle';

  @override
  String get giftName => 'Hediye adı';

  @override
  String get giftCount => 'Adet';

  @override
  String get startRaffle => 'Çekilişi başlat';

  @override
  String get statTotalRaffle => 'Toplam çekiliş';

  @override
  String get statNewYearRaffle => 'Yılbaşı Çekilişi';

  @override
  String get statGiftRaffle => 'Hediye Çekilişi';

  @override
  String get statGiftCount => 'Hediye';

  @override
  String get statParticipantCount => 'Katılımcı';

  @override
  String get aboutText =>
      'Yeni yıl, taptaze bir başlangıçtır. Geçmişi geride bırakıp yeni umutlarla dolu yarına adım atma vakti gelmiştir. İleriye umutla bakın, hayatın güzelliklerini keşfedin ve sevdiklerinizle paylaşın. Yeni yıl size mutluluk, sağlık ve başarı getirsin! 🌟 🎉';

  @override
  String get mobileDevelopers => 'Mobil geliştiriciler';

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
  String get history => 'Geçmiş çekilişler';

  @override
  String get viewMyResult => 'Sonucumu gör';

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
  String get retry => 'Tekrar dene';

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
  String get shareResults => 'Sonuçları paylaş';

  @override
  String get share => 'Paylaş';

  @override
  String get sendByEmail => 'E-posta ile gönder';

  @override
  String get publishOnline => 'Çevrimiçi kod oluştur';

  @override
  String get publishInfo =>
      'Her katılımcı için kişiye özel bir kod oluşturulur. Katılımcılar Noel Raffle uygulamasında \"Sonucumu gör\" bölümüne kodu girerek yalnızca kendi sonucunu görür.';

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
    return '🎄 $title\nMerhaba $name! Çekiliş sonucunu görmek için Noel Raffle uygulamasını aç ve \"Sonucumu gör\" bölümüne şu kodu gir: $code\n\nUygulama: $url';
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
  String get showResult => 'Sonucu göster';

  @override
  String get newYearRaffleDescription =>
      'Gizli Noel Baba: herkes başka birine hediye alır.';

  @override
  String get giftRaffleDescription =>
      'Hediyelerinizi rastgele katılımcılara dağıtın.';

  @override
  String get lookupDescription =>
      'Organizatörden kod mu aldınız? Sonucunuzu görün.';

  @override
  String get quickAccess => 'Hızlı erişim';

  @override
  String get settings => 'Ayarlar';

  @override
  String get more => 'Diğer';

  @override
  String get support => 'Bize destek olun';

  @override
  String get raffleDetails => 'Çekiliş bilgileri';

  @override
  String get raffleDetailsInfo =>
      'Çekilişinize bir ad verin. İsterseniz katılımcılara bir not da bırakabilirsiniz.';

  @override
  String stepProgress(int current, int total) {
    return 'Adım $current/$total';
  }

  @override
  String get participantsTitle => 'Katılımcılar';

  @override
  String participantsInfo(int count) {
    return 'En az $count kişi ekleyin. Düzenlemek için bir isme dokunun.';
  }

  @override
  String get participantsEmpty => 'Henüz katılımcı yok';

  @override
  String get giftsTitle => 'Hediyeler';

  @override
  String get giftsInfo =>
      'Dağıtılacak hediyeleri ekleyin. Her kişi en fazla bir hediye kazanır.';

  @override
  String get giftsEmpty => 'Henüz hediye yok';

  @override
  String get editGift => 'Hediyeyi düzenle';

  @override
  String get editParticipant => 'Katılımcıyı düzenle';

  @override
  String giftQuantity(int count) {
    return 'Adet: $count';
  }

  @override
  String giftUnits(int count) {
    return '$count hediye';
  }

  @override
  String revealProgress(int seen, int total) {
    return '$total kişiden $seen kişi baktı';
  }

  @override
  String get newGift => 'Yeni hediye';
}
