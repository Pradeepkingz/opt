import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'features/admin/admin_page.dart';
import 'features/auth/role_switcher_page.dart';
import 'features/history/history_page.dart';
import 'features/home/home_page.dart';
import 'features/rides/compare_rides_page.dart';
import 'providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/compare',
        name: 'compare',
        builder: (context, state) => const CompareRidesPage(),
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) => const HistoryPage(),
      ),
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => const AdminPage(),
      ),
      GoRoute(
        path: '/role',
        name: 'role',
        builder: (context, state) => const RoleSwitcherPage(),
      ),
    ],
  );
});
