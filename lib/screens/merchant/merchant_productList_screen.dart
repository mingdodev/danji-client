import 'package:danji_client/constants/colors.dart';
import 'package:danji_client/providers/merchant_provider.dart';
import 'package:danji_client/widgets/app_button.dart';
import 'package:danji_client/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MerchantProductListScreen extends ConsumerWidget {
  final List<Map<String, dynamic>> products;

  const MerchantProductListScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchant = ref.watch(merchantProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(blueTitle: '상품 ', blackTitle: '관리하기'),

            // 가게 정보 영역
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFD9D9D9))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    merchant.marketName ?? '가게명 없음',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF424242),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    merchant.marketAddress ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF5B5B5B),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: products.isEmpty
                  ? const Center(
                      child: Text(
                        '아직 상품이 없습니다.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.grayLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF535353),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${product['price']}원',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF5B5B5B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '최소 수량 ${product['minQuantity']}, 최대 수량 ${product['maxQuantity']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF5B5B5B),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            // 하단 버튼
            Container(
              margin: const EdgeInsets.only(bottom: 24, top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 57,
                child: AppButton(
                  text: '상품 추가하기',
                  onPressed: () {},
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.background,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
