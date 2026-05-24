import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_pet/l10n/app_localizations.dart';
import '../../shared/theme/pet_theme.dart';
import 'ble_provider.dart';

class BleScreen extends StatefulWidget {
  const BleScreen({super.key});

  @override
  State<BleScreen> createState() => _BleScreenState();
}

class _BleScreenState extends State<BleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _radarCtrl;
  late Animation<double> _radar;

  @override
  void initState() {
    super.initState();
    _radarCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _radar = Tween<double>(begin: 0, end: 1).animate(_radarCtrl);
  }

  @override
  void dispose() {
    _radarCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PetTheme.background,
      body: SafeArea(
        child: Consumer<BleProvider>(
          builder: (ctx, ble, _) {
            if (ble.state == BleState.scanning) {
              _radarCtrl.repeat();
            } else {
              _radarCtrl.stop();
            }
            final loc = AppLocalizations.of(ctx)!;
            return Column(
              children: [
                _topBar(ctx, loc),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _radarDisplay(ble),
                        const SizedBox(height: 20),
                        _statusBox(ble),
                        const SizedBox(height: 20),
                        _nearbyList(ctx, ble, loc),
                      ],
                    ),
                  ),
                ),
                _scanButton(ble, loc),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _topBar(BuildContext ctx, AppLocalizations loc) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: PetTheme.surface,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 16),
            color: PetTheme.textSecondary,
            onPressed: () => Navigator.pop(ctx),
          ),
          Expanded(
            child: Center(
              child: Text(loc.bleRadarRing,
                  style: GoogleFonts.pressStart2p(
                      fontSize: 10, color: PetTheme.accent,
                      letterSpacing: 2)),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _radarDisplay(BleProvider ble) {
    return Container(
      width: 200, height: 200,
      decoration: BoxDecoration(
        color: PetTheme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: PetTheme.accent, width: 1.5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Concentric rings
          _radarRing(80, PetTheme.accent.withOpacity(0.2)),
          _radarRing(130, PetTheme.accent.withOpacity(0.1)),
          // Sweep line
          AnimatedBuilder(
            animation: _radar,
            builder: (_, __) => Transform.rotate(
              angle: _radar.value * 2 * 3.14159,
              child: Container(
                width: 2,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      PetTheme.accent,
                      PetTheme.accent.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Center dot
          Container(
            width: 8, height: 8,
            decoration: const BoxDecoration(
              color: PetTheme.accent,
              shape: BoxShape.circle,
            ),
          ),
          // Blips for found devices
          ...ble.nearbyPets.asMap().entries.map((e) {
            final angle = e.key * 1.2;
            final dist = (100.0 - (e.value.rssi + 100).clamp(0, 100)) * 0.7;
            return Positioned(
              left: 100 + dist * 0.4 * (angle % 2 - 1),
              top:  100 + dist * 0.4 * (angle * 0.5 % 2 - 1),
              child: Container(
                width: 8, height: 8,
                decoration: const BoxDecoration(
                  color: PetTheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _radarRing(double size, Color color) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1),
      ),
    );
  }

  Widget _statusBox(BleProvider ble) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PetTheme.surface,
        border: Border.all(color: PetTheme.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        ble.statusMessage,
        style: GoogleFonts.pressStart2p(
            fontSize: 8, color: PetTheme.accent, height: 1.6),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _nearbyList(BuildContext ctx, BleProvider ble, AppLocalizations loc) {
    if (ble.nearbyPets.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.bleNavisDetected,
            style: GoogleFonts.pressStart2p(
                fontSize: 8, color: PetTheme.textSecondary)),
        const SizedBox(height: 10),
        ...ble.nearbyPets.map((pet) => _petTile(ctx, pet, ble, loc)),
      ],
    );
  }

  Widget _petTile(BuildContext ctx, DiscoveredPet pet, BleProvider ble, AppLocalizations loc) {
    final isConnected =
        ble.connectedDevice?.remoteId == pet.device.remoteId;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PetTheme.surface,
        border: Border.all(
          color: isConnected ? PetTheme.primary : PetTheme.border,
          width: isConnected ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Text('⚡', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pet.naviName,
                    style: GoogleFonts.pressStart2p(
                        fontSize: 9,
                        color: isConnected
                            ? PetTheme.primary
                            : PetTheme.textPrimary)),
                const SizedBox(height: 4),
                Text('LV.${pet.naviLevel}  •  ${pet.rssi} dBm',
                    style: GoogleFonts.pressStart2p(
                        fontSize: 7, color: PetTheme.textSecondary)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isConnected ? PetTheme.danger : PetTheme.primary,
              foregroundColor: PetTheme.background,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              textStyle:
                  GoogleFonts.pressStart2p(fontSize: 7),
            ),
            onPressed: () => isConnected
                ? ble.disconnect()
                : ble.connectTo(pet),
            child: Text(isConnected ? loc.bleDisc : loc.bleConnect),
          ),
        ],
      ),
    );
  }

  Widget _scanButton(BleProvider ble, AppLocalizations loc) {
    final scanning = ble.state == BleState.scanning;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                scanning ? PetTheme.surfaceVariant : PetTheme.accent,
            foregroundColor: scanning ? PetTheme.textSecondary : PetTheme.background,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: GoogleFonts.pressStart2p(fontSize: 10),
          ),
          onPressed: scanning ? null : ble.startScan,
          child: Text(scanning ? loc.bleScanning : loc.bleScanForNavis),
        ),
      ),
    );
  }
}
