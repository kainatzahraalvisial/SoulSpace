import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soulspace/src/ui/screens/main_page.dart';
import '../../utils/app_colors.dart'; 


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
  
    final bannerTopOffset = 100.h;
    final bannerBottomMargin = 150.h; 
    final triggerTopOffset = 50.h; 
    final triggerBottomOffset = 60.h; 
    final illustrationHeight = 230.h; 

  
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
      
          Positioned(top: showLogin ? null : 0.h, bottom: showLogin ? 0.h : null, left: 0, right: 0, child: Image.asset("assets/images/signup_stars.png", height: 150.h, fit: BoxFit.cover, width: MediaQuery.of(context).size.width)),
          Positioned(top: showLogin ? -50.h : null, left: -50.w, bottom: showLogin ? null : -50.h, child: Image.asset("assets/images/signup_wave.png", height: 450.h, fit: BoxFit.contain, opacity: const AlwaysStoppedAnimation(0.5))),

          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400), 
              transitionBuilder: (Widget child, Animation<double> animation) {
                final isSigningUp = child.key == const ValueKey('SignupContent');
                
              
                final Offset beginOffset = isSigningUp 
                    ? const Offset(0.0, 0.1)  
                    : const Offset(0.0, -0.1); 

                final offsetAnimation = Tween<Offset>(
                  begin: beginOffset,
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutQuad)); 
                
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

 

  
  Widget _buildSignupScreenContent(BuildContext context, TextEditingController usernameController, TextEditingController emailController, TextEditingController passwordController, TextEditingController confirmPasswordController, double bannerTopOffset, double illustrationHeight) {
    return Column(
      children: [
        SizedBox(height: bannerTopOffset), 
        Expanded(
          child: ClipPath(
            clipper: AuthClipper(isLogin: false), 
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

  
  Widget _buildLoginScreenContent(BuildContext context, TextEditingController usernameController, TextEditingController passwordController, double loginBannerRenderHeight, double illustrationHeight) {
    return Column(
      children: [
        SizedBox( 
          height: loginBannerRenderHeight,
          child: ClipPath(
            clipper: AuthClipper(isLogin: true), 
            child: Container(
              color: AppColors.lightPink,
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: _buildLoginFormContent(context, usernameController, passwordController, illustrationHeight),
            ),
          ),
        ),
    
        SizedBox(height: MediaQuery.of(context).size.height - loginBannerRenderHeight),
      ],
    );
  }

  
  Widget _buildSignupFormContent(BuildContext context, TextEditingController usernameController, TextEditingController emailController, TextEditingController passwordController, TextEditingController confirmPasswordController, double illustrationHeight) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 60.h, bottom: 20.h), 
      physics: const NeverScrollableScrollPhysics(), 
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
                  MaterialPageRoute(builder: (_) => const MainPage(username: 'Jane')),  
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
  
  
  Widget _buildLoginFormContent(BuildContext context, TextEditingController usernameController, TextEditingController passwordController, double illustrationHeight) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 60.h, bottom: 20.h),
      physics: const NeverScrollableScrollPhysics(), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Log In", style: TextStyle(fontFamily: 'Poppins', fontSize: 40.sp, fontWeight: FontWeight.w600, color: AppColors.black), textAlign: TextAlign.center),
          SizedBox(height: 20.h),
          _inputField("Username", usernameController),
          SizedBox(height: 10.h),
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
                  MaterialPageRoute(builder: (_) => const MainPage(username: 'Jane')),  
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