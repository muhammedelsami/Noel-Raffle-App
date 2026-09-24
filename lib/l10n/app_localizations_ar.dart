// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Noel Raffle';

  @override
  String get homeTitle => 'قرعة الهدايا';

  @override
  String get homeSubtitle => 'اختر نوع القرعة';

  @override
  String get newYearRaffle => 'قرعة رأس السنة';

  @override
  String get giftRaffle => 'قرعة الهدايا';

  @override
  String get statistics => 'إحصاءاتنا';

  @override
  String get about => 'من نحن';

  @override
  String get rateUs => 'قيّمنا';

  @override
  String get website => 'موقعنا';

  @override
  String get contribute => 'ساهم';

  @override
  String get close => 'إغلاق';

  @override
  String get theme => 'السمة';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get language => 'اللغة';

  @override
  String get raffleTitleHint => 'أدخل عنوان القرعة*';

  @override
  String get createNewYearRaffle => 'إنشاء قرعة رأس السنة';

  @override
  String get createGiftRaffle => 'إنشاء قرعة الهدايا';

  @override
  String get addParticipant => 'إضافة مشارك جديد';

  @override
  String get newParticipant => 'مشارك جديد';

  @override
  String get name => 'الاسم الكامل';

  @override
  String get add => 'إضافة';

  @override
  String get save => 'حفظ';

  @override
  String get next => 'متابعة';

  @override
  String get addGift => 'إضافة هدية جديدة';

  @override
  String get giftName => 'اسم الهدية';

  @override
  String get giftCount => 'عدد الهدايا';

  @override
  String get startRaffle => 'ابدأ القرعة';

  @override
  String get statTotalRaffle => 'القرعات';

  @override
  String get statNewYearRaffle => 'قرعة رأس السنة';

  @override
  String get statGiftRaffle => 'قرعة الهدايا';

  @override
  String get statGiftCount => 'عدد الهدايا';

  @override
  String get statParticipantCount => 'عدد المشاركين';

  @override
  String get aboutText =>
      'العام الجديد بداية جديدة. حان الوقت لترك الماضي خلفك والخطو نحو غدٍ مليء بآمال جديدة. انظر إلى الأمام بأمل، واكتشف جمال الحياة وشاركها مع أحبائك. عسى أن يجلب لك العام الجديد السعادة والصحة والنجاح! 🌟 🎉';

  @override
  String get mobileDevelopers => 'مطورو تطبيقات الجوال';

  @override
  String get backendDevelopers => 'مطورو الخوادم';

  @override
  String get warning => 'تنبيه';

  @override
  String get ok => 'حسناً';

  @override
  String get enterTitle => 'يرجى إدخال عنوان القرعة.';

  @override
  String get allGiftFieldsRequired => 'جميع الحقول مطلوبة!';

  @override
  String minParticipants(int count) {
    return 'يجب إضافة $count أشخاص على الأقل!';
  }

  @override
  String minGifts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'يجب إضافة $count هدايا على الأقل!',
      one: 'يجب إضافة هدية واحدة على الأقل!',
    );
    return '$_temp0';
  }

  @override
  String get genericError => 'حدث خطأ. يرجى المحاولة مرة أخرى.';

  @override
  String get history => 'السحوبات السابقة';

  @override
  String get viewMyResult => 'اعرض نتيجتي';

  @override
  String get raffleNoteHint => 'ملاحظة للمشاركين (اختياري)';

  @override
  String get emailOptional => 'البريد الإلكتروني (اختياري)';

  @override
  String get nameRequired => 'يرجى إدخال اسم.';

  @override
  String get invalidEmail => 'البريد الإلكتروني غير صالح.';

  @override
  String get nameAlreadyAdded => 'تمت إضافة هذا الاسم بالفعل!';

  @override
  String get tooManyGifts => 'لا يمكن أن يتجاوز عدد الهدايا عدد المشاركين.';

  @override
  String get statsThisDevice => 'على هذا الجهاز';

  @override
  String get statsAllUsers => 'جميع المستخدمين';

  @override
  String get globalStatsError => 'الإحصاءات العامة غير متاحة حاليًا.';

  @override
  String get retry => 'أعد المحاولة';

  @override
  String get resultSecretInfo =>
      'النتائج سرية! مرّروا الهاتف بينكم؛ يضغط كل شخص على اسمه ليعرف لمن سيشتري هدية.';

  @override
  String get resultGiftInfo => 'انتهت القرعة! إليكم الفائزين.';

  @override
  String get tapToReveal => 'اضغط للكشف';

  @override
  String get seen => 'تمت المشاهدة';

  @override
  String revealTitle(String name) {
    return 'يجب أن ينظر $name فقط!';
  }

  @override
  String revealBody(String name) {
    return 'أعطِ الهاتف الآن إلى $name. اضغط \"إظهار\" عند الاستعداد.';
  }

  @override
  String get reveal => 'إظهار';

  @override
  String get hide => 'إخفاء';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String greeting(String name) {
    return 'مرحبًا $name!';
  }

  @override
  String get yourGiftee => 'ستشتري هدية لـ';

  @override
  String get yourPrize => 'جائزتك';

  @override
  String get noPrize => 'لا جائزة هذه المرة. حظًا أوفر في المرة القادمة!';

  @override
  String get noPrizeShort => 'لا جائزة';

  @override
  String get shareResults => 'مشاركة النتائج';

  @override
  String get share => 'مشاركة';

  @override
  String get sendByEmail => 'إرسال بالبريد الإلكتروني';

  @override
  String get publishOnline => 'إنشاء رموز عبر الإنترنت';

  @override
  String get publishInfo =>
      'يُنشأ رمز خاص لكل مشارك. يُدخل المشاركون الرمز في قسم \"اعرض نتيجتي\" في تطبيق Noel Raffle ليروا نتيجتهم فقط.';

  @override
  String get codesReady =>
      'الرموز جاهزة. استخدم زر المشاركة لإرسال رمز كل مشارك إليه.';

  @override
  String get publishFailed =>
      'تعذر إنشاء الرموز. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.';

  @override
  String codeLabel(String code) {
    return 'الرمز: $code';
  }

  @override
  String shareSecretSantaMessage(String title, String name, String match) {
    return '🎄 $title\nمرحبًا $name! في قرعة رأس السنة ستشتري هدية لـ: $match';
  }

  @override
  String shareGiftMessage(String title, String name, String match) {
    return '🎁 $title\nمرحبًا $name! جائزتك في القرعة: $match';
  }

  @override
  String shareNoPrizeMessage(String title, String name) {
    return '🎁 $title\nمرحبًا $name! لا جائزة هذه المرة. حظًا أوفر في المرة القادمة!';
  }

  @override
  String shareCodeMessage(String title, String name, String code, String url) {
    return '🎄 $title\nمرحبًا $name! لمعرفة نتيجتك افتح تطبيق Noel Raffle وأدخل هذا الرمز في قسم \"اعرض نتيجتي\": $code\n\nالتطبيق: $url';
  }

  @override
  String shareNoteLine(String note) {
    return 'ملاحظة: $note';
  }

  @override
  String shareAllTitle(String title) {
    return '🎁 $title — النتائج';
  }

  @override
  String emailSubject(String title) {
    return '$title — نتيجة القرعة';
  }

  @override
  String get historyEmpty => 'لم تُجرِ أي قرعة بعد.';

  @override
  String get deleteRaffleConfirm => 'هل تريد حذف هذه القرعة من السجل؟';

  @override
  String get deleteRaffleCodesNote =>
      'ستتوقف الرموز المرسلة إلى المشاركين عن العمل أيضًا.';

  @override
  String participantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مشارك',
      many: '$count مشاركًا',
      few: '$count مشاركين',
      two: 'مشاركان',
      one: 'مشارك واحد',
    );
    return '$_temp0';
  }

  @override
  String get lookupInfo => 'أدخل الرمز الذي أرسله إليك منظم القرعة.';

  @override
  String get codeHint => 'الرمز (مثال: ABCD-EFGH)';

  @override
  String get invalidCode => 'يجب أن يتكون الرمز من 8 أحرف (مثال: ABCD-EFGH).';

  @override
  String get resultNotFound => 'لم يتم العثور على نتيجة لهذا الرمز.';

  @override
  String get lookupFailed =>
      'تعذر جلب النتيجة. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.';

  @override
  String get showResult => 'اعرض النتيجة';
}
