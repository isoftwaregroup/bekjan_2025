import 'package:flutter/cupertino.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../variables/util_variables.dart';

_ThemeApp? _appTheme;
_ThemeApp get theme {
  _appTheme ??= _ThemeApp();
  return _appTheme!;
}

void updateTheme() {
  _appTheme = _ThemeApp();
  //updateNav();
}

class _ThemeApp {
  Color background = isDark ? const Color(0xFF29232E) : const Color(0xFFF5F5F5);
  Color text = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  Color secondary = isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  Color mapbg = isDark ? const Color(0xFF242f3e) : const Color(0xFFF7F8F9);
  Color grey = isDark ? const Color(0xFFABA5B0) : const Color(0xFF7D7B77);
  Color numBackground =
      isDark ? const Color(0xFF29232E) : const Color(0xFFF9F9F9);
  Color dragDown = isDark ? const Color(0xF0444444) : const Color(0xFFF8F9F8);
  Color line = isDark ? const Color(0xFF655F6A) : const Color(0xFFE4E5E4);
  Color cardBackground =
      isDark ? const Color(0xFF332D38) : const Color(0xFFFFFFFF);
  Color card = isDark ? const Color(0xFF3D3742) : const Color(0xFFFFFFFF);
  Color green = isDark ? const Color(0xFF12FF2A) : const Color(0xFF059B14);
  Color yellow = isDark ? const Color(0xFFFFB200) : const Color(0xFFFDDB00);
  Color greyBG = isDark ? const Color(0xFF655F6A) : const Color(0xFFF8F9F8);

  Color orange = const Color(0xFFFF9900);
  Color greyYellow = const Color(0xFFC18905);
  Color mainBlue = const Color(0xFF014EA8);
  Color blue = const Color(0xFF407BFF);
  Color lightRed = const Color(0xFFFF7272);
  Color red = const Color(0xFFFF2E00);
  Color container = const Color(0xFF303130);

  String fontFamily = "IBMPlexSans";

  TextStyle textStyle = TextStyle(
    color: isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000),
    fontFamily: "IBMPlexSans",
    decoration: TextDecoration.none,
    overflow: TextOverflow.ellipsis,
  );

  MaskTextInputFormatter numberMaskFormatter = MaskTextInputFormatter(
    mask: ' ## ### ## ##',
    filter: {"#": RegExp(r'\d')},
    type: MaskAutoCompletionType.eager,
  );

  BoxDecoration cardDecor = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: isDark ? const Color(0xFF655F6A) : const Color(0xFFE4E5E4),
      width: 1,
    ),
    color: isDark ? const Color(0xFF332D38) : const Color(0xFFFFFFFF),
  );

  BoxDecoration get redDecor => cardDecor.copyWith(
        border: Border.all(
          color: const Color(0xFFFF2E00),
          width: 1,
        ),
      );

  BoxDecoration greyDecor = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: isDark ? const Color(0xFF29232E) : const Color(0xFFF9F9F9),
    border: Border.all(
      width: 1,
      color: isDark ? const Color(0xFF655F6A) : const Color(0xFFEBE9E6),
    ),
  );

  BoxDecoration get selectedGreyDecor => greyDecor.copyWith(
        border: Border.all(
          width: 1,
          color: yellow,
        ),
      );

  ColorFilter colorFilter = ColorFilter.mode(
    isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000),
    BlendMode.srcIn,
  );

  ColorFilter greyFilter = ColorFilter.mode(
    isDark ? const Color(0xFFABA5B0) : const Color(0xFF7D7B77),
    BlendMode.srcIn,
  );
}
