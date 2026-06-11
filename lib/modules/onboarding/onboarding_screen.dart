import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_pet/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../shared/theme/pet_theme.dart';
import '../../core/app_router.dart';
import '../../core/models/navi.dart';
import '../singleplayer/singleplayer_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<String> _navis = ['MegaMan', 'ProtoMan', 'Roll', 'GutsMan'];
  int _selectedIndex = 0;

  void _confirmSelection() async {
    final loc = AppLocalizations.of(context)!;
    final selectedNavi = _navis[_selectedIndex];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: PetTheme.surface,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: PetTheme.primary),
        ),
        title: Text('${loc.onboardingConfirm} $selectedNavi', 
            style: GoogleFonts.pressStart2p(fontSize: 12, color: PetTheme.primary)),
        content: Text(loc.onboardingSubtitle, 
            style: GoogleFonts.pressStart2p(fontSize: 8, color: PetTheme.textPrimary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.onboardingNo, style: GoogleFonts.pressStart2p(fontSize: 8, color: PetTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc.onboardingYes, style: GoogleFonts.pressStart2p(fontSize: 8)),
          ),
        ],
      )
    );

    if (confirmed == true) {
      final naviBox = Hive.box<Navi>('navi');
      final newNavi = Navi(name: selectedNavi);
      await naviBox.put('active', newNavi);
      
      if (mounted) {
        // Re-init provider
        context.read<SingleplayerProvider>().init();
        Navigator.pushReplacementNamed(context, AppRouter.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: PetTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(loc.onboardingTitle, 
                style: GoogleFonts.pressStart2p(fontSize: 14, color: PetTheme.accent),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(loc.onboardingSubtitle, 
                style: GoogleFonts.pressStart2p(fontSize: 8, color: PetTheme.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: _navis.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIndex = index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? PetTheme.primaryDim : PetTheme.surface,
                          border: Border.all(
                            color: isSelected ? PetTheme.primary : PetTheme.border,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(_navis[index],
                            style: GoogleFonts.pressStart2p(
                              fontSize: 12,
                              color: isSelected ? PetTheme.background : PetTheme.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmSelection,
                  child: Text(loc.onboardingYes),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
