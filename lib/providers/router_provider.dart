import 'package:danji_client/screens/merchant/merchant_add_product_screen.dart';
import 'package:danji_client/screens/merchant/merchant_orderList_screen.dart';
import 'package:danji_client/screens/merchant/merchant_productList_screen.dart';
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
      // GoRoute(
      //   path: '/home/customer/marketList', builder: (context, state) => const CustomerMarketListScreen(),
      // ),
      // GoRoute(
      //   path: '/home/customer/marketList/detail', builder: (context, state) => const CustomerMarketDetailScreen(),
      // ),
      // GoRoute(
      //   path: '/home/customer/marketList/order', builder: (context, state) => const CustomerOrderScreen(),
      // ),
      // GoRoute(
      //   path: '/home/customer/orderList', builder: (context, state) => const CustomerOrderListScreen(),
      // ),

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
        path: '/home/merchant/orderList', builder: (context, state) => const MerchantOrderListScreen(),
      ),
      // GoRoute(
      //   path: '/home/merchant/orderList/update', builder: (context, state) => const MerchantUpdateOrderScreen(),
      // ),

      // GoRoute(
      //   path: '/home/chat', builder: (context, state) => const ChatScreen(),
      // ),
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
