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
  String get homeTitle => 'ابدأ قرعة جديدة';

  @override
  String get homeSubtitle => 'اختر نوع القرعة المناسب لمناسبتك.';

  @override
  String get newYearRaffle => 'قرعة رأس السنة';

  @override
  String get giftRaffle => 'قرعة الهدايا';

  @override
  String get statistics => 'الإحصاءات';

  @override
  String get about => 'من نحن';

  @override
  String get rateUs => 'قيّمنا';

  @override
  String get website => 'موقعنا';

  @override
  String get contribute => 'ساهم على GitHub';

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
  String get raffleTitleHint => 'عنوان القرعة';

  @override
  String get addParticipant => 'إضافة مشارك';

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
  String get addGift => 'إضافة هدية';

  @override
  String get giftName => 'اسم الهدية';

  @override
  String get giftCount => 'الكمية';

  @override
  String get startRaffle => 'ابدأ القرعة';

  @override
  String get statTotalRaffle => 'إجمالي القرعات';

  @override
  String get statNewYearRaffle => 'قرعة رأس السنة';

  @override
  String get statGiftRaffle => 'قرعة الهدايا';

  @override
  String get statGiftCount => 'الهدايا';

  @override
  String get statParticipantCount => 'المشاركون';

  @override
  String get aboutText =>
      'العام الجديد بداية جديدة. حان الوقت لترك الماضي خلفك والخطو نحو غدٍ مليء بآمال جديدة. انظر إلى الأمام بأمل، واكتشف جمال الحياة وشاركها مع أحبائك. عسى أن يجلب لك العام الجديد السعادة والصحة والنجاح! 🌟 🎉';

  @override
  String get mobileDevelopers => 'مطورو تطبيقات الجوال';

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
  String get history => 'القرعات السابقة';

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

  @override
  String get newYearRaffleDescription =>
      'بابا نويل السري: يشتري كل شخص هدية لشخص آخر.';

  @override
  String get giftRaffleDescription =>
      'وزّع هداياك على مشاركين يُختارون عشوائيًا.';

  @override
  String get lookupDescription => 'هل وصلك رمز من المنظّم؟ اعرض نتيجتك.';

  @override
  String get quickAccess => 'وصول سريع';

  @override
  String get settings => 'الإعدادات';

  @override
  String get more => 'المزيد';

  @override
  String get support => 'ادعمنا';

  @override
  String get raffleDetails => 'تفاصيل القرعة';

  @override
  String get raffleDetailsInfo =>
      'أعطِ القرعة اسمًا، ويمكنك أيضًا ترك ملاحظة للمشاركين.';

  @override
  String stepProgress(int current, int total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get participantsTitle => 'المشاركون';

  @override
  String participantsInfo(int count) {
    return 'أضف $count أشخاص على الأقل. اضغط على أي اسم لتعديله.';
  }

  @override
  String get participantsEmpty => 'لا يوجد مشاركون بعد';

  @override
  String get giftsTitle => 'الهدايا';

  @override
  String get giftsInfo =>
      'أضف الهدايا التي ستوزَّع. يفوز كل شخص بهدية واحدة على الأكثر.';

  @override
  String get giftsEmpty => 'لا توجد هدايا بعد';

  @override
  String get editGift => 'تعديل الهدية';

  @override
  String get editParticipant => 'تعديل المشارك';

  @override
  String giftQuantity(int count) {
    return 'الكمية: $count';
  }

  @override
  String giftUnits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count هدية',
      many: '$count هدية',
      few: '$count هدايا',
      two: 'هديتان',
      one: 'هدية واحدة',
      zero: 'لا هدايا',
    );
    return '$_temp0';
  }

  @override
  String revealProgress(int seen, int total) {
    return 'كشف $seen من $total';
  }

  @override
  String get newGift => 'هدية جديدة';

  @override
  String get matchRules => 'قواعد المطابقة';

  @override
  String get matchRulesInfo =>
      'امنع الأزواج أو أي شخصين آخرين من أن يسحب أحدهما الآخر.';

  @override
  String get addRule => 'إضافة قاعدة';

  @override
  String get keepApart => 'لا يسحب أحدهما الآخر';

  @override
  String get firstPerson => 'الشخص الأول';

  @override
  String get secondPerson => 'الشخص الثاني';

  @override
  String ruleLabel(String first, String second) {
    return '$first و$second';
  }

  @override
  String get ruleDescription => 'لن يسحب أحدهما الآخر';

  @override
  String get ruleSamePerson => 'اختر شخصين مختلفين.';

  @override
  String get ruleExists => 'هذه القاعدة موجودة بالفعل.';

  @override
  String get avoidPrevious => 'لا تكرر مطابقات المرة السابقة';

  @override
  String get noValidMatch =>
      'لا توجد قرعة تناسب هذه القواعد. احذف قاعدة أو أضف أشخاصًا.';

  @override
  String get wishOptional => 'أفكار للهدايا (اختياري)';

  @override
  String get giftIdeas => 'أفكار للهدايا';

  @override
  String shareWishLine(String wish) {
    return 'أفكار للهدايا: $wish';
  }

  @override
  String get drawAgain => 'اسحب مجددًا مع هذه المجموعة';

  @override
  String get moreOptions => 'خيارات أخرى';

  @override
  String get bulkAdd => 'إضافة عدة أشخاص';

  @override
  String get bulkAddLabel => 'الأسماء، شخص في كل سطر';

  @override
  String get bulkAddHint =>
      'يمكنك إضافة بريد إلكتروني بعد فاصلة: سارة علي، sara@mail.com';

  @override
  String bulkAddPreview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ستتم إضافة $count شخص جديد',
      many: 'ستتم إضافة $count شخصًا جديدًا',
      few: 'ستتم إضافة $count أشخاص جدد',
      two: 'ستتم إضافة شخصين جديدين',
      one: 'ستتم إضافة شخص جديد',
      zero: 'لا توجد أسماء جديدة بعد',
    );
    return '$_temp0';
  }

  @override
  String bulkAddSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count اسم موجود بالفعل في القائمة',
      many: '$count اسمًا موجودًا بالفعل في القائمة',
      few: '$count أسماء موجودة بالفعل في القائمة',
      two: 'اسمان موجودان بالفعل في القائمة',
      one: 'اسم واحد موجود بالفعل في القائمة',
    );
    return '$_temp0';
  }

  @override
  String get bulkAddEmpty => 'أدخل اسمًا جديدًا واحدًا على الأقل.';

  @override
  String get undo => 'تراجع';

  @override
  String removedItem(String name) {
    return 'تم حذف $name';
  }

  @override
  String get shareAsMessage => 'مشاركة كرسالة';

  @override
  String get shareAsCard => 'مشاركة كبطاقة';

  @override
  String get resultCard => 'بطاقة النتيجة';

  @override
  String get yourCode => 'رمزك الشخصي';

  @override
  String get cardCodeHint => 'افتح Noel Raffle وأدخله في قسم \"اعرض نتيجتي\".';

  @override
  String get drawnWith => 'سُحبت عبر Noel Raffle';
}
