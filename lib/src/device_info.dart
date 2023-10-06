/// [DeviceInfo] is the configuration for a serial service (real-time data)
class DeviceInfo {
  static const String deviceName = 'ATMOTUBE';

  /// UUID of the GATT service.
  static const String deviceService = "DB450001-8E9A-4818-ADD7-6ED94A328AB4";

  static const String statusCharacteristic =
      'db450004-8e9a-4818-add7-6ed94a328ab4';

  static const String bmeCharacteristic =
      'db450003-8e9a-4818-add7-6ed94a328ab4';

  static const String pmCharacteristic = 'db450005-8e9a-4818-add7-6ed94a328ab4';

  static const String vocCharacteristics =
      'db450002-8e9a-4818-add7-6ed94a328ab4';
}
