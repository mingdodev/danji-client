import 'dart:convert';

import 'package:danji_client/utils/dio_client.dart';

class OrderService {
  Future<List<Map<String, dynamic>>> getMerchantOrders() async {
    final response = await dio.get('/api/merchants/me/orders');
    final body = response.data;

    if (body['success'] != true) {
      throw Exception(body['message'] ?? '주문 내역 조회 실패');
    }

    final List<dynamic> rawList = body['data'];
    return rawList.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getCustomerOrders() async {
    final response = await dio.get('/api/customers/me/orders');
    final body = response.data;

    if (body['success'] != true) {
      throw Exception(body['message'] ?? '주문 내역 조회 실패');
    }

    final List<dynamic> rawList = body['data'];
    return rawList.cast<Map<String, dynamic>>();
  }

  Future<void> postOrder({
    required int marketId,
    required DateTime date,
    required String? deliveryAddress,
    required List<Map<String, dynamic>> orderItems,
  }) async {

    final body = jsonEncode({
      "marketId": marketId,
      "date": date.toIso8601String(),
      "deliveryAddress": deliveryAddress,
      "orderItems": orderItems,
    });

    final response = await dio.post('/api/orders', data: body);
    final resBody = response.data;

    if (resBody['success'] != true) {
      throw Exception(resBody['message'] ?? '주문 실패');
    }
  }

  Future<void> updateOrder({
    required int orderId,
    required List<Map<String, dynamic>> orderItems,
  }) async {

    final body = jsonEncode({
      "orderItems": orderItems,
    });
    final response = await dio.patch('/api/orders/$orderId', data: body);
    final resBody = response.data;

    if (resBody['success'] != true) {
      throw Exception(resBody['message'] ?? '주문 수정 실패');
    }
  }

  Future<void> updateOrderStatus({
    required int orderId,
    required String status,
  }) async {

    final body = jsonEncode({
      "status": status,
    });
    final response = await dio.patch('/api/orders/$orderId/status', data: body);
    final resBody = response.data;

    if (resBody['success'] != true) {
      throw Exception(resBody['message'] ?? '주문 상태 변경 실패');
    }
  }
}
