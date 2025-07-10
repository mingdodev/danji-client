import 'package:danji_client/constants/colors.dart';
import 'package:danji_client/services/order_service.dart';
import 'package:danji_client/widgets/app_button.dart';
import 'package:danji_client/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:go_router/go_router.dart';

class CustomerOrderScreen extends StatefulWidget {
  final Map<String, dynamic>? extra;

  const CustomerOrderScreen({super.key, this.extra});

  @override
  State<CustomerOrderScreen> createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  bool isDeliveryChecked = false;
  final deliveryController = TextEditingController();
  DateTime? selectedDateTime;

  List<Map<String, dynamic>> selectedProducts = [];
  String marketName = '';
  String marketAddress = '';

  @override
  void initState() {
    super.initState();

    final args = widget.extra;
    if (args != null) {
      marketName = args['marketName'] ?? '';
      marketAddress = args['marketAddress'] ?? '';
      selectedProducts = List<Map<String, dynamic>>.from(
        args['products'] ?? [],
      );
    }
  }

  void _pickDateTime() {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (date) {
        setState(() {
          selectedDateTime = date;
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.ko,
    );
  }

  int _calculateTotalPrice() {
    return selectedProducts.fold(0, (sum, item) {
      final price = (item['price'] as num).toInt();
      final quantity = item['quantity'] as int;
      return sum + price * quantity;
    });
  }

  @override
  void dispose() {
    deliveryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(blueTitle: '주문 ', blackTitle: '하기'),
            _buildMarketInfo(),
            Expanded(
              child: ListView(
                children: [
                  _buildSection(
                    child: Column(
                      children: selectedProducts
                          .map((product) => _buildProductInfo(product))
                          .toList(),
                    ),
                  ),
                  _buildSection(child: _buildTotalPrice()),
                  _buildSection(child: _buildDateSelector()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_buildDeliverySection()],
                  ),
                  _buildBottomButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFD9D9D9))),
      ),
      child: child,
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
            marketName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            marketAddress,
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

  Widget _buildProductInfo(Map<String, dynamic> product) {
    final name = product['name'];
    final price = product['price'].toInt();
    final quantity = product['quantity'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('가격: $price', style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 20),
              Text('수량: $quantity', style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPrice() {
    final total = _calculateTotalPrice();
    return Text(
      '총 ${total.toString()} 원',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDateSelector() {
    return Row(
      children: [
        const Text(
          '날짜 선택',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: InkWell(
            onTap: _pickDateTime,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                selectedDateTime != null
                    ? '${selectedDateTime!.year}/${selectedDateTime!.month.toString().padLeft(2, '0')}/${selectedDateTime!.day.toString().padLeft(2, '0')}  ${selectedDateTime!.hour.toString().padLeft(2, '0')}:${selectedDateTime!.minute.toString().padLeft(2, '0')}'
                    : '날짜를 선택하세요',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliverySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                activeColor: AppColors.primary,
                value: isDeliveryChecked,
                onChanged: (value) {
                  setState(() {
                    isDeliveryChecked = value!;
                    if (!isDeliveryChecked) {
                      deliveryController.text = '';
                    }
                  });
                },
              ),
              const Text('배달해주세요!', style: TextStyle(fontSize: 16)),
            ],
          ),
          if (isDeliveryChecked)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                controller: deliveryController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '배송지를 입력해주세요',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24, top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 57,
        child: AppButton(
          text: '주문 요청하기',
          onPressed: () async {
            if (selectedDateTime == null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('날짜를 선택해주세요')));
              return;
            }
            try {
              final orderService = OrderService();
              await orderService.postOrder(
                marketId: widget.extra?['marketId'] as int,
                date: selectedDateTime ?? DateTime.now(),
                deliveryAddress: isDeliveryChecked
                    ? deliveryController.text
                    : null,
                orderItems: selectedProducts
                    .map(
                      (product) => {
                        "name": product['name'],
                        "price": product['price'],
                        "quantity": product['quantity'],
                      },
                    )
                    .toList(),
              );
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('주문 요청이 완료되었습니다')));

              await Future.delayed(const Duration(milliseconds: 500));
              context.push('/home/customer');
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('주문 실패: ${e.toString()}')));
            }
          },
          backgroundColor: AppColors.primary,
          textColor: AppColors.background,
        ),
      ),
    );
  }
}
