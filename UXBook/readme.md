Genau das ist das **Advanced PET**! Auf dem zweiten Bild sieht man auch perfekt, wie das Teil aufgeklappt aussieht: Oben die Linse für die Infrarot-Verbindung, in der Mitte der Bildschirm und darunter das physische Steuerkreuz mit den Knöpfen.

Da **FlutterFlow** eine visuelle No-Code/Low-Code-Plattform ist, kann ich dir dafür keine fertige Projektdatei zum direkten Download generieren (da FlutterFlow ein geschlossenes System für Exporte nutzt).

Ich kann dir aber das **komplette visuelle und strukturelle Fundament bauen**. Ich liefere dir hier den exakt passenden **Custom Painter Code** für das Gehäuse sowie die **Widget-Baum-Struktur**, die du eins zu eins in FlutterFlow nachbauen kannst.

---

## 1. Der visuelle Rahmen: Das Gehäuse als Custom Widget

Damit das PET perfekt aussieht (inklusive des transparenten Bildschirmausschnitts, wenn es aufgeklappt ist), nutzt du am besten ein **Custom Widget** in FlutterFlow.

Erstelle ein neues Custom Widget namens `AdvancedPetHousing` und füge folgenden Code ein. Er zeichnet das blaue Gehäuse mit dem silbernen Inlay und lässt das LCD-Display frei:

```dart
// Automatic FlutterFlow imports
import '/actions/actions.dart' as actions;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart';
import 'package:flutter/material.dart';

class AdvancedPetHousing extends StatefulWidget {
  const AdvancedPetHousing({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _AdvancedPetHousingState createState() => _AdvancedPetHousingState();
}

class _AdvancedPetHousingState extends State<AdvancedPetHousing> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 360,
      height: widget.height ?? 740,
      decoration: BoxDecoration(
        color: const Color(0xFF0F52BA), // Das originale MegaMan-Blau
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFF0A3982), width: 6),
      ),
      child: Stack(
        children: [
          // Silbernes Inlay (Mittelkonsole aus Bild 2)
          Align(
            alignment: const Alignment(0, 0.3),
            child: Container(
              width: (widget.width ?? 360) * 0.85,
              height: (widget.height ?? 740) * 0.65,
              decoration: BoxDecoration(
                color: const Color(0xFFC0C0C0), // Silber-Metallic
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black32,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
            ),
          ),
          // Goldene Akzentstreifen
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            width: 8,
            child: Container(color: const Color(0xFFD4AF37)),
          ),
          Positioned(
            top: 20,
            right: 20,
            bottom: 20,
            width: 8,
            child: Container(color: const Color(0xFFD4AF37)),
          ),
        ],
      ),
    );
  }
}

```

---

## 2. Der Widget-Baum für dein FlutterFlow-UI

Zieh dir in FlutterFlow eine neue Page auf. Nutze einen **Stack** als Main-Layout, um die typische Hardware-Ebenen-Optik zu erzeugen.

Baue den Widget-Baum exakt so auf:

```text
[Page: BasePET]
  └── [Stack]
        ├── [CustomWidget: AdvancedPetHousing] (Der Code von oben - füllt den Screen)
        │
        ├── [Column] (Für das LCD-Display in der oberen Hälfte)
        │     └── [Container] (Das LCD-Display aus Bild 2)
        │           Width: 180, Height: 180
        │           Color: #97A98F (Das matte, grünliche LCD-Grau)
        │           Border: 8px #000000 (Schwarzer dicker Rahmen)
        │           Child: [Stack]
        │                     ├── [Image] (Hier nacheinander die GBA Pixel-Art Sprites rein)
        │                     └── [Text] (Für HP-Anzeige im Retrostil "HP: 100")
        │
        └── [Align: Alignment(0, 0.7)] (Positioniert die Steuerung unten auf dem Silber)
              └── [Column]
                    ├── [Row] (Die zwei grauen Menütasten aus Bild 2)
                    │     ├── [Button] (Linker Knopf - Zurück)
                    │     └── [Button] (Rechter Knopf - Bestätigen)
                    │
                    └── [Container] (Das runde Steuerkreuz)
                          Width: 120, Height: 120
                          Shape: Circle
                          Color: #808080
                          Child: [Stack] (Hier vier Icons für die Pfeile norden/süden/osten/westen)

```

---

## 3. Der Trick für den "Scanlines/LCD"-Look in FlutterFlow

Damit das Display im Container nicht wie ein modernes Smartphone aussieht, kannst du in FlutterFlow ein **Container-Background-Image** verwenden.

1. Erstelle ein winziges, transparentes PNG (z.B. 4x4 Pixel), bei dem die oberen zwei Pixelreihen transparent und die unteren zwei schwarz mit 10% Deckkraft sind.
2. Setze dieses Bild im LCD-Container als Hintergrund auf `Tile` (Kacheln).
3. Dadurch legt sich ein perfektes, horizontales **Pixelraster** über deine MegaMan-Sprites, genau wie bei dem echten LCD-Screen von damals!

Für die Tastenbelegung (Steuerkreuz) verknüpfst du in den FlutterFlow **Actions** einfach die `On Tap`-Events mit deinem Page-State (z.B. Erhöhe den Index des ausgewählten Chips im Menü, wenn "Pfeil rechts" gedrückt wird).