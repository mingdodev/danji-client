import 'package:danji_client/constants/colors.dart';
import 'package:danji_client/services/order_service.dart';
import 'package:danji_client/widgets/app_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MerchantOrderListScreen extends StatefulWidget {
  const MerchantOrderListScreen({super.key});

  @override
  State<MerchantOrderListScreen> createState() =>
      _MerchantOrderListScreenState();
}

class _MerchantOrderListScreenState extends State<MerchantOrderListScreen> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final result = await OrderService().getMerchantOrders();
      setState(() {
        orders = result;
        isLoading = false;
      });
    } catch (e) {
      print('주문 조회 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(blueTitle: '주문 내역 ', blackTitle: '확인하기'),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : orders.isEmpty
                  ? const Center(
                      child: Text(
                        '아직 주문 내역이 없습니다.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF909090),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final customer = order['customer'];
                        final orderItems = List<Map<String, dynamic>>.from(
                          order['orderItems'],
                        );

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer['name'],
                                style: const TextStyle(
                                  color: Color(0xFF535353),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.20,
                                ),
                              ),
                              const SizedBox(height: 16),
                              for (var item in orderItems)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    '${item['name']} x ${item['quantity']}',
                                    style: const TextStyle(
                                      color: Color(0xFF909090),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 1.58,
                                      letterSpacing: 0.48,
                                    ),
                                  ),
                                ),
                              Text(
                                '수령 일자: ${DateTime.parse(order['date']).toLocal().toString().substring(0, 16).replaceFirst('T', ' ')}',
                                style: const TextStyle(
                                  color: Color(0xFF909090),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 1.58,
                                  letterSpacing: 0.48,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (order['deliveryAddress'] != null &&
                                  order['deliveryAddress']
                                      .toString()
                                      .trim()
                                      .isNotEmpty)
                                Text(
                                  '배달 주소: ${order['deliveryAddress']}',
                                  style: const TextStyle(
                                    color: Color(0xFF909090),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 1.58,
                                    letterSpacing: 0.48,
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                '${order['totalPrice'].toInt()} 원',
                                style: const TextStyle(
                                  color: Color(0xFF909090),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  height: 1.58,
                                  letterSpacing: 0.48,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E88E5),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Center(
                                  child: Text(
                                    '1:1 채팅하기',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      height: 1.27,
                                      letterSpacing: 0.60,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (order['orderStatus'] == 'PENDING')
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          await OrderService()
                                              .updateOrderStatus(
                                                orderId: order['orderId'],
                                                status: 'ACCEPTED',
                                              );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text('주문 수락이 완료되었습니다.'),
                                            ),
                                          );
                                          await _fetchOrders();
                                        },
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF64B5F6),
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              '주문 수락하기',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                height: 1.27,
                                                letterSpacing: 0.60,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          await OrderService()
                                              .updateOrderStatus(
                                                orderId: order['orderId'],
                                                status: 'REJECTED',
                                              );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text('주문 거절이 완료되었습니다.'),
                                            ),
                                          );
                                          await _fetchOrders();
                                        },
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: AppColors.background,
                                            border: Border.all(
                                              color: const Color(0xFF7E7E7E),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              '주문 거절하기',
                                              style: TextStyle(
                                                color: Color(0xFF7E7E7E),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                height: 1.27,
                                                letterSpacing: 0.60,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Container(
                                  width: double.infinity,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    border: Border.all(
                                      color: Color(0xFF7E7E7E),
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Text(
                                      getOrderStatusText(order['orderStatus']),
                                      style: const TextStyle(
                                        color: Color(0xFF535353),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        height: 1.27,
                                        letterSpacing: 0.60,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  context.push(
                                    '/home/merchant/orderList/update',
                                    extra: {
                                      'orderId': order['orderId'],
                                      'orderItems': orderItems,
                                    }).then((result) {
                                      if (result == true) {
                                        _fetchOrders();
                                      }
                                    });
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD9D9D9),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '주문 수정하기',
                                      style: TextStyle(
                                        color: Color(0xFF535353),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        height: 1.27,
                                        letterSpacing: 0.60,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

String getOrderStatusText(String status) {
  switch (status) {
    case 'REJECTED':
      return '주문 거절 완료';
    case 'ACCEPTED':
      return '주문 수락 완료';
    default:
      return '주문 상태 불러오기 실패';
  }
}
