import 'package:danji_client/constants/colors.dart';
import 'package:danji_client/services/product_service.dart';
import 'package:danji_client/widgets/app_button.dart';
import 'package:danji_client/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomerMarketdetailScreen extends ConsumerStatefulWidget {
  final int marketId;
  final String marketName;
  final String marketAddress;

  const CustomerMarketdetailScreen({
    super.key,
    required this.marketId,
    required this.marketName,
    required this.marketAddress,
  });

  @override
  ConsumerState<CustomerMarketdetailScreen> createState() =>
      _CustomerMarketdetailScreenState();
}

class _CustomerMarketdetailScreenState
    extends ConsumerState<CustomerMarketdetailScreen> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  Future<void> _loadProducts() async {
    try {
      final result = await ProductService().getProducts(widget.marketId);
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const AppHeader(blueTitle: '가게 ', blackTitle: '둘러보기'),
                  _buildMarketInfo(),
                  const SizedBox(height: 16),
                  Expanded(child: _buildProductList()),
                  _buildBottomButton(),
                ],
              ),
      ),
    );
  }

  Widget _buildMarketInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFD9D9D9))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.marketName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.marketAddress,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF5B5B5B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          '아직 상품이 없습니다.',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.grayLight,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final min = product['minQuantity'] ?? 0;
        final max = product['maxQuantity'];

        final controller = TextEditingController(text: '0');
        String? errorText;

        return StatefulBuilder(
          builder: (context, setLocalState) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
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
                          '${product['price'].toInt()}원',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF5B5B5B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (product['minQuantity'] != null)
                          Text(
                            '최소 수량 $min',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF5B5B5B),
                            ),
                          ),
                        if (product['maxQuantity'] != null)
                          Text(
                            '최대 수량 $max',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF5B5B5B),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 36,
                        child: TextFormField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 6,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: errorText != null
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: errorText != null
                                    ? Colors.red
                                    : AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            final input = int.tryParse(value);
                            setLocalState(() {
                              if (input == null) {
                                errorText = '숫자만 입력해주세요';
                              } else if (input != 0 && input < min) {
                                errorText = '$min 개 이상부터 주문 가능합니다';
                              } else if (max != null && input > max) {
                                errorText = '$max 개 이하까지 주문 가능합니다';
                              } else {
                                errorText = null;
                              }
                            });
                          },
                        ),
                      ),
                      if (errorText != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  errorText!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomButton() {
    return Container(
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
              await _loadProducts();
            }
          },
          backgroundColor: AppColors.primary,
          textColor: AppColors.background,
        ),
      ),
    );
  }
}
