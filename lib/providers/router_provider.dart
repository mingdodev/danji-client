import 'package:danji_client/screens/chat_screen.dart';
import 'package:danji_client/screens/customer/customer_marketDetail_screen.dart';
import 'package:danji_client/screens/customer/customer_marketList_screen.dart';
import 'package:danji_client/screens/customer/customer_orderList_screen.dart';
import 'package:danji_client/screens/customer/customer_order_screen.dart';
import 'package:danji_client/screens/merchant/merchant_add_product_screen.dart';
import 'package:danji_client/screens/merchant/merchant_orderList_screen.dart';
import 'package:danji_client/screens/merchant/merchant_productList_screen.dart';
import 'package:danji_client/screens/merchant/merchant_updateOrder_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../screens/login_screen.dart';
import '../../screens/customer/signup_customer_screen.dart';
import '../../screens/merchant/signup_merchant_screen.dart';
import '../../screens/customer/home_customer_screen.dart';
import '../../screens/merchant/home_merchant_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup/customer',
        builder: (context, state) => const SignupCustomerScreen(),
      ),
      GoRoute(
        path: '/signup/merchant',
        builder: (context, state) => const SignupMerchantScreen(),
      ),

      // CUSTOMER
      GoRoute(
        path: '/home/customer',
        builder: (context, state) => const HomeCustomerScreen(),
      ),
      GoRoute(
        path: '/home/customer/marketList',
        builder: (context, state) => const CustomerMarketListScreen(),
      ),
      GoRoute(
        path: '/home/customer/marketList/detail/:id',
        builder: (context, state) {
          final marketId = int.parse(state.pathParameters['id']!);
          final extra = state.extra as Map<String, String>;

          return CustomerMarketdetailScreen(
            marketId: marketId,
            marketName: extra['marketName']!,
            marketAddress: extra['marketAddress']!,
          );
        },
      ),
      GoRoute(
        path: '/home/customer/marketList/order',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return CustomerOrderScreen(extra: args);
        },
      ),
      GoRoute(
        path: '/home/customer/orderList',
        builder: (context, state) => const CustomerOrderListScreen(),
      ),

      // MERCHANT
      GoRoute(
        path: '/home/merchant',
        builder: (context, state) => const HomeMerchantScreen(),
      ),
      GoRoute(
        path: '/home/merchant/productList',
        builder: (context, state) => const MerchantProductListScreen(),
      ),
      GoRoute(
        path: '/home/merchant/productList/add',
        builder: (context, state) => const MerchantAddProductScreen(),
      ),
      GoRoute(
        path: '/home/merchant/orderList',
        builder: (context, state) => const MerchantOrderListScreen(),
      ),
      GoRoute(
        path: '/home/merchant/orderList/update',
        builder: (context, state) {
          final extra = state.extra! as Map<String, dynamic>;
          final orderId = extra['orderId'] as int;
          final orderItems = List<Map<String, dynamic>>.from(
            extra['orderItems'],
          );

          return MerchantUpdateOrderScreen(
            orderId: orderId,
            orderItems: orderItems,
          );
        },
      ),

      GoRoute(
        path: '/chat',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ChatScreen(
            targetId: extra['targetId'],
            targetName: extra['targetName'],
          );
        },
      ),
    ],
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final isLoggedIn = auth.isLoggedIn;

      if (!isLoggedIn &&
          state.fullPath != '/login' &&
          !state.fullPath!.startsWith('/signup')) {
        return '/login';
      }

      if (isLoggedIn && state.fullPath == '/login') {
        return auth.role == 'CUSTOMER' ? '/home/customer' : '/home/merchant';
      }

      return null;
    },
  );

  return router;
});
