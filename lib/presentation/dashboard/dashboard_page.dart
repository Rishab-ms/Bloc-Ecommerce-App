import 'package:bloc_ecommerce/presentation/cart/view/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection_container.dart';
import '../dashboard/dashboard_cubit.dart';
import '../home/view/home_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // SCOPED BLOC:
    // DashboardCubit is only needed for this screen, so we provide it here.
    return BlocProvider(
      create: (_) => sl<DashboardCubit>(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    // BlocBuilder listens to state changes (0, 1, 2) and rebuilds.
    return BlocBuilder<DashboardCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: const [HomePage(), CartPage()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              // We read the Cubit to trigger a function.
              // read() is used for events/methods, watch() is used for UI rebuilding.
              context.read<DashboardCubit>().changeTab(index);
            },
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'Cart',
              ),
            ],
          ),
        );
      },
    );
  }
}
