import 'package:danji_client/constants/colors.dart';
import 'package:danji_client/providers/merchant_provider.dart';
import 'package:danji_client/services/product_service.dart';
import 'package:danji_client/widgets/app_button.dart';
import 'package:danji_client/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';

class MerchantProductListScreen extends ConsumerStatefulWidget {
  const MerchantProductListScreen({super.key});

  @override
  ConsumerState<MerchantProductListScreen> createState() =>
      _MerchantProductListScreenState();
}

class _MerchantProductListScreenState
    extends ConsumerState<MerchantProductListScreen> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  Future<void> _loadProducts() async {
    final marketId = ref.read(merchantProvider).marketId;
    if (marketId == null) return;

    try {
      final result = await ProductService().getProducts(marketId);
      setState(() {
        products = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('상품 목록을 불러오는 데 실패했어요.')));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final merchant = ref.watch(merchantProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const AppHeader(blueTitle: '상품 ', blackTitle: '관리하기'),

                  // 가게 정보 영역
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFD9D9D9)),
                      ),
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
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                '${product['price'].toInt()}원',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFF5B5B5B),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              if (product['minQuantity'] !=
                                                      null ||
                                                  product['maxQuantity'] !=
                                                      null)
                                                Text(
                                                  [
                                                    if (product['minQuantity'] !=
                                                        null)
                                                      '최소 수량 ${product['minQuantity']}',
                                                    if (product['maxQuantity'] !=
                                                        null)
                                                      '최대 수량 ${product['maxQuantity']}',
                                                  ].join(', '),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF5B5B5B),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),

                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            color: AppColors.grayLightLight,
                                          ),
                                          onPressed: () async {
                                            final confirm =
                                                await showCupertinoDialog<bool>(
                                                  context: context,
                                                  builder: (context) =>
                                                      CupertinoAlertDialog(
                                                        title: const Text(
                                                          '상품 삭제',
                                                        ),
                                                        content: const Text(
                                                          '정말 삭제하시겠어요?',
                                                        ),
                                                        actions: [
                                                          CupertinoDialogAction(
                                                            isDestructiveAction:
                                                                true,
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                  context,
                                                                  true,
                                                                ),
                                                            child: const Text(
                                                              '삭제',
                                                            ),
                                                          ),
                                                          CupertinoDialogAction(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                  context,
                                                                  false,
                                                                ),
                                                            child: const Text(
                                                              '취소',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                );

                                            if (confirm != true) return;

                                            try {
                                              await ProductService()
                                                  .deleteProduct(product['id']);
                                              if (!context.mounted) return;
                                              await _loadProducts();
                                            } catch (e) {
                                              if (!context.mounted) return;
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    '상품 삭제에 실패했어요.',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
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
                        onPressed: () async {
                          final result = await context.push<bool>(
                            '/home/merchant/productList/add',
                          );
                          if (result == true) {
                            await _loadProducts(); // ✅ 상품 추가 후 다시 불러오기
                          }
                        },
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
