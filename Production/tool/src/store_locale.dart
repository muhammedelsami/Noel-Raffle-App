import 'package:flutter/widgets.dart';

/// A headline and a supporting line printed above a store screenshot.
typedef Caption = ({String headline, String subline});

/// The screenshots of the listing, in the order the store shows them.
enum StoreShot { home, participants, reveal, progress, prizes, personalize }

/// A Play Store listing language: its marketing copy and the sample data
/// shown inside the screenshots, so every language looks native.
enum StoreLocale {
  en(
    playCode: 'en-US',
    locale: Locale('en'),
    tagline: 'Secret Santa and gift raffles, made simple',
    captions: <StoreShot, Caption>{
      StoreShot.home: (
        headline: 'Secret Santa & gift raffles',
        subline: 'Set up a fair draw in seconds',
      ),
      StoreShot.participants: (
        headline: 'Add everyone in seconds',
        subline: 'Names, optional emails and a note for the group',
      ),
      StoreShot.reveal: (
        headline: 'Results stay secret',
        subline: 'Pass the phone: everyone sees only their own match',
      ),
      StoreShot.progress: (
        headline: 'See who has looked',
        subline: 'Track the reveals and share each result privately',
      ),
      StoreShot.prizes: (
        headline: 'Hand out prizes fairly',
        subline: 'Random winners, at most one gift per person',
      ),
      StoreShot.personalize: (
        headline: 'Light or dark, in 3 languages',
        subline: 'Your raffle history stays on your device',
      ),
    },
    names: <String>[
      'Emma Johnson',
      'Liam Carter',
      'Olivia Brown',
      'Noah Wilson',
      'Ava Davis',
    ],
    email: 'emma@example.com',
    newYearTitle: 'Office Holiday Party',
    giftTitle: 'Team Gift Raffle',
    note: r'Gift budget: $25. We swap gifts on Friday!',
    gifts: <String>['Headphones', 'Book', 'Thermos'],
    pastTitles: <String>['Family Christmas Eve', 'Book Club Swap'],
  ),
  tr(
    playCode: 'tr-TR',
    locale: Locale('tr'),
    tagline: 'Yılbaşı ve hediye çekilişleri artık çok kolay',
    captions: <StoreShot, Caption>{
      StoreShot.home: (
        headline: 'Yılbaşı ve hediye çekilişleri',
        subline: 'Saniyeler içinde adil bir çekiliş kurun',
      ),
      StoreShot.participants: (
        headline: 'Herkesi saniyeler içinde ekleyin',
        subline: 'İsimler, isteğe bağlı e-postalar ve gruba bir not',
      ),
      StoreShot.reveal: (
        headline: 'Sonuçlar gizli kalır',
        subline:
            'Telefonu sırayla verin, herkes yalnızca kendi sonucunu görsün',
      ),
      StoreShot.progress: (
        headline: 'Kimin baktığını görün',
        subline: 'Görenleri takip edin, her sonucu kişiye özel paylaşın',
      ),
      StoreShot.prizes: (
        headline: 'Hediyeleri adilce dağıtın',
        subline: 'Rastgele kazananlar, kişi başı en fazla bir hediye',
      ),
      StoreShot.personalize: (
        headline: 'Açık ya da koyu, 3 dilde',
        subline: 'Çekiliş geçmişiniz cihazınızda kalır',
      ),
    },
    names: <String>[
      'Ayşe Yılmaz',
      'Burak Demir',
      'Cem Kaya',
      'Deniz Aksoy',
      'Elif Şahin',
    ],
    email: 'ayse@example.com',
    newYearTitle: 'Ofis Yılbaşı Partisi',
    giftTitle: 'Şirket Hediye Çekilişi',
    note: 'Hediye bütçesi 500 TL. Cuma günü ofiste açıyoruz!',
    gifts: <String>['Kulaklık', 'Kitap', 'Termos'],
    pastTitles: <String>['Aile Yılbaşı Gecesi', 'Kitap Kulübü Takası'],
  ),
  ar(
    playCode: 'ar',
    locale: Locale('ar'),
    tagline: 'قرعة بابا نويل السري والهدايا بكل سهولة',
    captions: <StoreShot, Caption>{
      StoreShot.home: (
        headline: 'قرعة بابا نويل السري والهدايا',
        subline: 'جهّز قرعة عادلة في ثوانٍ',
      ),
      StoreShot.participants: (
        headline: 'أضف الجميع في ثوانٍ',
        subline: 'الأسماء وبريد إلكتروني اختياري وملاحظة للمجموعة',
      ),
      StoreShot.reveal: (
        headline: 'النتائج تبقى سرية',
        subline: 'مرّروا الهاتف، ولا يرى كل شخص إلا نتيجته',
      ),
      StoreShot.progress: (
        headline: 'اعرف من شاهد نتيجته',
        subline: 'تابع من كشف نتيجته وشارك كل نتيجة بشكل خاص',
      ),
      StoreShot.prizes: (
        headline: 'وزّع الجوائز بعدل',
        subline: 'فائزون عشوائيون، وهدية واحدة كحد أقصى لكل شخص',
      ),
      StoreShot.personalize: (
        headline: 'فاتح أو داكن، بثلاث لغات',
        subline: 'يبقى سجل قرعاتك على جهازك',
      ),
    },
    names: <String>[
      'أحمد سالم',
      'فاطمة علي',
      'يوسف حسن',
      'مريم خالد',
      'عمر نبيل',
    ],
    email: 'ahmed@example.com',
    newYearTitle: 'حفلة رأس السنة في المكتب',
    giftTitle: 'قرعة هدايا الفريق',
    note: 'ميزانية الهدية ١٠٠ ريال. نتبادل الهدايا يوم الجمعة!',
    gifts: <String>['سماعات', 'كتاب', 'ترمس'],
    pastTitles: <String>['سهرة العائلة', 'تبادل نادي الكتاب'],
  );

  const StoreLocale({
    required this.playCode,
    required this.locale,
    required this.tagline,
    required this.captions,
    required this.names,
    required this.email,
    required this.newYearTitle,
    required this.giftTitle,
    required this.note,
    required this.gifts,
    required this.pastTitles,
  });

  /// Play Console language code, also the metadata folder name.
  final String playCode;
  final Locale locale;

  /// Line under the app name on the feature graphic.
  final String tagline;
  final Map<StoreShot, Caption> captions;

  /// Five participants; the first one has [email].
  final List<String> names;
  final String email;
  final String newYearTitle;
  final String giftTitle;
  final String note;

  /// Three prizes for the gift raffle.
  final List<String> gifts;

  /// Older raffles listed in the history screenshot.
  final List<String> pastTitles;

  TextDirection get textDirection =>
      locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
}
