import 'package:flutter/services.dart';

/// إشارات صوتية ولمسية بسيطة عند التنقل في مسار التشخيص (قسم → مشكلة → حل).
class DiagnosticSound {
  DiagnosticSound._();

  /// عند فتح قائمة مشكلات داخل قسم (مثل «الأصوات»).
  static void sectionOpened() {
    HapticFeedback.selectionClick();
    SystemSound.play(SystemSoundType.click);
  }

  /// عند اختيار مشكلة محددة (قبل شاشة الحل).
  static void problemSelected() {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.alert);
  }

  /// عند عرض شاشة الحل.
  static void solutionShown() {
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.click);
  }
}
