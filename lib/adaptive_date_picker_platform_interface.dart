import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'adaptive_date_picker_method_channel.dart';

abstract class AdaptiveDatePickerPlatform extends PlatformInterface {
  /// Constructs a AdaptiveDatePickerPlatform.
  AdaptiveDatePickerPlatform() : super(token: _token);

  static final Object _token = Object();

  static AdaptiveDatePickerPlatform _instance = MethodChannelAdaptiveDatePicker();

  /// The default instance of [AdaptiveDatePickerPlatform] to use.
  ///
  /// Defaults to [MethodChannelAdaptiveDatePicker].
  static AdaptiveDatePickerPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AdaptiveDatePickerPlatform] when
  /// they register themselves.
  static set instance(AdaptiveDatePickerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
