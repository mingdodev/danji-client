import 'package:danji_client/services/product_service.dart';
import 'package:danji_client/widgets/app_button.dart';
import 'package:danji_client/widgets/app_header.dart';
import 'package:flutter/material.dart';

class MerchantAddProductScreen extends StatefulWidget {
  const MerchantAddProductScreen({super.key});

  @override
  State<MerchantAddProductScreen> createState() => _MerchantAddProductScreenState();
}

class _MerchantAddProductScreenState extends State<MerchantAddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _minQuantityController = TextEditingController();
  final _maxQuantityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _minQuantityController.dispose();
    _maxQuantityController.dispose();
    super.dispose();
  }

  void _submitProduct() async {
    final name = _nameController.text.trim();
    final priceText = _priceController.text.trim();
    final minText = _minQuantityController.text.trim();
    final maxText = _maxQuantityController.text.trim();

    if (name.isEmpty || priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('상품명과 가격은 필수입니다.')),
      );
      return;
    }

    final price = int.tryParse(priceText);
    final minQuantity = minText.isEmpty ? null : int.tryParse(minText);
    final maxQuantity = maxText.isEmpty ? null : int.tryParse(maxText);

    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('가격은 숫자여야 합니다.')),
      );
      return;
    }

    try {
      await ProductService().addProduct(
        name: name,
        price: price,
        minQuantity: minQuantity,
        maxQuantity: maxQuantity,
      );
      if (!context.mounted) return;

      // ✅ 성공 시 true를 반환하며 pop
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('상품 추가 실패: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(blueTitle: '상품 ', blackTitle: '추가하기'),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('상품명 *'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  const Text('가격 *'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  const Text('주문 가능 수량'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _minQuantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: '최소',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _maxQuantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: '최대',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 57,
                    child: AppButton(
                      text: '상품 추가하기',
                      onPressed: _submitProduct,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
