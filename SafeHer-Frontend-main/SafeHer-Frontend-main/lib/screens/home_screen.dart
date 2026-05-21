// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';
// import '../widgets/common_widgets.dart';
// import '../screens/routes_screen.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBg,
//       body: SafeArea(  
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             const SizedBox(height: 20),
//             _buildHeader(),
//             const SizedBox(height: 20),
//             _buildHeroCard(),
//             const SizedBox(height: 14),
//             _buildQuickSosBanner(),
//             const SizedBox(height: 24),
//             const Text('Features', style: kTitle),
//             const SizedBox(height: 14),
//             _buildFeaturesGrid(),
//             const SizedBox(height: 24),
//             const Text('Recent Activity', style: kTitle),
//             const SizedBox(height: 12),
//             _buildActivity(Icons.location_on_rounded, 'Location shared with Mom', '2 min ago'),
//             _buildActivity(Icons.route_rounded, 'Safe route to Home saved', '1 hr ago'),
//             _buildActivity(Icons.chat_bubble_rounded, 'AI safety tip received', '3 hrs ago'),
//             const SizedBox(height: 20),
//           ]),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(children: [
//       Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         RichText(
//           text: const TextSpan(
//             style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: kText),
//             children: [
//               TextSpan(text: 'SafeHer '),
//               TextSpan(text: 'AI', style: TextStyle(color: kPink)),
//             ],
//           ),
//         ),
//         const Text('Your safety companion', style: TextStyle(color: kSubtext, fontSize: 13)),
//       ]),
//       const Spacer(),
//       Container(
//         width: 44,
//         height: 44,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10)],
//         ),
//         child: Stack(alignment: Alignment.center, children: [
//           const Icon(Icons.notifications_outlined, color: kText, size: 22),
//           Positioned(
//             right: 10,
//             top: 10,
//             child: Container(
//               width: 8,
//               height: 8,
//               decoration: const BoxDecoration(color: kPink, shape: BoxShape.circle),
//             ),
//           ),
//         ]),
//       ),
//     ]);
//   }

//   Widget _buildHeroCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(22),
//       decoration: BoxDecoration(
//         gradient: kHeroGradient,
//         borderRadius: BorderRadius.circular(22),
//         boxShadow: [BoxShadow(color: kPink.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
//       ),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: const Row(children: [
//               Icon(Icons.shield_rounded, color: Colors.white, size: 16),
//               SizedBox(width: 6),
//               Text("You're Safe",
//                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
//             ]),
//           ),
//           const Spacer(),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Text('Live', style: TextStyle(color: Colors.white, fontSize: 12)),
//           ),
//         ]),
//         const SizedBox(height: 14),
//         const Text('Good evening, Sarah',
//             style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
//         const SizedBox(height: 4),
//         Text('All safety features are active and monitoring.',
//             style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
//       ]),
//     );
//   }

//   Widget _buildQuickSosBanner() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFFFF4D8D), Color(0xFF9B3FD4)],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: const Row(children: [
//         Icon(Icons.shield_rounded, color: Colors.white, size: 28),
//         SizedBox(width: 14),
//         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text('Quick SOS',
//               style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
//           Text('Tap to send emergency alert',
//               style: TextStyle(color: Colors.white70, fontSize: 12)),
//         ]),
//         Spacer(),
//         Icon(Icons.chevron_right_rounded, color: Colors.white),
//       ]),
//     );
//   }

//   Widget _buildFeaturesGrid() {
//     const features = [
//       (Icons.shield_rounded, Color(0xFFFF4D8D), 'Emergency SOS', 'One-tap alert to contacts'),
//       (Icons.chat_bubble_rounded, Color(0xFF7B2FBE), 'AI Assistant', 'Safety tips & guidance'),
//       (Icons.location_on_rounded, Color(0xFFFF4D8D), 'Live Location', 'Share with trusted people'),
//       (Icons.route_rounded, Color(0xFF7B2FBE), 'Safe Routes', 'AI-powered navigation'),
//     ];

//     return GridView.count(
//       crossAxisCount: 2,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisSpacing: 12,
//       mainAxisSpacing: 12,
//       childAspectRatio: 1.1,
//       children: features.map((f) => _FeatureCard(icon: f.$1, color: f.$2, title: f.$3, subtitle: f.$4)).toList(),
//     );
//   }

//   Widget _buildActivity(IconData icon, String title, String time) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       decoration: kCardDecoration,
//       child: Row(children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(color: kLightPurple, borderRadius: BorderRadius.circular(10)),
//           child: Icon(icon, size: 18, color: kPurple),
//         ),
//         const SizedBox(width: 14),
//         Expanded(
//           child: Text(title,
//               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kText)),
//         ),
//         Text(time, style: kCaption),
//       ]),
//     );
//   }
// }

// // class _FeatureCard extends StatelessWidget {
// //   final IconData icon;
// //   final Color color;
// //   final String title;
// //   final String subtitle;

// //   const _FeatureCard({
// //     required this.icon,
// //     required this.color,
// //     required this.title,
// //     required this.subtitle,
// //   });

// class _FeatureCard extends StatelessWidget {
//   final IconData icon;
//   final Color color;
//   final String title;
//   final String subtitle;
//   final VoidCallback? onTap;

//   const _FeatureCard({
//     required this.icon,
//     required this.color,
//     required this.title,
//     required this.subtitle,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(16),
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: kCardDecoration,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.12),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(icon, color: color, size: 22),
//             ),
//             const SizedBox(height: 12),
//             Text(title,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 14,
//                     color: kText)),
//             const SizedBox(height: 4),
//             Text(subtitle, style: kCaption),
//           ],
//         ),
//       ),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     var color;
//     IconData? icon;
//     String title;
//     String subtitle;
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: kCardDecoration,
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.12),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(icon, color: color, size: 22),
//         ),
//         const SizedBox(height: 12),
//         Text(title,
//             style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kText)),
//         const SizedBox(height: 4),
//         Text(subtitle, style: kCaption),
//       ]),
//     );
//   }
// }
// Widget _buildFeaturesGrid() {
//   return GridView.count(
//     crossAxisCount: 2,
//     shrinkWrap: true,
//     physics: const NeverScrollableScrollPhysics(),
//     crossAxisSpacing: 12,
//     mainAxisSpacing: 12,
//     childAspectRatio: 1.1,
//     children: [

//       _FeatureCard(
//         icon: Icons.shield_rounded,
//         color: const Color(0xFFFF4D8D),
//         title: 'Emergency SOS',
//         subtitle: 'One-tap alert to contacts',
//       ),

//       _FeatureCard(
//         icon: Icons.chat_bubble_rounded,
//         color: const Color(0xFF7B2FBE),
//         title: 'AI Assistant',
//         subtitle: 'Safety tips & guidance',
//       ),

//       _FeatureCard(
//         icon: Icons.location_on_rounded,
//         color: const Color(0xFFFF4D8D),
//         title: 'Live Location',
//         subtitle: 'Share with trusted people',
//       ),

//       _FeatureCard(
//         icon: Icons.route_rounded,
//         color: const Color(0xFF7B2FBE),
//         title: 'Safe Routes',
//         subtitle: 'AI-powered navigation',
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => const RoutesScreen(),
//             ),
//           );
//         },
//       ),

//     ],
//   );
// }



import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../screens/routes_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 20),
              _buildHeroCard(),
              const SizedBox(height: 14),
              _buildQuickSosBanner(),
              const SizedBox(height: 24),
              const Text('Features', style: kTitle),
              const SizedBox(height: 14),
              _buildFeaturesGrid(context),
              const SizedBox(height: 24),
              const Text('Recent Activity', style: kTitle),
              const SizedBox(height: 12),
              _buildActivity(Icons.location_on_rounded, 'Location shared with Mom', '2 min ago'),
              _buildActivity(Icons.route_rounded, 'Safe route to Home saved', '1 hr ago'),
              _buildActivity(Icons.chat_bubble_rounded, 'AI safety tip received', '3 hrs ago'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: kText),
            children: [
              TextSpan(text: 'SafeHer '),
              TextSpan(text: 'AI', style: TextStyle(color: kPink)),
            ],
          ),
        ),
        const Text('Your safety companion',
            style: TextStyle(color: kSubtext, fontSize: 13)),
      ]),
      const Spacer(),
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10)
          ],
        ),
        child: Stack(alignment: Alignment.center, children: [
          const Icon(Icons.notifications_outlined, color: kText, size: 22),
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration:
                  const BoxDecoration(color: kPink, shape: BoxShape.circle),
            ),
          ),
        ]),
      ),
    ]);
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: kHeroGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
              color: kPink.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(children: [
              Icon(Icons.shield_rounded, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Text("You're Safe",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ]),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('Live',
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ]),
        const SizedBox(height: 14),
        const Text('Good evening, Sarah',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text('All safety features are active and monitoring.',
            style:
                TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
      ]),
    );
  }

  Widget _buildQuickSosBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF4D8D), Color(0xFF9B3FD4)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(children: [
        Icon(Icons.shield_rounded, color: Colors.white, size: 28),
        SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Quick SOS',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700)),
          Text('Tap to send emergency alert',
              style: TextStyle(color: Colors.white70, fontSize: 12)),
        ]),
        Spacer(),
        Icon(Icons.chevron_right_rounded, color: Colors.white),
      ]),
    );
  }

  Widget _buildFeaturesGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        const _FeatureCard(
          icon: Icons.shield_rounded,
          color: Color(0xFFFF4D8D),
          title: 'Emergency SOS',
          subtitle: 'One-tap alert to contacts',
        ),
        const _FeatureCard(
          icon: Icons.chat_bubble_rounded,
          color: Color(0xFF7B2FBE),
          title: 'AI Assistant',
          subtitle: 'Safety tips & guidance',
        ),
        const _FeatureCard(
          icon: Icons.location_on_rounded,
          color: Color(0xFFFF4D8D),
          title: 'Live Location',
          subtitle: 'Share with trusted people',
        ),
        _FeatureCard(
          icon: Icons.route_rounded,
          color: const Color(0xFF7B2FBE),
          title: 'Safe Routes',
          subtitle: 'AI-powered navigation',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const RoutesScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActivity(IconData icon, String title, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: kCardDecoration,
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: kLightPurple, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: kPurple),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: kText)),
        ),
        Text(time, style: kCaption),
      ]),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _FeatureCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: kCardDecoration,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: kText)),
          const SizedBox(height: 4),
          Text(subtitle, style: kCaption),
        ]),
      ),
    );
  }
}

