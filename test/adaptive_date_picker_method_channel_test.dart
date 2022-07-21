import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adaptive_date_picker/adaptive_date_picker_method_channel.dart';

void main() {
  MethodChannelAdaptiveDatePicker platform = MethodChannelAdaptiveDatePicker();
  const MethodChannel channel = MethodChannel('adaptive_date_picker');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
