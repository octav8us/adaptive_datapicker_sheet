import 'package:flutter_test/flutter_test.dart';

import 'package:adaptive_date_picker/adaptive_date_picker_platform_interface.dart';
import 'package:adaptive_date_picker/adaptive_date_picker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAdaptiveDatePickerPlatform 
    with MockPlatformInterfaceMixin
    implements AdaptiveDatePickerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AdaptiveDatePickerPlatform initialPlatform = AdaptiveDatePickerPlatform.instance;

  test('$MethodChannelAdaptiveDatePicker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAdaptiveDatePicker>());
  });

  test('getPlatformVersion', () async {
    // Picker adaptiveDatePickerPlugin = Picker(adapter: );
    MockAdaptiveDatePickerPlatform fakePlatform = MockAdaptiveDatePickerPlatform();
    AdaptiveDatePickerPlatform.instance = fakePlatform;
  
    // expect(await adaptiveDatePickerPlugin.getPlatformVersion(), '42');
  });
}
