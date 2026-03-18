import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project_collaboration_app/domain/models/user.dart';

class AvatarGenerator {
  static int _generateAvatarColor() {
    final random = Random();

    final hue = random.nextDouble() * 360;
    final saturation = 0.6 + random.nextDouble() * 0.3;
    final value = 0.7 + random.nextDouble() * 0.2;

    final color = HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
    return color.value;
  }

  static int _getTextColor(int backgroundColorValue) {
    final backgroundColor = Color(backgroundColorValue);

    final isLight = backgroundColor.computeLuminance() > 0.5;

    return isLight ? Colors.black.value : Colors.white.value;
  }

  static String _pickInitialsFromUsername(String username) {
    final random = Random();
    String randomChar = username[random.nextInt(username.length - 1) + 1];
    return username[0] + randomChar;
  }

  static Avatar generateDefaultAvatar(String username) {
    final backgroundColor = _generateAvatarColor();
    final textColor = _getTextColor(backgroundColor);
    final initials = _pickInitialsFromUsername(username);

    return Avatar(
      backgroundColor: backgroundColor,
      textColor: textColor,
      initials: initials,
    );
  }
}
