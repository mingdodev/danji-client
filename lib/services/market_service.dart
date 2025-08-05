import 'package:danji_client/utils/dio_client.dart';

class MarketService {
  Future<Map<String, dynamic>> getMarkets(String keyword, int page) async {
    final response = await dio.get(
      '/api/markets',
      queryParameters: {'keyword': keyword, 'page': page, 'size': 10},
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw Exception('Failed to load markets');
    }
  }
}
