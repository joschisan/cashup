import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class NotificationUtils {
  static const _defaultDuration = Duration(milliseconds: 1500);

  static void _showNotification(
    String message,
    IconData icon,
    Color iconColor,
    Duration duration,
  ) {
    showOverlayNotification(
      (context) => Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Color.lerp(
              Theme.of(context).colorScheme.surface,
              iconColor,
              0.15,
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                Icon(icon, size: 32, color: iconColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      duration: duration,
      position: NotificationPosition.top,
    );
  }

  static void showError(String message) {
    _showNotification(message, Icons.error, Colors.red, _defaultDuration);
  }

  static void showSuccess(String message) {
    _showNotification(
      message,
      Icons.check_circle,
      Colors.green,
      _defaultDuration,
    );
  }
}
