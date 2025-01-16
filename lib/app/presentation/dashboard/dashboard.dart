// dashBoardPage this page used for bottomNavigationBar(bottomNavigationBar will be constant for everyPage)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/home/bloc/home_bloc.dart';
import 'package:lm_club/app/home/bloc/home_state.dart';
import 'package:lm_club/app/home/plan_status.dart';
import 'package:lm_club/app/home/planvalidity.dart';
import 'package:lm_club/app/presentation/rewards/rewards.dart';
import 'package:lm_club/utils/globals.dart' as globals;
import '../../home/home.dart';
import '../profile/profile.dart';

class MyApplication extends StatelessWidget {
  const MyApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Dashboard(),
        '/home': (context) => const Home(),
        '/profile': (context) => Profile(id: globals.userId),
        '/rewards': (context) => const Rewards()
      },
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final HomeBloc _homeBloc = getIt.get<HomeBloc>();

  int _selectedIndex = 0;
  DateTime today = DateTime.now();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _homeBloc..getUserDetails(globals.userId),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
            body: state.userDetails?.planStatus == true
                ? state.userDetails!.planValidity != null &&
                        (state.userDetails!.planValidity!.isBefore(today) ||
                            state.userDetails!.planValidity!
                                .isAtSameMomentAs(today))
                    ? const PlanValidityPage()
                    : _getPage(_selectedIndex, state)
                : const PlanStatus(),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                child: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.emoji_events_rounded),
                      label: 'Rewards',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle_rounded),
                      label: 'Profile',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: const Color.fromRGBO(0, 176, 80, 1),
                  unselectedItemColor: const Color.fromRGBO(116, 116, 116, 1),
                  selectedLabelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'NeueHaasGroteskTextPro',
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'NeueHaasGroteskTextPro',
                  ),
                  onTap: _onItemTapped,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getPage(int index, HomeState state) {
    switch (index) {
      case 0:
        return const Home();

      case 1:
        return const Rewards();
      case 2:
        return Profile(id: globals.userId);

      default:
        return const Home();
    }
  }
}

class HomeWithBottomNav extends StatelessWidget {
  const HomeWithBottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Home(),
        );
      },
    );
  }
}

void main() {
  runApp(const MyApplication());
}
