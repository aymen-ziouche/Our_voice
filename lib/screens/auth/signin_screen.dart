import 'package:flutter/material.dart';
import 'package:our_voice/screens/auth/signup_screen.dart';
import 'package:our_voice/screens/main/mainpage.dart';
import 'package:our_voice/services/auth.dart';
import 'package:our_voice/widgets/mainbutton.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);
  static String id = "SigninPage";

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _auth = Auth();
  bool? eula = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 32,
          ),
          child: Form(
            key: _globalKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  SizedBox(
                    height: 35.h,
                    child: const Center(
                      child: Image(
                        image: AssetImage('images/logo.png'),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 60.0),
                  TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_passwordFocusNode),
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter your email!' : null,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email!',
                      hintStyle: TextStyle(
                        color: Colors.black54,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter your password!' : null,
                    obscureText: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your pasword!',
                      hintStyle: TextStyle(
                        color: Colors.black54,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MainButton(
                    text: "Login",
                    hasCircularBorder: true,
                    onTap: () async {
                      if (_globalKey.currentState!.validate()) {
                        _globalKey.currentState!.save();
                        if (eula == true) {
                          try {
                            final authresult = await _auth.signIn(
                                _emailController.text,
                                _passwordController.text);
                            Navigator.pushReplacementNamed(
                                context, MainPage.id);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.toString(),
                                ),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'You need to read and accept the EULA')));
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                          value: eula,
                          onChanged: (value) {
                            setState(() {
                              eula = value!;
                            });
                          }),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          launchUrlString(
                              'https://shopnest.club/ourterms.html');
                        },
                        child: Text(
                          'I\'ve read and accept the terms of use',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        child: const Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF6006EE),
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, SignupPage.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // List<AuthProvider<AuthListener, auth.AuthCredential>> providerConfigs = [
    //   EmailAuthProvider(),
    //   GoogleProvider(
    //       clientId:
    //           "45937420310-vtvebbvul0d6os0laup2vfgql0u4snan.apps.googleusercontent.com"),
    // ];
    // return SignInScreen(
    //   providers: providerConfigs,
    //   headerBuilder: (context, constraints, _) {
    //     return ListView(
    //       children: [
    //         SizedBox(
    //           height: 2.h,
    //         ),
    //         SizedBox(
    //           height: 25.h,
    //           child: const Center(
    //             child: Image(
    //               image: AssetImage('images/logo.png'),
    //             ),
    //           ),
    //         ),
    //         Divider(
    //           height: 2.h,
    //           thickness: 0.6.h,
    //           indent: 8.w,
    //           endIndent: 80.w,
    //           color: const Color(0xFF2F2272),
    //         ),
    //       ],
    //     );
    //   },
    //   footerBuilder: (context, auth) {
    //     return Row(
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       children: [
    //         Checkbox(
    //           value: eula,
    //           onChanged: (bool? value) {
    //             setState(() {
    //               eula = value!;
    //             });
    //           },
    //         ),
    //         SizedBox(
    //           width: 5.w,
    //         ),
    //         GestureDetector(
    //           onTap: () {
    //             launchUrlString('https://shopnest.club/ourterms.html');
    //           },
    //           child: const Text(
    //             'I\'ve read and accept the terms of use',
    //             style: TextStyle(color: Colors.deepPurple, fontSize: 10),
    //           ),
    //         ),
    //       ],
    //     );
    //   },
    //   headerMaxExtent: 30.h,
    //   resizeToAvoidBottomInset: true,
    //   actions: [
    //     AuthStateChangeAction<SigningIn>((context, state) {
    //       if (eula == false) {
    //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //             content: Text('You need to read and accept the EULA')));
    //       }
    //     }),
    //   ],
    // );
  }
}
