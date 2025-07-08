import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeMerchantScreen extends ConsumerWidget {
  const HomeMerchantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(height: 80),
            const Text(
              '환영합니다 사장님!\n단체 주문 지키미입니다',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                height: 1.31,
                letterSpacing: 0.96,
                color: Color(0xFF424242),
              ),
            ),
            const SizedBox(height: 40),

            // 상품 관리하기 카드
            GestureDetector(
              onTap: () async {
                context.push('/home/merchant/productList');
              },
              child: Container(
                width: double.infinity,
                height: 167,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      left: 27,
                      top: 36,
                      child: Text(
                        '상품 관리하기',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF535353),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 27,
                      top: 84,
                      child: Text(
                        '판매할 상품을\n등록하고 관리해요',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5B5B5B),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      top: 32,
                      child: Image.asset(
                        'assets/images/menu-merchant.png',
                        width: 103,
                        height: 103,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 주문 내역 확인하기 카드
            GestureDetector(
              onTap: () => context.push('/home/merchant/orderList'),
              child: Container(
                width: double.infinity,
                height: 167,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      left: 27,
                      top: 36,
                      child: Text(
                        '주문 내역 확인하기',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF535353),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 27,
                      top: 84,
                      child: Text(
                        '주문 내역을 확인하고\n고객과 소통해요',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5B5B5B),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      top: 50,
                      child: Image.asset(
                        'assets/images/menu-chat.png',
                        width: 103,
                        height: 103,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
