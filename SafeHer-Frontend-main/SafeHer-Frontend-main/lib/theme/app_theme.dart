import 'package:flutter/material.dart';

// ─── Colors ───────────────────────────────────────────────────────────────────
const kPink = Color(0xFFE91E8C);
const kPurple = Color(0xFF7B2FBE);
const kLightPink = Color(0xFFFCE4F3);
const kLightPurple = Color(0xFFF3E8FF);
const kBg = Color(0xFFF7F4FA);
const kCard = Colors.white;
const kText = Color(0xFF1A1A2E);
const kSubtext = Color(0xFF8A8A9A);

// ─── Gradients ────────────────────────────────────────────────────────────────
const kPinkPurpleGradient = LinearGradient(
  colors: [kPink, kPurple],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const kHeroGradient = LinearGradient(
  colors: [Color(0xFFE91E8C), Color(0xFF7B2FBE)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const kMapGradient = LinearGradient(
  colors: [Color(0xFFFCE4F3), Color(0xFFEDE4FF)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// ─── Text Styles ──────────────────────────────────────────────────────────────
const kHeadline = TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kText);
const kTitle = TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: kText);
const kBody = TextStyle(fontSize: 14, color: kText);
const kCaption = TextStyle(fontSize: 12, color: kSubtext);

// ─── Decorations ─────────────────────────────────────────────────────────────
BoxDecoration get kCardDecoration => BoxDecoration(
      color: kCard,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 3)),
      ],
    );

BoxDecoration get kCircleGradient => BoxDecoration(
      shape: BoxShape.circle,
      gradient: kPinkPurpleGradient,
    );

// ─── Theme Data ───────────────────────────────────────────────────────────────
ThemeData get appTheme => ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: kBg,
      fontFamily: 'SF Pro Display',
      colorScheme: ColorScheme.fromSeed(
        seedColor: kPink,
        brightness: Brightness.light,
      ),
    );
