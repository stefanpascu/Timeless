import 'dart:ui';

import '../pages/settings.dart';

class MyColors {
  bool? darkThemeStyles = false;
  Color primaryNormal = Color(0xff465FC2),
      primaryDarker = Color(0xff404E83),
      primaryDarkest = Color(0xff3D486E),
      lightGray = Color(0xffc4c4c4),
      darkThemeTextNormal = Color(0xffEEF0F0),
      darkGray = Color(0xff3e3e3e),
      darkThemeDivider = Color(0xff717171),
      lightThemeDivider = Color(0xffb8b8b8),
      highlightedFilterText = Color(0xffF6F7F7),
      darkThemeOverBackground = Color(0xff4B5052),
      darkThemeBackgroundNormal = Color(0xff26292C),
      accentNormal = Color(0xffE18851),
      repetitiveBlue = Color(0xff667ACC),
      dueToRed = Color(0xffCC6E66),
      appointmentGreen = Color(0xff66CC8F),
      publicYellow = Color(0xffFFCD68),
      privatePurple = Color(0xffBE92FF),
      primaryTitle = Color(0xffF6F7F7),
      textNormal = Color(0xffF6F7F7),
      divider = Color(0xffF6F7F7),
      backgroundNormal = Color(0xffF6F7F7),
      overBackground = Color(0xffF6F7F7);

    MyColors() {
      primaryTitle = (darkThemeStyles == false ? primaryDarkest : lightGray);
      textNormal = (darkThemeStyles == false ? Color(0xff26292C) : darkThemeTextNormal);
      divider = (darkThemeStyles == false ?  lightThemeDivider : darkThemeDivider);
      backgroundNormal = (darkThemeStyles == false ? Color(0xffF6F7F7) : darkThemeBackgroundNormal);
      overBackground = (darkThemeStyles == false ? Color(0xffFAFCFC) : darkThemeOverBackground);
      if (darkThemeStyles == null)
        darkThemeStyles = SettingsStatefulWidgetState().isDarkTheme;
    }

  void setDarkTheme(bool darkTheme) {
      darkThemeStyles = darkTheme;
      primaryTitle = (darkThemeStyles == false ? Color(0xff3D486E) : lightGray);
      textNormal = (darkThemeStyles == false ? Color(0xff26292C) : darkThemeTextNormal);
      divider = (darkThemeStyles == false ?  lightThemeDivider : darkThemeDivider);
      backgroundNormal = (darkThemeStyles == false ? Color(0xffF6F7F7) : darkThemeBackgroundNormal);
      overBackground = (darkThemeStyles == false ? Color(0xffFAFCFC) : darkThemeOverBackground);
  }

}