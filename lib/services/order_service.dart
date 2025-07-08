

import 'package:danji_client/utils/dio_client.dart';

class OrderService {
  Future<List<Map<String, dynamic>>> getOrders() async {
    final response = await dio.get('/api/merchants/me/orders');
    final body = response.data;

    if (body['success'] != true)  {
      throw Exception(body['message'] ?? '주문 내역 조회 실패');
    }

    final List<dynamic> rawList = body['data'];
    return rawList.cast<Map<String, dynamic>>();
  }
}