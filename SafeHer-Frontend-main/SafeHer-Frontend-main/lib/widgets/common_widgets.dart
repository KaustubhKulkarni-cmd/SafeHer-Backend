import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─── Back Button Header ───────────────────────────────────────────────────────
class PageHeader extends StatelessWidget {
  final String title;
  final List<Widget>? actions;

  const PageHeader({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8)],
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: kText),
          ),
        ),
        const SizedBox(width: 14),
        Text(title, style: kHeadline),
        const Spacer(),
        if (actions != null) ...actions!,
      ]),
    );
  }
}

// ─── Gradient Circle Avatar ───────────────────────────────────────────────────
class GradientAvatar extends StatelessWidget {
  final String letter;
  final double size;

  const GradientAvatar({super.key, required this.letter, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, gradient: kPinkPurpleGradient),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: size * 0.4),
        ),
      ),
    );
  }
}

// ─── Gradient Button ─────────────────────────────────────────────────────────
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double? width;
  final EdgeInsets? padding;

  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: kPinkPurpleGradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: kPink.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: Center(
          child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
        ),
      ),
    );
  }
}

// ─── Outline Button ───────────────────────────────────────────────────────────
class OutlineActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const OutlineActionButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFDDDDDD), width: 1.5),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
        ),
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kText)),
      ),
    );
  }
}

// ─── Pill Tag ─────────────────────────────────────────────────────────────────
class PillTag extends StatelessWidget {
  final String label;
  final Color? bg;
  final Color? fg;

  const PillTag(this.label, {super.key, this.bg, this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg ?? kLightPurple,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: fg ?? kPurple, fontWeight: FontWeight.w500)),
    );
  }
}

// ─── Quick Action Card ────────────────────────────────────────────────────────
class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: kCardDecoration,
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: kText)),
            Text(subtitle, style: kCaption),
          ]),
        ]),
      ),
    );
  }
}

// ─── Map Preview Card ─────────────────────────────────────────────────────────
class MapPreviewCard extends StatelessWidget {
  final String address;
  final double height;

  const MapPreviewCard({super.key, this.address = '123 Main Street, Downtown', this.height = 200});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(gradient: kMapGradient, borderRadius: BorderRadius.circular(22)),
      child: Stack(children: [
        Positioned(top: 20, left: 20, child: _Dot(14, const Color(0xFF9B59B6))),
        Positioned(top: 30, right: 30, child: _Dot(10, kPink.withOpacity(0.5))),
        Positioned(bottom: 30, right: 60, child: _Dot(10, const Color(0xFF9B59B6).withOpacity(0.4))),
        Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(shape: BoxShape.circle, gradient: kPinkPurpleGradient),
              child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 12),
            const Text('Your Location', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: kText)),
            Text(address, style: kCaption),
          ]),
        ),
      ]),
    );
  }
}

class _Dot extends StatelessWidget {
  final double size;
  final Color color;
  const _Dot(this.size, this.color);

  @override
  Widget build(BuildContext context) =>
      Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color));
}
