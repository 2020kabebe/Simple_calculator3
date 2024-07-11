
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'calculator_screen.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';
import 'theme_provider.dart';
import 'auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final Battery _battery = Battery();
  late Stream<ConnectivityResult> _connectivityStream;
  late SharedPreferences _prefs;
  late ThemeProvider _themeProvider;

  final List<Widget> _screens = [
    const SignInScreen(),
    const SignUpScreen(),
    const CalculatorScreen(),
  ];

  @override
  void initState() {
    super.initState();
    monitorBattery();
    checkConnectivity();
    _initSharedPreferences();
    _initThemeProvider();
  }

  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeProvider = ThemeProvider(_prefs);
    });
  }

  void _initThemeProvider() {
    _themeProvider = ThemeProvider(_prefs);
  }

  void monitorBattery() {
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      if (state == BatteryState.charging) {
        _battery.batteryLevel.then((level) {
          if (level >= 90) {
            _showNotification('Battery at 90% or above');
          }
        });
      }
    });
  }

  void checkConnectivity() {
    _connectivityStream = Connectivity().onConnectivityChanged as Stream<ConnectivityResult>;
    _connectivityStream.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _showNotification('No internet connection');
      } else {
        _showNotification('Internet connection restored');
      }
    });
  }

  void _showNotification(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => _themeProvider),
        ChangeNotifierProvider(create: (_) => MyAuthProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Simple Calculator App'),
            ),
            body: _screens[_currentIndex],
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.login),
                    title: const Text('Sign In'),
                    onTap: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_add),
                    title: const Text('Sign Up'),
                    onTap: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.calculate),
                    title: const Text('Calculator'),
                    onTap: () {
                      setState(() {
                        _currentIndex = 2;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.brightness_4),
                    title: const Text('Light/Dark Mode'),
                    onTap: () {
                      themeProvider.toggleTheme();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.login),
                  label: 'Sign In',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_add),
                  label: 'Sign Up',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calculate),
                  label: 'Calculator',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
