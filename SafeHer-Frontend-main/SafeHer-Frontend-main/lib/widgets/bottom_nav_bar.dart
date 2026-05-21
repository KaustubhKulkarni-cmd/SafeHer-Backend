import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;

  const BottomNavBar({super.key, required this.current, required this.onTap});

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'Home'),
    (Icons.shield_outlined, Icons.shield_rounded, 'SOS'),
    (Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, 'AI Chat'),
    (Icons.location_on_outlined, Icons.location_on_rounded, 'Location'),
    (Icons.route_outlined, Icons.route_rounded, 'Routes'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 20, offset: Offset(0, -4))],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 62,
          child: Row(
            children: List.generate(_items.length, (i) {
              final sel = current == i;
              final isHome = i == 0;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isHome && sel)
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: kPinkPurpleGradient,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(_items[i].$2, color: Colors.white, size: 24),
                        )
                      else ...[
                        Icon(
                          sel ? _items[i].$2 : _items[i].$1,
                          size: 22,
                          color: sel ? kPink : kSubtext,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _items[i].$3,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                            color: sel ? kPink : kSubtext,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
