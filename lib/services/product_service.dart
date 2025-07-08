import 'package:danji_client/utils/dio_client.dart';

class ProductService {
  Future<List<Map<String, dynamic>>> getProducts(int marketId) async {
    final response = await dio.get('/api/markets/$marketId/products');
    final body = response.data;

    if (body['success'] != true) {
      throw Exception(body['message'] ?? '상품 조회 실패');
    }

    final List<dynamic> rawList = body['data'];
    return rawList.cast<Map<String, dynamic>>();
  }
}