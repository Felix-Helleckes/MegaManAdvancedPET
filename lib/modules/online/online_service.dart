import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';

/// Mock online battle matchmaking service.
/// In production, replace with WebSocket to a real backend.
class OnlineService extends ChangeNotifier {
  MatchmakingState _state = MatchmakingState.idle;
  String _status = '';
  Map<String, dynamic>? _matchedOpponent;
  Timer? _searchTimer;

  MatchmakingState get state => _state;
  String get status => _status;
  Map<String, dynamic>? get matchedOpponent => _matchedOpponent;

  void startSearch({required String naviName, required int level}) {
    _state = MatchmakingState.searching;
    _status = 'SEARCHING FOR OPPONENT...';
    notifyListeners();

    // Simulate matchmaking delay 2-5 seconds
    final delay = 2 + Random().nextInt(3);
    _searchTimer = Timer(Duration(seconds: delay), () {
      _state = MatchmakingState.matched;
      _status = 'OPPONENT FOUND!';
      _matchedOpponent = {
        'name': _randomOpponent(),
        'level': level + Random().nextInt(3) - 1,
        'rank': Random().nextInt(999) + 1,
      };
      notifyListeners();
    });
  }

  void cancelSearch() {
    _searchTimer?.cancel();
    _state = MatchmakingState.idle;
    _status = '';
    _matchedOpponent = null;
    notifyListeners();
  }

  String _randomOpponent() {
    const names = [
      'ProtoMan', 'GutsMan', 'Roll', 'Bass',
      'Serenade', 'ShadowMan', 'MetalMan', 'WoodMan',
      'Blues', 'Colonel', 'KnightMan', 'ToadMan',
    ];
    return names[Random().nextInt(names.length)];
  }

  void sendBattleAction(Map<String, dynamic> action) {
    // In a real implementation, send via WebSocket
    debugPrint('[OnlineService] Sending: ${jsonEncode(action)}');
  }

  Stream<Map<String, dynamic>> get messageStream {
    // In a real implementation, listen to WebSocket
    return Stream.value({'type': 'mock'});
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }
}

enum MatchmakingState { idle, searching, matched, battling }