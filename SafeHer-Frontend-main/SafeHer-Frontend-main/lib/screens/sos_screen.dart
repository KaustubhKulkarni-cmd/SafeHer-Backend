import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

enum SosState { idle, countdown, sent }

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> with TickerProviderStateMixin {
  SosState _state = SosState.idle;
  int _countdown = 3;
  Timer? _timer;
  LatLng? currentLocation;
  Future<void> triggerSOS(double lon, double lat) async {

  final url = Uri.parse("http://127.0.0.1:5000/api/agent/emergency/sos");

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": "123462782984",
        "lat": lat,
        "lon": lon
      }),
    );

    print("SOS Response: ${response.body}");

  } catch (e) {
    print("SOS Error: $e");
  }
}
Future<LatLng?> getCurrentLocation() async {

  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    print("Location service disabled");
    return null;
  }

  LocationPermission permission = await Geolocator.requestPermission();

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    print("Location permission denied");
    return null;
  }

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  return LatLng(position.latitude, position.longitude);
}
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() async {

  LatLng? location = await getCurrentLocation();

  if (location == null) {
    print("Location not available");
    return;
  }

  currentLocation = location;

  setState(() {
    _state = SosState.countdown;
    _countdown = 3;
  });

  _timer = Timer.periodic(const Duration(seconds: 1), (t) {

    setState(() => _countdown--);

    if (_countdown <= 0) {

      t.cancel();

      triggerSOS(
        currentLocation!.longitude,
        currentLocation!.latitude,
      );

      setState(() => _state = SosState.sent);
    }
  });
}

  void _cancel() {
    _timer?.cancel();
    setState(() => _state = SosState.idle);
  }

  void _reset() => setState(() => _state = SosState.idle);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(children: [
          const PageHeader(title: 'Emergency SOS'),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: KeyedSubtree(
                    key: ValueKey(_state),
                    child: switch (_state) {
                      SosState.idle => _IdleView(pulse: _pulse, onTrigger: _startCountdown),
                      SosState.countdown => _CountdownView(count: _countdown, onCancel: _cancel),
                      SosState.sent => _SentView(onReset: _reset),
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(children: [
              Expanded(
                child: QuickActionCard(
                  icon: Icons.phone_rounded,
                  title: 'Call 911',
                  subtitle: 'Emergency',
                  color: kPurple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickActionCard(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Silent SOS',
                  subtitle: 'Text alert',
                  color: kPurple,
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ─── Idle State ───────────────────────────────────────────────────────────────
class _IdleView extends StatelessWidget {
  final Animation<double> pulse;
  final VoidCallback onTrigger;

  const _IdleView({required this.pulse, required this.onTrigger});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      GestureDetector(
        onTap: onTrigger,
        onLongPress: onTrigger,
        child: AnimatedBuilder(
          animation: pulse,
          builder: (_, __) => Stack(alignment: Alignment.center, children: [
            Container(
              width: 240 + 20 * pulse.value,
              height: 240 + 20 * pulse.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPink.withOpacity(0.08),
              ),
            ),
            Container(
              width: 200 + 12 * pulse.value,
              height: 200 + 12 * pulse.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPink.withOpacity(0.13),
              ),
            ),
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: kPinkPurpleGradient,
                boxShadow: [
                  BoxShadow(color: kPink.withOpacity(0.4), blurRadius: 30, offset: const Offset(0, 10)),
                ],
              ),
              child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.shield_rounded, color: Colors.white, size: 44),
                SizedBox(height: 6),
                Text('SOS',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
              ]),
            ),
          ]),
        ),
      ),
      const SizedBox(height: 28),
      const Text(
        'Press and hold to send emergency alert\nto all trusted contacts',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: kSubtext, height: 1.5),
      ),
    ]);
  }
}

// ─── Countdown State ──────────────────────────────────────────────────────────
class _CountdownView extends StatelessWidget {
  final int count;
  final VoidCallback onCancel;

  const _CountdownView({required this.count, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE74C3C), width: 3),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.w800,
              color: Color(0xFFE74C3C),
            ),
          ),
        ),
      ),
      const SizedBox(height: 24),
      const Text(
        'Sending alert in...',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFFE74C3C)),
      ),
      const SizedBox(height: 24),
      OutlineActionButton(label: 'Cancel', onTap: onCancel),
    ]);
  }
}

// ─── Sent State ───────────────────────────────────────────────────────────────
class _SentView extends StatelessWidget {
  final VoidCallback onReset;

  const _SentView({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 160,
        height: 160,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFFFEBEB),
        ),
        child: const Center(
          child: Icon(Icons.warning_amber_rounded, size: 72, color: Color(0xFFE74C3C)),
        ),
      ),
      const SizedBox(height: 24),
      const Text(
        'Alert Sent!',
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFFE74C3C)),
      ),
      const SizedBox(height: 10),
      const Text(
        'Your trusted contacts and emergency services\nhave been notified with your location.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: kSubtext, height: 1.5),
      ),
      const SizedBox(height: 28),
      OutlineActionButton(label: "I'm Safe Now", onTap: onReset),
    ]);
  }
}
