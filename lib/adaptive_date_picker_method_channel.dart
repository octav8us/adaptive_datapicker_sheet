import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'adaptive_date_picker_platform_interface.dart';

/// An implementation of [AdaptiveDatePickerPlatform] that uses method channels.
class MethodChannelAdaptiveDatePicker extends AdaptiveDatePickerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('adaptive_date_picker');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
