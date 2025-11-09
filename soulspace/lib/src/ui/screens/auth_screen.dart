import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart'; 
import 'home_screen.dart';

// ====================================================================
// 1. CUSTOM CLIPPER CLASS (Unchanged)
// ====================================================================

class AuthClipper extends CustomClipper<Path> {
  final bool isLogin;
  AuthClipper({this.isLogin = false});

  @override
  Path getClip(Size size) {
    var path = Path();
    double width = size.width;
    double height = size.height; 
    
    double archHeight = 70.0; 
    double curveBase = 0.0; 

    if (!isLogin) {
      path.moveTo(0, archHeight);
      path.quadraticBezierTo(width / 2, curveBase, width, archHeight);
      path.lineTo(width, height);
      path.lineTo(0, height);
    } else {
      path.lineTo(width, 0); 
      path.lineTo(width, height - archHeight);
      path.quadraticBezierTo(width / 2, height - curveBase, 0, height - archHeight);
      path.lineTo(0, 0);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

// ====================================================================
// 2. AUTH SCREEN WIDGET (SMOOTH TRANSITION FIX)
// ====================================================================

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool showLogin = false; 

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void toggleView() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive constants
    final bannerTopOffset = 100.h;
    final bannerBottomMargin = 150.h; 
    final triggerTopOffset = 50.h; 
    final triggerBottomOffset = 50.h; 
    final illustrationHeight = 230.h; 

    // Final calculated heights
    final loginBannerRenderHeight = MediaQuery.of(context).size.height - bannerBottomMargin;
    
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 1. Background Elements (Wave and Star)
          Positioned(top: showLogin ? null : 0.h, bottom: showLogin ? 0.h : null, left: 0, right: 0, child: Image.asset("assets/images/signup_stars.png", height: 150.h, fit: BoxFit.cover, width: MediaQuery.of(context).size.width)),
          Positioned(top: showLogin ? -50.h : null, left: -50.w, bottom: showLogin ? null : -50.h, child: Image.asset("assets/images/signup_wave.png", height: 450.h, fit: BoxFit.contain, opacity: const AlwaysStoppedAnimation(0.5))),

          // 2. 🔄 ANIMATED SWITCHER (SMOOTH TRANSITION FIX HERE)
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400), // Adjusted duration slightly faster for a snappier feel
              // Use a combination of slide and fade for the 'smart animate' effect
              transitionBuilder: (Widget child, Animation<double> animation) {
                final isSigningUp = child.key == const ValueKey('SignupContent');
                
                // Define the slide direction based on the NEW content coming in
                final Offset beginOffset = isSigningUp 
                    ? const Offset(0.0, 0.1)  // New Sign Up content comes from slightly down/in (smooth entry)
                    : const Offset(0.0, -0.1); // New Login content comes from slightly up/in

                final offsetAnimation = Tween<Offset>(
                  begin: beginOffset,
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutQuad)); // Use a specific, smooth curve
                
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(position: offsetAnimation, child: child),
                );
              },
              child: showLogin 
                  ? KeyedSubtree(key: const ValueKey('LoginContent'), child: _buildLoginScreenContent(context, usernameController, passwordController, loginBannerRenderHeight, illustrationHeight))
                  : KeyedSubtree(key: const ValueKey('SignupContent'), child: _buildSignupScreenContent(context, usernameController, emailController, passwordController, confirmPasswordController, bannerTopOffset, illustrationHeight)),
            ),
          ),
          
          // 3. 👆 TOP/BOTTOM TRIGGER TEXT - TOP LAYER
          Positioned(
            top: showLogin ? null : triggerTopOffset, 
            bottom: showLogin ? triggerBottomOffset : null, 
            left: 0, right: 0,
            child: Center(
              child: GestureDetector(
                onTap: toggleView,
                child: Text(showLogin ? "Sign Up" : "Log In", style: TextStyle(color: AppColors.black, fontSize: 24.sp, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- BUILDER CONTAINERS FOR ANIMATED SWITCHER ---

  // Builds the entire Sign Up screen layout
  Widget _buildSignupScreenContent(BuildContext context, TextEditingController usernameController, TextEditingController emailController, TextEditingController passwordController, TextEditingController confirmPasswordController, double bannerTopOffset, double illustrationHeight) {
    return Column(
      children: [
        SizedBox(height: bannerTopOffset), // Space for trigger text above
        Expanded(
          child: ClipPath(
            clipper: AuthClipper(isLogin: false), // Top Arch for Sign Up
            child: Container(
              color: AppColors.lightPink,
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: _buildSignupFormContent(context, usernameController, emailController, passwordController, confirmPasswordController, illustrationHeight),
            ),
          ),
        ),
      ],
    );
  }

  // Builds the entire Login screen layout (NO TOP MARGIN)
  Widget _buildLoginScreenContent(BuildContext context, TextEditingController usernameController, TextEditingController passwordController, double loginBannerRenderHeight, double illustrationHeight) {
    return Column(
      children: [
        SizedBox( // Container takes up all space except the bottom margin
          height: loginBannerRenderHeight,
          child: ClipPath(
            clipper: AuthClipper(isLogin: true), // Bottom Arch for Login
            child: Container(
              color: AppColors.lightPink,
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: _buildLoginFormContent(context, usernameController, passwordController, illustrationHeight),
            ),
          ),
        ),
        // This SizedBox creates the white space at the bottom of the screen
        SizedBox(height: MediaQuery.of(context).size.height - loginBannerRenderHeight),
      ],
    );
  }

  // 🧩 Sign Up Form Content (NON-SCROLLING FIX)
  Widget _buildSignupFormContent(BuildContext context, TextEditingController usernameController, TextEditingController emailController, TextEditingController passwordController, TextEditingController confirmPasswordController, double illustrationHeight) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 60.h, bottom: 20.h), 
      physics: const NeverScrollableScrollPhysics(), // Kills unnecessary scrolling
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Sign Up", style: TextStyle(fontFamily: 'Poppins', fontSize: 40.sp, fontWeight: FontWeight.w600, color: AppColors.black), textAlign: TextAlign.center),
          SizedBox(height: 10.h), 
          _inputField("Username", usernameController),
          SizedBox(height: 10.h), 
          _inputField("Email", emailController),
          SizedBox(height: 10.h), 
          _inputField("Password", passwordController, obscure: true),
          SizedBox(height: 10.h), 
          _inputField("Confirm Password", confirmPasswordController, obscure: true),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {
             setState(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen(username: 'Jane')),  // Pass username later
                );
             });
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.forest, foregroundColor: AppColors.white, padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 12.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))),
            child: Text("Sign Up", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: 10.h),
          GestureDetector(onTap: toggleView, child: Text("Already have an account? Log In", style: TextStyle(color: AppColors.lightBlack, fontSize: 16.sp), textAlign: TextAlign.center)),
          SizedBox(height: 20.h),
          Center(child: Image.asset("assets/images/illustration.png", height: illustrationHeight, fit: BoxFit.contain)),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
  
  // 🧩 Login Form Content (NON-SCROLLING FIX)
  Widget _buildLoginFormContent(BuildContext context, TextEditingController usernameController, TextEditingController passwordController, double illustrationHeight) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 60.h, bottom: 20.h),
      physics: const NeverScrollableScrollPhysics(), // Kills unnecessary scrolling
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Log In", style: TextStyle(fontFamily: 'Poppins', fontSize: 40.sp, fontWeight: FontWeight.w600, color: AppColors.black), textAlign: TextAlign.center),
          SizedBox(height: 30.h),
          _inputField("Username", usernameController),
          SizedBox(height: 20.h),
          _inputField("Password", passwordController, obscure: true),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
              child: Text("Forgot Password?", style: TextStyle(color: AppColors.lightBlack, fontSize: 14.sp)),
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {
              setState(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen(username: 'Jane')),  // Pass username later
                );
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.forest, foregroundColor: AppColors.white, padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 12.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))),
            child: Text("Log In", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: 10.h),
          GestureDetector(onTap: toggleView, child: Text("Don’t have an account? Sign Up", style: TextStyle(color: AppColors.lightBlack, fontSize: 16.sp), textAlign: TextAlign.center)),
          SizedBox(height: 20.h),
          Center(child: Image.asset("assets/images/illustration.png", height: illustrationHeight, fit: BoxFit.contain)),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // 🧱 Text Field Builder (unchanged)
  Widget _inputField(String hint, TextEditingController controller, {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14.sp),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h), 
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: Color(0xFFD9D9D9))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1.0)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: AppColors.forest, width: 2.0)),
      ),
    );
  }
}