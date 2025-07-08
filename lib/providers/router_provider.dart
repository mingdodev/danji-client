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
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup/customer',
        builder: (context, state) => const SignupCustomerScreen(),
      ),
      GoRoute(
        path: '/signup/merchant',
        builder: (context, state) => const SignupMerchantScreen(),
      ),
      GoRoute(
        path: '/home/customer',
        builder: (context, state) => const HomeCustomerScreen(),
      ),
      GoRoute(
        path: '/home/merchant',
        builder: (context, state) => const HomeMerchantScreen(),
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
        return auth.role == 'CUSTOMER'
            ? '/home/customer'
            : '/home/merchant';
      }

      return null;
    },
  );

  return router;
});
