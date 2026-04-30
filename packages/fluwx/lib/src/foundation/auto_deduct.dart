part of 'arguments.dart';

/// Auto Deduct
class AutoDeduct with _Argument {
  final Map<String, String> queryInfo;
  final int businessType;
  final Map<String, dynamic> _detailData;

  bool get isV2 => _detailData.isEmpty;

  AutoDeduct.detail({
    required String appId,
    required String mchId,
    required String planId,
    required String contractCode,
    required String requestSerial,
    required String contractDisplayAccount,
    required String notifyUrl,
    required String version,
    required String sign,
    required String timestamp,
    String returnApp = '3',
    this.businessType = 12,
  })  : queryInfo = {},
        _detailData = {
          'appid': appId,
          'mch_id': mchId,
          'plan_id': planId,
          'contract_code': contractCode,
          'request_serial': requestSerial,
          'contract_display_account': contractDisplayAccount,
          'notify_url': notifyUrl,
          'version': version,
          'sign': sign,
          'timestamp': timestamp,
          'return_app': returnApp,
          'businessType': businessType
        };

  AutoDeduct.custom({required this.queryInfo, this.businessType = 12})
      : _detailData = {};

  @override
  Map<String, dynamic> get arguments => isV2
      ? {'queryInfo': queryInfo, 'businessType': businessType}
      : _detailData;
}
