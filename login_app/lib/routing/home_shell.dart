import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:login_app/screens/home/presentation/home_screen.dart';

class HomeShell extends StatefulWidget {
  final Widget child;
  final String location;
  final bool showBottomNav;
  final bool loggedIn;

  const HomeShell({
    Key? key,
    required this.child,
    required this.location,
    required this.showBottomNav,
    required this.loggedIn,
  }) : super(key: key);

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const HomeScreen(),
    const Scaffold(
      body: Center(
        child: Text('Profile Page - Coming Soon'),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = _getSelectedIndex(widget.location);
  }

  int _getSelectedIndex(String location) {
    if (location.startsWith('/home/profile')) return 1;
    if (location.startsWith('/home')) return 0;
    return 0;
  }

  void _onItemTapped(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });

    switch (newIndex) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/home/profile');
        break;
    }
  }

  @override
  void didUpdateWidget(covariant HomeShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location) {
      setState(() {
        _currentIndex = _getSelectedIndex(widget.location);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          if (!widget.showBottomNav) Positioned.fill(child: widget.child),
        ],
      ),
      bottomNavigationBar: widget.showBottomNav && widget.loggedIn
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            )
          : null,
    );
  }
}
