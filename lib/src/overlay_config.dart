/// Placement of overlay within the screen.
enum OverlayAlignment {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight
}

/// Type of dragging behavior for the overlay.
enum PositionGravity {
  /// The `PositionGravity.none` will allow the overlay to postioned anywhere on the screen.
  none,

  /// The `PositionGravity.right` will allow the overlay to stick on the right side of the screen.
  right,

  /// The `PositionGravity.left` will allow the overlay to stick on the left side of the screen.
  left,

  /// The `PositionGravity.auto` will allow the overlay to stick either on the left or right side of the screen depending on the overlay position.
  auto,
}

enum OverlayFlag {
  /// Window flag: this window can never receive touch events.
  /// Usefull if you want to display click-through overlay
  @Deprecated('Use "clickThrough" instead.')
  flagNotTouchable,

  /// Window flag: this window won't ever get key input focus
  /// so the user can not send key or other button events to it.
  @Deprecated('Use "defaultFlag" instead.')
  flagNotFocusable,

  /// Window flag: allow any pointer events outside of the window to be sent to the windows behind it.
  /// Usefull when you want to use fields that show keyboards.
  @Deprecated('Use "focusPointer" instead.')
  flagNotTouchModal,

  /// Window flag: this window can never receive touch events.
  /// Usefull if you want to display click-through overlay
  clickThrough,

  /// Window flag: this window won't ever get key input focus
  /// so the user can not send key or other button events to it.
  defaultFlag,

  /// Window flag: allow any pointer events outside of the window to be sent to the windows behind it.
  /// Usefull when you want to use fields that show keyboards.
  focusPointer,
}

/// The level of detail displayed in notifications on the lock screen.
enum NotificationVisibility {
  /// Show this notification in its entirety on all lockscreens.
  visibilityPublic,

  /// Do not reveal any part of this notification on a secure lockscreen.
  visibilitySecret,

  /// Show this notification on all lockscreens, but conceal sensitive or private information on secure lockscreens.
  visibilityPrivate
}

class WindowSize {
  WindowSize._();

  /// default size when the overlay match the parent size
  /// basically it will take the full screen width and height
  static const int matchParent = -1;

  /// make the overlay cover the fullscreen
  /// even the statusbar and the navigationbar
  static const int fullCover = -1999;
}

/// Class that matches closely to native Android WindowInsets.Type. 
/// You can select any combination of insets to be applied to the overlay window.
class WindowInsetsType {
  static const int _first = 1 << 0;
  static const int statusBars = _first;
  static const int navigationBars = 1 << 1;
  static const int captionBar = 1 << 2;
  static const int ime = 1 << 3;
  static const int systemGestures = 1 << 4;
  static const int mandatorySystemGestures = 1 << 5;
  static const int tappableElement = 1 << 6;
  static const int displayCutout = 1 << 7;
  static const int windowDecor = 1 << 8;
  static const int systemOverlays = 1 << 9;
  static const int size = 10;
  static const int defaultVisible = ~ime;

  // Private constructor to prevent instantiation
  WindowInsetsType._();
  static String typeToString(int types) {
    final result = StringBuffer();
    if ((types & statusBars) != 0) {
      result.write('statusBars ');
    }
    if ((types & navigationBars) != 0) {
      result.write('navigationBars ');
    }
    if ((types & captionBar) != 0) {
      result.write('captionBar ');
    }
    if ((types & ime) != 0) {
      result.write('ime ');
    }
    if ((types & systemGestures) != 0) {
      result.write('systemGestures ');
    }
    if ((types & mandatorySystemGestures) != 0) {
      result.write('mandatorySystemGestures ');
    }
    if ((types & tappableElement) != 0) {
      result.write('tappableElement ');
    }
    if ((types & displayCutout) != 0) {
      result.write('displayCutout ');
    }
    if ((types & windowDecor) != 0) {
      result.write('windowDecor ');
    }
    if ((types & systemOverlays) != 0) {
      result.write('systemOverlays ');
    }
    if (result.isNotEmpty) {
      // Remove trailing space
      return result.toString().trimRight();
    }
    return result.toString();
  }

  /// Returns all system bars. Includes [statusBars], [captionBar] as well as
  /// [navigationBars], [systemOverlays], but not [ime].
  static int getSystemBars() {
    return statusBars | navigationBars | captionBar | systemOverlays;
  }

  /// Returns all inset types combined.
  static int all() {
    return 0xFFFFFFFF;
  }
}
