import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String _kPortNameOverlay = 'OVERLAY';
  static const String _kPortNameHome = 'UI';
  final _receivePort = ReceivePort();
  SendPort? homePort;
  String? latestMessageFromOverlay;
  
  // Selected window insets types
  Set<int> selectedInsetsTypes = {WindowInsetsType.statusBars, WindowInsetsType.navigationBars};
  
  // Collapsible section state
  bool _isInsetsExpanded = false;
  
  // Available window insets types
  final List<MapEntry<String, int>> insetsTypes = [
    MapEntry('Status Bars', WindowInsetsType.statusBars),
    MapEntry('Navigation Bars', WindowInsetsType.navigationBars),
    MapEntry('Caption Bar', WindowInsetsType.captionBar),
    MapEntry('IME', WindowInsetsType.ime),
    MapEntry('System Gestures', WindowInsetsType.systemGestures),
    MapEntry('Mandatory System Gestures', WindowInsetsType.mandatorySystemGestures),
    MapEntry('Tappable Element', WindowInsetsType.tappableElement),
    MapEntry('Display Cutout', WindowInsetsType.displayCutout),
    MapEntry('Window Decor', WindowInsetsType.windowDecor),
    MapEntry('System Overlays', WindowInsetsType.systemOverlays),
  ];

  int combineSelectedInsets() {
    int combined = 0;
    for (var type in selectedInsetsTypes) {
      combined |= type;
    }
    return combined;
  }

  @override
  void initState() {
    super.initState();
    if (homePort != null) return;
    final res = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameHome,
    );
    log("$res: OVERLAY");
    _receivePort.listen((message) {
      log("message from OVERLAY: $message");
      setState(() {
        latestMessageFromOverlay = 'Latest Message From Overlay: $message';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isInsetsExpanded = !_isInsetsExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  children: [
                    Icon(
                      _isInsetsExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Window Insets',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            if (_isInsetsExpanded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: insetsTypes.map((entry) {
                    final isSelected = selectedInsetsTypes.contains(entry.value);
                    return FilterChip(
                      label: Text(entry.key, style: const TextStyle(fontSize: 11)),
                      selected: isSelected,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedInsetsTypes.add(entry.value);
                          } else {
                            selectedInsetsTypes.remove(entry.value);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            const Divider(height: 1),
            TextButton(
              onPressed: () async {
                final status = await FlutterOverlayWindow.isPermissionGranted();
                log("Is Permission Granted: $status");
              },
              child: const Text("Check Permission"),
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () async {
                final bool? res =
                    await FlutterOverlayWindow.requestPermission();
                log("status: $res");
              },
              child: const Text("Request Permission"),
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () async {
                if (await FlutterOverlayWindow.isActive()) return;
                await FlutterOverlayWindow.showOverlay(
                  enableDrag: true,
                  overlayTitle: "X-SLAYER",
                  overlayContent: 'Overlay Enabled',
                  flag: OverlayFlag.defaultFlag,
                  visibility: NotificationVisibility.visibilityPublic,
                  positionGravity: PositionGravity.auto,
                  height: (MediaQuery.of(context).size.height * 0.6).toInt(),
                  width: WindowSize.matchParent,
                  startPosition: const OverlayPosition(0, -259),
                  windowInsets: combineSelectedInsets(),
                );
              },
              child: const Text("Show Overlay"),
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () async {
                if (await FlutterOverlayWindow.isActive()) return;
                await FlutterOverlayWindow.showOverlay(
                  enableDrag: false,
                  overlayTitle: "X-SLAYER",
                  overlayContent: 'Fullscreen Overlay Enabled',
                  flag: OverlayFlag.defaultFlag,
                  visibility: NotificationVisibility.visibilityPublic,
                  //positionGravity: PositionGravity.none,
                  height: WindowSize.fullCover,
                  width: WindowSize.fullCover,
                  startPosition: const OverlayPosition(0, 0),
                  windowInsets: combineSelectedInsets(),
                );
              },
              child: const Text("Show Fullscreen Overlay"),
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () async {
                final status = await FlutterOverlayWindow.isActive();
                log("Is Active?: $status");
              },
              child: const Text("Is Active?"),
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () async {
                await FlutterOverlayWindow.resizeOverlay(
                  WindowSize.matchParent,
                  (MediaQuery.of(context).size.height * 5).toInt(),
                  false,
                );
              },
              child: const Text("Update Overlay"),
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                log('Try to close');
                FlutterOverlayWindow.closeOverlay()
                    .then((value) => log('STOPPED: alue: $value'));
              },
              child: const Text("Close Overlay"),
            ),
            const SizedBox(height: 20.0),
            TextButton(
              onPressed: () {
                homePort ??=
                    IsolateNameServer.lookupPortByName(_kPortNameOverlay);
                homePort?.send('Send to overlay: ${DateTime.now()}');
              },
              child: const Text("Send message to overlay"),
            ),
            const SizedBox(height: 20.0),
            TextButton(
              onPressed: () {
                FlutterOverlayWindow.getOverlayPosition().then((value) {
                  log('Overlay Position: $value');
                  setState(() {
                    latestMessageFromOverlay = 'Overlay Position: $value';
                  });
                });
              },
              child: const Text("Get overlay position"),
            ),
            const SizedBox(height: 20.0),
            TextButton(
              onPressed: () {
                FlutterOverlayWindow.moveOverlay(
                  const OverlayPosition(0, 0),
                );
              },
              child: const Text("Move overlay position to (0, 0)"),
            ),
            const SizedBox(height: 20),
            Text(latestMessageFromOverlay ?? ''),
          ],
        ),
      ),
    );
  }
}
