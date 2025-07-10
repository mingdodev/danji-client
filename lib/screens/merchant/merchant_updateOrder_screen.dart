import 'package:danji_client/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:danji_client/widgets/app_button.dart';
import 'package:danji_client/widgets/app_header.dart';
import 'package:go_router/go_router.dart';

class MerchantUpdateOrderScreen extends StatefulWidget {
  final int orderId;
  final List<Map<String, dynamic>> orderItems;

  const MerchantUpdateOrderScreen({
    super.key,
    required this.orderId,
    required this.orderItems,
  });

  @override
  State<MerchantUpdateOrderScreen> createState() =>
      _MerchantUpdateOrderScreenState();
}

class _MerchantUpdateOrderScreenState extends State<MerchantUpdateOrderScreen> {
  late List<TextEditingController> priceControllers;
  late List<TextEditingController> quantityControllers;

  @override
  void initState() {
    super.initState();

    priceControllers = widget.orderItems
        .map(
          (item) =>
              TextEditingController(text: item['price'].toInt().toString()),
        )
        .toList();
    quantityControllers = widget.orderItems
        .map(
          (item) =>
              TextEditingController(text: item['quantity'].toInt().toString()),
        )
        .toList();
  }

  @override
  void dispose() {
    for (final controller in [...priceControllers, ...quantityControllers]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(blueTitle: '주문 수정', blackTitle: '하기'),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: widget.orderItems.length,
                itemBuilder: (context, i) {
                  final item = widget.orderItems[i];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF535353),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '개당 가격 *',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF424242),
                            letterSpacing: 0.51,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: priceControllers[i],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '가격을 입력하세요',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF1E88E5),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF1E88E5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '수량 *',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF424242),
                            letterSpacing: 0.51,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: quantityControllers[i],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '수량을 입력하세요',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF1E88E5),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF1E88E5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, i) => const Divider(
                  color: Color(0xFFD9D9D9),
                  thickness: 1,
                  height: 48,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: AppButton(
                text: '주문 수정 완료',
                onPressed: () async {
                  final updatedItems = List.generate(widget.orderItems.length, (
                    i,
                  ) {
                    return {
                      'id': widget.orderItems[i]['id'],
                      'name': widget.orderItems[i]['name'],
                      'price': int.parse(priceControllers[i].text),
                      'quantity': int.parse(quantityControllers[i].text),
                    };
                  });

                  try {
                    await OrderService().updateOrder(
                      orderId: widget.orderId,
                      orderItems: updatedItems,
                    );

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('주문 수정이 완료되었습니다.')),
                      );
                      context.pop(true);
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('주문 수정에 실패했습니다.')),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}