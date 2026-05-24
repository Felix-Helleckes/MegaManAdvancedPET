Teil 1: Was das originale Handheld damals konnte (Retro-Analyse)
Das Advanced PET vonMegaman (ca. 2004/2005) war kein klassischer Game Boy, sondern ein interaktives Spielzeug-Gadget, das drei Kern-Mechaniken verband: Tamagotchi, Schrittzähler und physisches Kartenspiel.
1. Das Standalone-Gameplay (Singleplayer)
Beim ersten Starten der App sucht sich der Spieler seinen festen NetNavi aus. Dieser Charakter wird fest an den Account/das Handy gebunden. 
Pedometer-Steuerung (Schrittzähler): Im Gehäuse war ein mechanisches Pendel verbaut. Der Spieler musste das PET am Gürtel tragen oder schütteln. Jeder Schritt bewegte den digitalen MegaMan auf einer unsichtbaren Map vorwärts.
Random Encounters (Viren-Kämpfe): Nach einer bestimmten Anzahl an Schritten piepte das Gerät. Ein Kampf gegen Viren startete.
Das "Slot-In"-System: Um anzugreifen, musste der Spieler einen physischen Plastik-Battle-Chip oben in den Schlitz stecken und das PET schwungvoll nach vorne stoßen ("Slash-Bewegung"). Der interne Schalter registrierte die Bewegung, las die Einkerbung des Chips und löste die Attacke (z.B. Cannon, Sword) aus.
Pflege & Fortschritt: Durch Siege verdiente man Zenny (Währung) und Level-Ups für seinen NetNavi, um dessen HP zu steigern.
2. Der Multiplayer (PvP & Tausch)
Physische Kopplung: Auf der Oberseite saßen zwei Metallkontakte. Zwei Spieler mussten ihre PETs direkt Gehäuse an Gehäuse zusammenstecken.
Simultankampf: Nach dem Verbinden wählten beide Spieler blind ihre Chips. Durch die "Slash"-Stoßbewegung wurde die Attacke übertragen. Es war ein schnelles Reaktions- und Schere-Stein-Papier-Spiel.
Teil 2: Lastenheft & Projektplanung für die moderne App
Projektname (Arbeitstitel): Project PET: Local NetBattler
Ziel: Das exakte Gefühl des 2000er-Spielzeugs auf moderne Smartphones (iOS/Android) übertragen – mit Fokus auf Bewegung im echten Leben und zwingender lokaler Interaktion.
1. Funktionale Anforderungen (Was die App können muss)
Modul A: Der Singleplayer-Loop (Das PET im Alltag)
Hintergrund-Schrittzähler: Die App nutzt die Core-Motion-Schnittstellen des Handys (Apple Motion / Android Fitness API). Schritte im echten Leben generieren "Cyber-Meter".
Viren-Alarm via Push: Erreicht der User einen Meilenstein (z.B. alle 2000 Schritte), vibriert das Handy. Ein simpler, rundenbasierter Kampf startet.
Digitales Chip-Deck: User können gefundene oder verdiente Battle Chips in einem "Ordner" verwalten. Es ist möglich doppelte Chips zu haben die man tauschen kann!
Modul B: Das Kampfsystem & Gestensteuerung
Simples Runden-PvP: Synchroner Ablauf. Chip auswählen, Fähigkeit ausführen und Schaden berechnen berechnen.
Modul C: Das "Schulhof"-Netzwerk (Kopplung via Bluetooth LE)
Local-Only Matchmaking: Die App hat keinen globalen Matchmaking-Server.
Bluetooth Low Energy (BLE) Beacon: Das Handy strahlt permanent eine ID aus, wenn die App offen ist. Stehen zwei Spieler im Radius beieinander, taucht der andere Spieler sofort als "Navi in der Nähe" auf.
P2P-Verbindung: Kämpfe und Chip-Trades werden direkt via Bluetooth von Gerät zu Gerät verschickt (Peer-to-Peer).
2. Nicht-funktionale Anforderungen (Technische Rahmenbedingungen)
Plattformen: Cross-Platform mit Flutter oder React Native (erleichtert den Zugriff auf Bluetooth und Sensoren für beide OS).
Datenschutz / Offline-First: Keine Registrierung mit E-Mail nötig. Die Spieldaten (Chips, Level) werden rein lokal auf dem Gerät (z.B. via SQLite oder Hive) gespeichert.
Grafikstil: Puristischer 8-Bit / 16-Bit Pixel-Art-Look, der an die LCD-Anzeigen von damals erinnert, aber farbig und flüssig animiert ist.
3. Phasen- und Meilensteinplanung (Projektplan)
[Phase 1: Konzept & Assets] ---> [Phase 2: Core-Engine & Sensoren] ---> [Phase 3: BLE-Multiplayer] ---> [Phase 4: Polishing & Beta]

To-Do
Erstellung der UI-Wireframes (Wie sieht das virtuelle PET-Gehäuse auf dem Screen aus?).
Aufsetzen des Projekts (Flutter/React Native).
Implementierung des Schrittzählers im Hintergrund.
Programmierung des Kampfsystems gegen Viren (UI + Logik).
Sensor-Testing: Kalibrierung des Beschleunigungssensors, damit die Stoßbewegung präzise erkannt wird und sich "echt" anfühlt.
Integration des BLE-Scans.
Aufbau der Peer-to-Peer-Verbindung zwischen zwei Geräten.
Synchronisation des PvP-Modus (Senden von Schadenswerten und ausgewählten Chips in Echtzeit via Bluetooth).
Implementierung der lokalen Tauschbörse für Chips.
Feintuning der Chip-Stärken und Seltenheitsraten beim Laufen.
Closed Beta mit Freunden (Testen der Bluetooth-Stabilität im Freien).
Veröffentlichung als freies Projekt (z.B. via GitHub Releases für Android / TestFlight für iOS oder direkt in den Stores).

Features:

https://megaman.miraheze.org/wiki/List_of_Advanced_PET_Battle_Chips


1. Offensiv-Chips (Die Angriffe)
Das waren die Klassiker für direkten Schaden, die sich aber in ihrer Reichweite unterschieden:
Nahkampf: Sword, WideSword oder LongSword. Damit konntest du Viren oder den Gegner im PvP direkt vor deiner Nase treffen.
Fernkampf: Cannon, ShotGun oder Vulcan. Die haben über den ganzen Bildschirm geschossen, machten oft aber weniger Schaden oder trafen nur bestimmte Felder.
2. Defensiv- & Support-Chips (Taktik und Schutz)
Ohne die bist du im PvP sofort untergegangen. Hier ging es darum, Schläge abzuwehren oder die eigenen Werte zu verbessern:
Schilde: Shield oder Barrier. Damit konntest du den Angriff des Gegners im perfekten Timing komplett blocken und den Schaden auf Null reduzieren.
Heilung: Recover10, Recover30 etc. Wenn deine HP im Keller waren, konntest du dich mitten im Kampf wieder hochheilen.
Buffs: Attack+10 oder Aqua+10. Diese Chips haben den Schaden des nächsten Chips, den du einsetzt, massiv verstärkt.
3. Feld- & Status-Effekte (Das Spielfeld verändern)
Diese Chips waren besonders fies, weil sie die Regeln des Kampfes manipuliert haben:
Feld-Zerstörung: AreaGrab (um dem Gegner Platz wegzunehmen) oder Gideon. Man konnte Felder in Lava verwandeln oder vergiften, sodass der Gegner Schaden über Zeit erlitt, wenn er sich bewegte.
Stun/Status: FlashMan oder Chips, die den Gegner kurzzeitig eingefroren oder gelähmt haben (Stun), damit er sich nicht mehr bewegen oder kontern konnte.
4. Die mächtigen "Navi-Chips" (Die Ultis)
Das waren die seltensten und begehrtesten Chips auf dem Schulhof. Statt einer Waffe hast du damit einen anderen NetNavi als "Beschwörung" gerufen:
Wenn du den Roll-Chip eingesteckt hast, tauchte Roll kurz auf dem Bildschirm auf, verpasste dem Gegner eine saftige Ohrfeige und heilte gleichzeitig deine HP.
GutsMan kam rein, schlug auf den Boden und brachte das gesamte gegnerische Spielfeld zum Beben.
Warum das für deine App genial ist:
Für dein App-Projekt bedeutet das eine enorme spielerische Tiefe. Ein Kampf läuft dann nicht darauf hinaus, wer am schnellsten sein Handy schüttelt, sondern wer die bessere Taktik hat:
Beispiel für eine PvP-Runde in der App:
Spieler A wählt einen riskanten, extrem starken Sword-Angriff und macht die Stoßbewegung.
Spieler B hat das vorausgesehen, wählt im selben Moment einen Shield-Chip und blockt den Angriff perfekt.
In der nächsten Runde kontert Spieler B mit einem FlashMan-Chip, um Spieler A zu lähmen, und gibt ihm den Rest.
Das macht das Sammeln der Chips in der App (durch das Laufen im echten Leben) extrem motivierend, weil jeder neue Chip, den man findet, eine völlig neue Taktik ermöglicht!
Die wichtigsten NetNavis aus der Serie
1. Die Hauptcharaktere (Die absoluten Must-Haves)
MegaMan.EXE (Rockman): Der Held der Serie. Ausgewogen, nutzt die Standard-Buster und kann jede Art von Chip perfekt einsetzen.
ProtoMan.EXE (Blues): Der Rivale. Extrem schnell, nutzt hauptsächlich Schwerter (Sword-Chips) und ein eingebautes Schild zur perfekten Abwehr.
Roll.EXE: Die Supporterin. Kann sich selbst und Verbündete heilen, greift mit Peitschen-Attacken an.
GutsMan.EXE: Das Kraftpaket. Extrem hoher Grundschaden, bricht den Boden auf und schockt Gegner, ist dafür aber etwas langsamer.
2. Beliebte Antagonisten & Verbündete (Kult-Status)
Bass.EXE (Forte): Der ultimative, unbändige Solo-Navi. Düster, extrem mächtig, nutzt die Getling-Gun-artigen Angriffe. Ein absoluter Fan-Favorit.
SearchMan.EXE: Der Scharfschütze. Perfekt für Fernkampf und präzise Treffer, die unsichtbare Gegner aufdecken.
NumberMan.EXE: Der Taktiker. Ein wandelnder Taschenrechner, der Würfel wirft und im GBA-Spiel mehr Chips zur Auswahl brachte.
FireMan.EXE / HeatMan.EXE: Die Feuer-Navis. Verwandeln Felder in Lava und machen massiven Flächenschaden.
AquaMan.EXE / Iceman.EXE: Die Wasser-Elementar-Navis. Können Gegner einfrieren und verlangsamen.


