import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _liveSharing = true;
  int _timerSeconds = 6150; // 1:42:30
  Timer? _timer;

  final List<_Contact> _contacts = [
    _Contact(name: 'Mom', role: 'Mother', isLive: true),
    _Contact(name: 'Sister - Priya', role: 'Sister', isLive: false),
    _Contact(name: 'Best Friend - Aisha', role: 'Friend', isLive: true),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timerSeconds > 0) setState(() => _timerSeconds--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timerStr {
    final h = _timerSeconds ~/ 3600;
    final m = (_timerSeconds % 3600) ~/ 60;
    final s = _timerSeconds % 60;
    return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(children: [
          const PageHeader(title: 'Live Location'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                const MapPreviewCard(),
                const SizedBox(height: 14),
                _buildLiveSharingToggle(),
                const SizedBox(height: 20),
                _buildContactsHeader(),
                const SizedBox(height: 12),
                ..._contacts.map((c) => _ContactCard(
                      contact: c,
                      onToggle: () => setState(() => c.isLive = !c.isLive),
                    )),
                const SizedBox(height: 4),
                _buildAutoStopTimer(),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildLiveSharingToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: kCardDecoration,
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: kPinkPurpleGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Live Sharing',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: kText)),
            Text('Active • Sharing with 2 contacts', style: kCaption),
          ]),
        ),
        Switch.adaptive(
          value: _liveSharing,
          onChanged: (v) => setState(() => _liveSharing = v),
          activeColor: Colors.white,
          activeTrackColor: kPink,
        ),
      ]),
    );
  }

  Widget _buildContactsHeader() {
    return Row(children: [
      const Icon(Icons.people_alt_rounded, size: 20, color: kText),
      const SizedBox(width: 8),
      const Text('Trusted Contacts', style: kTitle),
      const Spacer(),
      Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(shape: BoxShape.circle, gradient: kPinkPurpleGradient),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
      ),
    ]);
  }

  Widget _buildAutoStopTimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: kCardDecoration,
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: kLightPurple, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.timer_outlined, color: kPurple, size: 20),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Auto-stop Timer',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kText)),
            Text('Sharing stops after 2 hours', style: kCaption),
          ]),
        ),
        Text(_timerStr,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kPink)),
      ]),
    );
  }
}

// ─── Contact Model ────────────────────────────────────────────────────────────
class _Contact {
  final String name;
  final String role;
  bool isLive;

  _Contact({required this.name, required this.role, required this.isLive});
}

// ─── Contact Card ─────────────────────────────────────────────────────────────
class _ContactCard extends StatelessWidget {
  final _Contact contact;
  final VoidCallback onToggle;

  const _ContactCard({required this.contact, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: kCardDecoration,
      child: Row(children: [
        GradientAvatar(letter: contact.name[0]),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(contact.name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: kText)),
            const SizedBox(height: 3),
            Row(children: [
              if (contact.isLive) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF2ECC71),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                contact.isLive ? 'Sharing live' : 'Last shared 2h ago',
                style: kCaption,
              ),
            ]),
          ]),
        ),
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: kLightPurple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              contact.isLive ? 'Stop' : 'Share',
              style: const TextStyle(
                  color: kPurple, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ),
      ]),
    );
  }
}
