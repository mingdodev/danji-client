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

  Future<void> addProduct({
    required String name,
    required int price,
    int? minQuantity,
    int? maxQuantity,
  }) async {
    final response = await dio.post(
      '/api/products',
      data: {
        'name': name,
        'price': price,
        'minQuantity': minQuantity,
        'maxQuantity': maxQuantity,
      },
    );

    final body = response.data;
    if (body['success'] != true) {
      throw Exception(body['message'] ?? '상품 추가 실패');
    }
  }

  Future<void> deleteProduct(int productId) async {
    final response = await dio.delete('/api/products/$productId');

    final body = response.data;
    if (body['success'] != true) {
      throw Exception(body['message'] ?? '상품 삭제 실패');
    }
  }
}
