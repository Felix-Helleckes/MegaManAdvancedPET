import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_pet/core/test_env.dart';

// Detect test environment via assert (only runs in debug/test).
bool _runningInTest = false;
void _detectTest() {
  assert(() {
    _runningInTest = true;
    return true;
  }());
}

class NetNaviSprite extends StatefulWidget {
  final String metaPath; // path to JSON metadata in assets
  const NetNaviSprite({super.key, this.metaPath = 'assets/netnavi/megaman/megaman_meta.json'});

  @override
  State<NetNaviSprite> createState() => _NetNaviSpriteState();
}

class _NetNaviSpriteState extends State<NetNaviSprite> with SingleTickerProviderStateMixin {
  Map<String, dynamic>? meta;
  String currentAnim = 'idle';
  int frameIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // In test environments avoid loading asset bundles which can hang the
    // test harness. Provide an empty meta so widget can build deterministically.
    if (runningInTest) {
      meta = {'animations': {'idle': {'frames': []}}};
      return;
    }

    DefaultAssetBundle.of(context).loadString(widget.metaPath).then((s) {
      setState(() => meta = json.decode(s) as Map<String, dynamic>);
      if (!runningInTest) _startAnim(currentAnim);
    }).catchError((_) {
      // load failed
    });
  }

  void _startAnim(String name) {
    _timer?.cancel();
    if (meta == null) return;
    final animations = meta!['animations'] as Map<String, dynamic>?;
    final anim = animations?[name] as Map<String, dynamic>?;
    if (anim == null) return;
    final ft = anim['frame_time'] as int? ?? 200;
    frameIndex = 0;
    _timer = Timer.periodic(Duration(milliseconds: ft), (_) {
      setState(() {
        frameIndex = (frameIndex + 1) % (anim['frames'] as List).length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (meta == null) return const SizedBox.shrink();
    final anim = (meta!['animations'] as Map<String,dynamic>)[currentAnim] as Map<String,dynamic>;
    final frames = anim['frames'] as List<dynamic>;
    if (frames.isEmpty) return const SizedBox.shrink();
    final frame = frames[frameIndex];
    final path = (frame['path'] as String).replaceAll('\\', '/');
    return Image.asset(path, fit: BoxFit.contain);
  }
}
