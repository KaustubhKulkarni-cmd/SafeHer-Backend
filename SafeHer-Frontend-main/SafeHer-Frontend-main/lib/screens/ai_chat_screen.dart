// import 'dart:async';
// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';

// class AiChatScreen extends StatefulWidget {
//   const AiChatScreen({super.key});

//   @override
//   State<AiChatScreen> createState() => _AiChatScreenState();
// }

// class _AiChatScreenState extends State<AiChatScreen> {
//   final _ctrl = TextEditingController();
//   final _scroll = ScrollController();
//   bool _typing = false;

//   final List<_Message> _msgs = [
//     _Message(
//       text: "Hi Sarah! 👋 I'm your AI safety assistant. How can I help you stay safe today?",
//       isBot: true,
//     ),
//   ];

//   static const _suggestions = [
//     (Icons.shield_outlined, 'Night safety tips'),
//     (Icons.location_on_outlined, 'Is this area safe?'),
//     (Icons.fitness_center_outlined, 'Self-defense tips'),
//     (Icons.route_outlined, 'Safe routes nearby'),
//   ];

//   void _send(String text) {
//     if (text.trim().isEmpty) return;
//     setState(() {
//       _msgs.add(_Message(text: text, isBot: false));
//       _typing = true;
//     });
//     _ctrl.clear();
//     _scrollToBottom();

//     Future.delayed(const Duration(milliseconds: 1400), () {
//       if (!mounted) return;
//       setState(() {
//         _typing = false;
//         _msgs.add(_Message(
//           text: "That's a great concern! Here are some safety tips to help you stay secure...",
//           isBot: true,
//         ));
//       });
//       _scrollToBottom();
//     });
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scroll.hasClients) {
//         _scroll.animateTo(
//           _scroll.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     _scroll.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBg,
//       body: SafeArea(
//         child: Column(children: [
//           _buildHeader(),
//           Expanded(
//             child: ListView.builder(
//               controller: _scroll,
//               padding: const EdgeInsets.all(16),
//               itemCount: _msgs.length + (_typing ? 1 : 0),
//               itemBuilder: (_, i) {
//                 if (_typing && i == _msgs.length) return const _TypingBubble();
//                 return _ChatBubble(message: _msgs[i]);
//               },
//             ),
//           ),
//           _buildSuggestions(),
//           _buildInputBar(),
//         ]),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
//       color: Colors.white,
//       child: Row(children: [
//         const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: kText),
//         const SizedBox(width: 14),
//         Container(
//           width: 40,
//           height: 40,
//           decoration: const BoxDecoration(shape: BoxShape.circle, gradient: kPinkPurpleGradient),
//           child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 20),
//         ),
//         const SizedBox(width: 12),
//         const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text('SafeHer AI',
//               style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: kText)),
//           Text('Always here for you',
//               style: TextStyle(fontSize: 12, color: kSubtext)),
//         ]),
//       ]),
//     );
//   }

//   Widget _buildSuggestions() {
//     return SizedBox(
//       height: 44,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemCount: _suggestions.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 8),
//         itemBuilder: (_, i) {
//           final s = _suggestions[i];
//           return GestureDetector(
//             onTap: () => _send(s.$2),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//               decoration: BoxDecoration(
//                 color: kLightPurple,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(mainAxisSize: MainAxisSize.min, children: [
//                 Icon(s.$1, size: 14, color: kPurple),
//                 const SizedBox(width: 6),
//                 Text(s.$2,
//                     style: const TextStyle(
//                         fontSize: 12, color: kPurple, fontWeight: FontWeight.w500)),
//               ]),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildInputBar() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
//       child: Container(
//         decoration: BoxDecoration(
//           color: const Color(0xFFF0ECF8),
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Row(children: [
//           Expanded(
//             child: TextField(
//               controller: _ctrl,
//               decoration: const InputDecoration(
//                 hintText: 'Ask me anything about safety...',
//                 hintStyle: TextStyle(color: kSubtext, fontSize: 14),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//               ),
//               onSubmitted: _send,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 6),
//             child: GestureDetector(
//               onTap: () => _send(_ctrl.text),
//               child: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: const BoxDecoration(
//                     shape: BoxShape.circle, gradient: kPinkPurpleGradient),
//                 child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

// // ─── Message Model ────────────────────────────────────────────────────────────
// class _Message {
//   final String text;
//   final bool isBot;
//   _Message({required this.text, required this.isBot});
// }

// // ─── Chat Bubble ──────────────────────────────────────────────────────────────
// class _ChatBubble extends StatelessWidget {
//   final _Message message;

//   const _ChatBubble({required this.message});

//   @override
//   Widget build(BuildContext context) {
//     final isBot = message.isBot;
//     return Align(
//       alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: isBot ? Colors.white : kPurple,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(18),
//             topRight: const Radius.circular(18),
//             bottomLeft: Radius.circular(isBot ? 4 : 18),
//             bottomRight: Radius.circular(isBot ? 18 : 4),
//           ),
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
//         ),
//         child: Text(
//           message.text,
//           style: TextStyle(
//             fontSize: 14,
//             color: isBot ? kText : Colors.white,
//             height: 1.4,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─── Typing Indicator ─────────────────────────────────────────────────────────
// class _TypingBubble extends StatefulWidget {
//   const _TypingBubble();

//   @override
//   State<_TypingBubble> createState() => _TypingBubbleState();
// }

// class _TypingBubbleState extends State<_TypingBubble>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _c;

//   @override
//   void initState() {
//     super.initState();
//     _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
//       ..repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _c.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(18),
//             topRight: Radius.circular(18),
//             bottomRight: Radius.circular(18),
//             bottomLeft: Radius.circular(4),
//           ),
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: List.generate(3, (i) {
//             return AnimatedBuilder(
//               animation: _c,
//               builder: (_, __) => Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 3),
//                 width: 8,
//                 height: 8,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: kPurple.withOpacity(
//                     0.3 + 0.7 * ((_c.value + i * 0.33) % 1.0),
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../theme/app_theme.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}
// Future<String> _getLocationName(double lat, double lng) async {
//   try {

//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(lat, lng);

//     if (placemarks.isEmpty) {
//       return "Unknown location";
//     }

//     Placemark place = placemarks.first;

//     String locality = place.locality ?? "";
//     String city = place.subAdministrativeArea ?? "";
//     String state = place.administrativeArea ?? "";

//     // build readable location
//     String location = "";

//     if (locality.isNotEmpty) location += locality;
//     if (city.isNotEmpty) location += ", $city";
//     if (state.isNotEmpty) location += ", $state";

//     if (location.isEmpty) {
//       return "Location unavailable";
//     }

//     return location;

//   } catch (e) {

//     print("GEOCODING ERROR: $e");

//     return "Location unavailable";
//   }
// }
Future<String> _getLocationName(double lat, double lng) async {

  try {

    List<Placemark> placemarks =
        await placemarkFromCoordinates(lat, lng);

    if (placemarks.isNotEmpty) {

      Placemark place = placemarks.first;

      String locality = place.locality ?? "";
      String state = place.administrativeArea ?? "";

      if (locality.isNotEmpty || state.isNotEmpty) {
        return "$locality, $state";
      }

    }

  } catch (e) {
    print("GEOCODING ERROR: $e");
  }

  // fallback
  return "Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}";
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  bool _typing = false;

  final List<_Message> _msgs = [
    _Message(
      text:
          "Hi Sarah! 👋 I'm your AI safety assistant. How can I help you stay safe today?",
      isBot: true,
    ),
  ];

  static const _suggestions = [
    (Icons.shield_outlined, 'Night safety tips'),
    (Icons.location_on_outlined, 'Is this area safe?'),
    (Icons.fitness_center_outlined, 'Self-defense tips'),
    (Icons.route_outlined, 'Safe routes nearby'),
  ];

  // Future<String> _askAI(String message) async {
  //   final response = await http.post(
  //     Uri.parse("http://10.0.2.2:5000/api/chat"),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({"message": message}),
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return data["reply"];
  //   } else {
  //     throw Exception("AI request failed");
  //   }
  // }
// Future<String> _askAI(String message, double lat, double lng) async {

//   final response = await http.post(
//     Uri.parse("http://127.0.0.1:5000/api/chat"),
//     headers: {"Content-Type": "application/json"},
//     body: jsonEncode({
//       "message": message,
//       "lat": lat,
//       "lng": lng
//     }),
//   );

//   final data = jsonDecode(response.body);

//   return data["reply"];
// }

// Future<String> _askAI(String message, double lat, double lng) async {

//   final response = await http.post(
//     Uri.parse("http://127.0.0.1:5000/api/chat"),
//     headers: {"Content-Type": "application/json"},
//     body: jsonEncode({
//       "message": message,
//       "lat": lat,
//       "lng": lng
//     }),
//   );

//   print("STATUS: ${response.statusCode}");
//   print("BODY: ${response.body}");

//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     return data["reply"];
//   } else {
//     throw Exception("Backend error");
//   }
// }
Future<String> _askAI(String message, double lat, double lng) async {

  final response = await http.post(
    Uri.parse("http://127.0.0.1:5000/api/chat"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "message": message,
      "lat": lat,
      "lng": lng
    }),
  );

  print("STATUS: ${response.statusCode}");
  print("BODY: ${response.body}");

  final data = jsonDecode(response.body);

  return data["reply"]?.toString() ?? "SafeHer AI returned no response.";
}
  // void _send(String text) async {
  //   if (text.trim().isEmpty) return;

  //   setState(() {
  //     _msgs.add(_Message(text: text, isBot: false));
  //     _typing = true;
  //   });

  //   _ctrl.clear();
  //   _scrollToBottom();

  //   try {
  //     String reply = await _askAI(text);

  //     if (!mounted) return;

  //     setState(() {
  //       _typing = false;
  //       _msgs.add(_Message(text: reply, isBot: true));
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _typing = false;
  //       _msgs.add(_Message(
  //         text: "Sorry, I couldn't connect to SafeHer AI right now.",
  //         isBot: true,
  //       ));
  //     });
  //   }

  //   _scrollToBottom();
  // }

void _send(String text) async {
print("SEND BUTTON PRESSED");

Position position = await Geolocator.getCurrentPosition(
  desiredAccuracy: LocationAccuracy.high,
);

print("LAT: ${position.latitude}");
print("LNG: ${position.longitude}");

  if (text.trim().isEmpty) return;
  setState(() {
    _msgs.add(_Message(text: text, isBot: false));
    _typing = true;
  });

  _ctrl.clear();
  _scrollToBottom();

  try {

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double lat = position.latitude;
    double lng = position.longitude;

    String locationName = await _getLocationName(lat, lng);

    String reply = await _askAI(text, lat, lng);

    if (!mounted) return;

    setState(() {
      _typing = false;

      _msgs.add(_Message(
        text: "📍 Your current location: $locationName",
        isBot: true,
      ));

      _msgs.add(_Message(text: reply, isBot: true));
    });

  } catch (e) {

  print("AI ERROR: $e");

  setState(() {
    _typing = false;
    _msgs.add(_Message(
      text: "Sorry, I couldn't connect to SafeHer AI.",
      isBot: true,
    ));
  });

}

  _scrollToBottom();
}

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(16),
              itemCount: _msgs.length + (_typing ? 1 : 0),
              itemBuilder: (_, i) {
                if (_typing && i == _msgs.length) {
                  return const _TypingBubble();
                }
                return _ChatBubble(message: _msgs[i]);
              },
            ),
          ),
          _buildSuggestions(),
          _buildInputBar(),
        ]),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      color: Colors.white,
      child: Row(children: [
        const Icon(Icons.arrow_back_ios_new_rounded,
            size: 16, color: kText),
        const SizedBox(width: 14),
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, gradient: kPinkPurpleGradient),
          child: const Icon(Icons.smart_toy_rounded,
              color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SafeHer AI',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: kText)),
            Text('Always here for you',
                style: TextStyle(fontSize: 12, color: kSubtext)),
          ],
        ),
      ]),
    );
  }

  Widget _buildSuggestions() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final s = _suggestions[i];
          return GestureDetector(
            onTap: () => _send(s.$2),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: kLightPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(s.$1, size: 14, color: kPurple),
                const SizedBox(width: 6),
                Text(s.$2,
                    style: const TextStyle(
                        fontSize: 12,
                        color: kPurple,
                        fontWeight: FontWeight.w500)),
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0ECF8),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _ctrl,
              decoration: const InputDecoration(
                hintText: 'Ask me anything about safety...',
                hintStyle: TextStyle(color: kSubtext, fontSize: 14),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              onSubmitted: _send,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () => _send(_ctrl.text),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: kPinkPurpleGradient),
                child: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isBot;
  _Message({required this.text, required this.isBot});
}

class _ChatBubble extends StatelessWidget {
  final _Message message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isBot = message.isBot;

    return Align(
      alignment:
          isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isBot ? Colors.white : kPurple,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isBot ? 4 : 18),
            bottomRight: Radius.circular(isBot ? 18 : 4),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06), blurRadius: 8)
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            fontSize: 14,
            color: isBot ? kText : Colors.white,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06), blurRadius: 8)
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return AnimatedBuilder(
              animation: _c,
              builder: (_, __) => Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 3),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPurple.withOpacity(
                    0.3 + 0.7 * ((_c.value + i * 0.33) % 1.0),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

