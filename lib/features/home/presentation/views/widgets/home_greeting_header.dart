import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Greeting header widget displaying welcome message with animated wave emoji.
///
/// Shows personalized greeting with user's name and animated hand wave.
/// Used in both mobile and desktop layouts of home view.
class HomeGreetingHeader extends StatefulWidget {
  final String userName;
  final bool isDesktop;

  const HomeGreetingHeader({
    super.key,
    required this.userName,
    this.isDesktop = false,
  });

  @override
  State<HomeGreetingHeader> createState() => _HomeGreetingHeaderState();
}

class _HomeGreetingHeaderState extends State<HomeGreetingHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    // Wave animation creates friendly, welcoming feel for users
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    
    _waveAnimation = Tween<double>(begin: -0.3, end: 0.4).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDesktop) {
      return _buildDesktopHeader();
    }
    return _buildMobileHeader();
  }

  Widget _buildDesktopHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Welcome back ",
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            _buildWaveEmoji(fontSize: 13),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          widget.userName,
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 4, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Welcome back ",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    _buildWaveEmoji(fontSize: 14),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  widget.userName,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ).animate().fade().slideX(begin: -0.2),
        ],
      ),
    );
  }

  Widget _buildWaveEmoji({required double fontSize}) {
    return AnimatedBuilder(
      animation: _waveAnimation,
      builder: (context, child) => Transform.rotate(
        angle: _waveAnimation.value,
        alignment: Alignment.bottomCenter,
        child: child,
      ),
      child: Text("👋", style: TextStyle(fontSize: fontSize)),
    );
  }
}
