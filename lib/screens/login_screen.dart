import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' show cos, sin, pi, Random;
import 'home_screen.dart';
import 'attendence_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _selectedLoginType;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_selectedLoginType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a login type'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate loading
    Future.delayed(Duration(seconds: 1), () {
      setState(() => _isLoading = false);

      if (_selectedLoginType == 'owner' &&
          _passwordController.text == 'GYM1234') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else if (_selectedLoginType == 'attendance' &&
          _passwordController.text == 'GYM123') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AttendanceScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    final isTablet = size.width > 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF000000), // Pure black background
        ),
        child: Stack(
          children: [
            // Background effects
            Positioned.fill(
              child: CustomPaint(
                painter: GymAtmospherePainter(),
              ),
            ),
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                child: isLandscape
                    ? _buildLandscapeLayout(size)
                    : _buildPortraitLayout(size),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(Size size) {
    return Container(
      height: size.height - MediaQuery.of(context).padding.top,
      child: Column(
        children: [
          _buildBanner(size),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTitle(),
                  SizedBox(height: 40),
                  _buildLoginOptions(),
                  SizedBox(height: 24),
                  _buildPasswordField(),
                  SizedBox(height: 32),
                  _buildLoginButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(Size size) {
    return Container(
      height: size.height - MediaQuery.of(context).padding.top,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _buildBanner(size),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTitle(),
                  SizedBox(height: 40),
                  _buildLoginOptions(),
                  SizedBox(height: 24),
                  _buildPasswordField(),
                  SizedBox(height: 32),
                  _buildLoginButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(Size size) {
    return Animate(
      effects: [
        FadeEffect(duration: Duration(milliseconds: 800)),
      ],
      child: Container(
        height: size.height * 0.3,
        //width: size.width * 0.9,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/h_banner2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: [
            //       Colors.transparent,
            //       Color(0xFF1A1A2E).withOpacity(0.8),
            //     ],
            //   ),
            // ),
            ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Animate(
          effects: [
            SlideEffect(
              begin: Offset(0, -0.2),
              end: Offset.zero,
            ),
          ],
          child: Text(
            'HUGGETTS GYM',
            style: GoogleFonts.anton(
              fontSize: 36,
              color: Color(0xFFF5F5F5), // Off-white
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: Color(0xFFFFC107), // Golden yellow
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Animate(
          effects: [
            SlideEffect(
              begin: Offset(0, -0.2),
              end: Offset.zero,
            ),
          ],
          child: Text(
            'BEAST MODE ACTIVATED',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: Color(0xFFF5F5F5).withOpacity(0.9),
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginOptions() {
    return Animate(
      effects: [
        SlideEffect(
          begin: Offset(-0.2, 0),
          end: Offset.zero,
        ),
      ],
      child: Row(
        children: [
          Expanded(
            child: _buildLoginOption(
              'Owner Login',
              Icons.fitness_center,
              'owner',
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildLoginOption(
              'Attendance Login',
              Icons.how_to_reg,
              'attendance',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginOption(String title, IconData icon, String type) {
    final isSelected = _selectedLoginType == type;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedLoginType = type),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isSelected
                  ? [
                      Color(0xFFFFB74D),
                      Color(0xFFFF7043)
                    ] // Warm amber to ember orange
                  : [
                      Color(0xFF121212), // Off-black
                      Color(0xFF000000), // Pure black
                    ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? Border.all(
                    color: Color(0xFFFFC107), width: 2) // Golden yellow
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Color(0xFFFFB74D).withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Color(0xFFFFC107)
                    : Color(0xFFF5F5F5).withOpacity(0.7),
                size: 32,
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  color: isSelected
                      ? Color(0xFFFFC107)
                      : Color(0xFFF5F5F5).withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Animate(
      effects: [
        SlideEffect(
          begin: Offset(0.2, 0),
          end: Offset.zero,
        ),
      ],
      child: Container(
        decoration: BoxDecoration(
          color:
              Color(0xFF121212).withOpacity(0.5), // Off-black with transparency
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000).withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          style: GoogleFonts.poppins(color: Color(0xFFF5F5F5)),
          decoration: InputDecoration(
            hintText: 'Enter Password',
            hintStyle: GoogleFonts.poppins(
              color: Color(0xFFF5F5F5).withOpacity(0.5),
            ),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Color(0xFFFFB74D).withOpacity(0.7),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Color(0xFFFFB74D).withOpacity(0.7),
              ),
              onPressed: () =>
                  setState(() => _isPasswordVisible = !_isPasswordVisible),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.transparent,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Animate(
      effects: [
        SlideEffect(
          begin: Offset(0, 0.2),
          end: Offset.zero,
        ),
      ],
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _handleLogin,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFB74D), // Warm amber
                  Color(0xFFFF7043), // Ember orange
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFFB74D).withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: _isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Color(0xFFF5F5F5),
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'LOGIN',
                      style: GoogleFonts.montserrat(
                        color: Color(0xFFF5F5F5),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class GymAtmospherePainter extends CustomPainter {
  final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw spotlight effects
    _drawSpotlights(canvas, size);

    // Draw ember particles
    _drawEmbers(canvas, size);

    // Draw smoke effect
    _drawSmoke(canvas, size);
  }

  void _drawSpotlights(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.topCenter,
        radius: 1.5,
        colors: [
          Color(0xFFFFB74D).withOpacity(0.2), // Warm amber
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw multiple spotlights
    final spotlightPositions = [
      Offset(size.width * 0.2, 0),
      Offset(size.width * 0.5, 0),
      Offset(size.width * 0.8, 0),
    ];

    for (var position in spotlightPositions) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        paint,
      );
    }
  }

  void _drawEmbers(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFFF7043).withOpacity(0.6); // Ember orange

    for (var i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 1;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }
  }

  void _drawSmoke(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          Color(0xFF121212).withOpacity(0.1); // Off-black with low opacity

    for (var i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 50 + 20;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
