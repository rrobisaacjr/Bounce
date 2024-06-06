// package imports
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

//file imports
import '../../providers/auth_provider.dart';
import './signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation _animation;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween(begin: 300.0, end: 50.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    final email = TextField(
      key: const Key('emailField'),
      scrollPadding: EdgeInsets.only(bottom: bottomInsets),
      controller: emailController,
      decoration: InputDecoration(
          isDense: true,
          prefixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Icon(Icons.email_rounded)),
          hintStyle: const TextStyle(color: Colors.black54, letterSpacing: 2),
          filled: true,
          fillColor: Colors.white,
          hintText: "Email",
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final password = TextField(
      key: const Key('pwField'),
      controller: passwordController,
      obscureText: true,
      obscuringCharacter: '*',
      focusNode: _focusNode,
      style: const TextStyle(letterSpacing: 2),
      scrollPadding: EdgeInsets.only(bottom: bottomInsets + 40),
      decoration: InputDecoration(
          isDense: true,
          prefixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Icon(Icons.password_rounded)),
          hintStyle: const TextStyle(color: Colors.black54),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Password',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final loginButton = Padding(
      key: const Key('loginButton'),
      padding: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 198, 255, 27),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.black87,
        ),
        onPressed: () async {
          final message = await context.read<AuthProvider>().signIn(
                emailController.text,
                passwordController.text,
              );

          // ignore: use_build_context_synchronously
          showCustomSnackBar(context, message);
        },
        child: const SizedBox(
            height: 40,
            child: Center(
                child: Text('Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    )))),
      ),
    );

    final signUpButton = TextButton(
        onPressed: () async {
          Navigator.of(context).push(
            _createRoute(),
          );
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: const EdgeInsets.only(left: 10),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text("Sign Up.",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15,
                color: Colors.black,
                fontFamily: GoogleFonts.robotoMono().fontFamily,
                height: 0)));

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromARGB(255, 198, 255, 27),
        body: InkWell(
          // to dismiss the keyboard when the user tabs out of the TextField
          splashColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                Flexible(
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.black87, BlendMode.multiply),
                            image: NetworkImage(
                                "https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExbDJzeDZubzcxa3JxZWV6MWwycDF1M2Q1ZThyNmdoN3lrODFhYWpjeSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/6XX4V0O8a0xdS/giphy.gif"),
                            fit: BoxFit.cover)),
                    child: AspectRatio(
                      aspectRatio: 100 / 140,
                      child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: DefaultTextStyle(
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 50,
                                  color: Colors.white,
                                  fontFamily:
                                      GoogleFonts.robotoMono().fontFamily),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText("CONNECT",
                                      speed: const Duration(milliseconds: 200)),
                                  TypewriterAnimatedText("ORGANIZE",
                                      speed: const Duration(milliseconds: 200)),
                                  TypewriterAnimatedText("BOUNCE",
                                      speed: const Duration(milliseconds: 200)),
                                ],
                                repeatForever: true,
                                pause: const Duration(milliseconds: 800),
                              ),
                            ),
                          )),
                    ),
                  ),
                ),
                Flexible(
                    child: ColoredBox(
                        color: const Color.fromARGB(255, 198, 255, 27),
                        child: SizedBox(
                            height: 280,
                            child: ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(40),
                              children: <Widget>[
                                email,
                                const SizedBox(height: 10),
                                password,
                                const SizedBox(height: 10),
                                loginButton,
                                const SizedBox(height: 10),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        "Dont have an account yet?",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      signUpButton
                                    ]),
                                // SizedBox(
                                //   height: MediaQuery.of(context).viewInsets.bottom,
                                // ),
                                SizedBox(height: _animation.value),
                              ],
                            ))))
              ])),
        ));
  }

  void showCustomSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.black87,
        content: Row(
          children: [
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontFamily: GoogleFonts.robotoMono().fontFamily,
                ),
              ),
            )
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          right: 40,
          left: 40,
        ),
      ),
    );
  }

  // RouteAnimation from login to signup page.
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SignupPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
