import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modules/singleplayer/chip_folder_screen.dart';
import '../modules/bluetooth/ble_screen.dart';
import '../modules/bluetooth/ble_provider.dart';
import 'pet_shell.dart';

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_index) {
      case 1:
        body = const ChipFolderScreen();
        break;
      case 2:
        // Keep BLE provider scoped to this screen but alive while visible
        body = ChangeNotifierProvider(
          create: (_) => BleProvider(),
          child: const BleScreen(),
        );
        break;
      case 0:
      default:
        body = const PetShell();
    }

    return Scaffold(
      body: SafeArea(child: body),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pet'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Chips'),
          BottomNavigationBarItem(icon: Icon(Icons.bluetooth), label: 'BLE'),
        ],
      ),
    );
  }
}
