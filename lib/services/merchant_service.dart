import 'package:danji_client/utils/dio_client.dart';

class MerchantService {
  Future<Map<String, dynamic>> getMarketInfo(int userId) async {
    final response = await dio.get('/api/users/merchant/$userId/market');
    return response.data['data'];
  }
}