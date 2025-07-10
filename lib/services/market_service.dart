import 'package:danji_client/utils/dio_client.dart';

class MarketService {
  Future<List<dynamic>> getMarkets(String keyword) async {
  final response = await dio.get('/api/markets', queryParameters: {
    'keyword': keyword,
  });

  if (response.statusCode == 200 && response.data['success'] == true) {
    return response.data['data'];
  } else {
    throw Exception('Failed to load markets');
  }
}
}