import 'package:flutter/material.dart';
//for auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
//for pages
import 'package:thekaamwale/Clients/Client_ScreenShow.dart';
import 'package:thekaamwale/Credential/ForgotPass_ScreenShow.dart';
import 'package:thekaamwale/Credential/Register_ScreenShow.dart';
import 'package:thekaamwale/Workers/Worker_ScreenShow.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Login_ScreenShow extends StatefulWidget {
  const Login_ScreenShow({super.key});

  @override
  State<Login_ScreenShow> createState() => _Login_ScreenShowState();
}

class _Login_ScreenShowState extends State<Login_ScreenShow> {
  @override


  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
    emailController.dispose();
    passwordController.dispose();
  }

  clearText() {
    emailController.clear();
    passwordController.clear();
  }

  void _openRazorpayPayment() {
    var options = {
      'key': 'rzp_test_3MjLOTBB8eEKSL',
      'amount': 9900, // Amount in paisa (10000 paisa = ₹100)
      'name': 'THE KAAMWALE',
      'description': 'Registration Fee',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      Fluttertoast.showToast(msg:'Error during Razorpay payment No Internet: $e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    login(emailController.text, passwordController.text);
    clearText();
    // Calculate new validity date (one year from now)
    DateTime newValidityDate = DateTime.now().add(const Duration(days: 365));

    // Update validity date in Firestore
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({
        'validityDate': newValidityDate.toIso8601String(),
      });

      // Show success message
      Fluttertoast.showToast(msg: 'Account Renew Successfully');

      // Close any dialogs if open
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (error) {
      // Handle error
      Fluttertoast.showToast(msg: 'Please Try Again: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content:
              const Text('Failed to update subscription. Please try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Failed'),
        content: const Text('Failed to complete payment. Please try again.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  //-------------------------------------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(0.85)),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 1,
              decoration: const BoxDecoration(
                /*image: DecorationImage(
                    image:AssetImage('assets/images/honey.png'),
                    fit: BoxFit.cover,
                ),*/
                gradient: LinearGradient(
                  colors: [Color(0xff95a6a7), Color(0xff2b3d4f)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Image.asset('assets/images/aikaamwale.png',
                              height: 250, width: 250),


                          Container(
                            height: 300,
                            width: 380,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              gradient: const LinearGradient(
                                colors: [Color(0xff95a6a7), Color(0xff2b3d4f)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.7), // Color of the shadow
                                  spreadRadius: 5, // Spread radius
                                  blurRadius: 7, // Blur radius
                                  offset:
                                      const Offset(0, 3), // Offset of the shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: TextFormField(
                                    //text email info
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Enter Your Email',
                                      enabled: true,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, bottom: 8.0, top: 8.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Email cannot be empty";
                                      }
                                      if (!RegExp(
                                              "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                          .hasMatch(value)) {
                                        return ("Please enter a valid email");
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      emailController.text = value!;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: TextFormField(
                                    //text password info
                                    controller: passwordController,
                                    obscureText: _isObscure3,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                          icon: Icon(_isObscure3
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              _isObscure3 = !_isObscure3;
                                            });
                                          }),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Enter Your Password',
                                      enabled: true,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, bottom: 8.0, top: 15.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    validator: (value) {
                                      RegExp regex = RegExp(r'^.{6,}$');
                                      if (value!.isEmpty) {
                                        return "Password cannot be empty";
                                      }
                                      if (!regex.hasMatch(value)) {
                                        return ("please enter valid password min. 6 character");
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      passwordController.text = value!;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                MaterialButton(
                                  //Login button
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                  elevation: 9.0,
                                  height: 40,

                                  onPressed: () {
                                    setState(() {
                                      visible = true;
                                      // clearText();
                                    });
                                    if (_formkey.currentState!.validate()) {
                                      login(emailController.text, passwordController.text);
                                    } //calling
                                  },
                                  color: Colors.white,//const Color(0xff95a6a7)
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                forgotPassword(),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 40,
                          ),

                          const Text("Not Register Yet?",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),

                          MaterialButton(
                            //Register Now button
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                            ),
                            elevation: 9.0,
                            height: 40,

                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Register_ScreenShow(),
                                ),
                              );
                            },
                            color: Colors.white,
                            child: const Text(
                              "Register Here",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          //forgot password
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "CLIENT") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Client_ScreenShow(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Worker_ScreenShow(),
            ),
          );
        }
      } else {
        Fluttertoast.showToast(msg:'Check Your Internet Connection');
      }
    });
  }

  void login(String email, String password) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
                color: Color(0xff2b3d4f),
                backgroundColor: Colors.white,
              ));
        });

    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        checkValidity(email,password);
        route();
      } on FirebaseAuthException catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Image.asset('assets/images/errorgif.gif',
                height: 50,
                width: 50,
              ),
              content: const Text('Please Enter Valid Email and Password'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> checkValidity(String email, String password) async {
     var user = _auth.currentUser;
    // Get the user document from Firestore
    DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(user!.uid).get();

    if (userSnapshot.exists) {
      // Get the validity date from the user document
      DateTime validityDate = DateTime.parse(userSnapshot['validityDate']);

      // Calculate the expiration date (1 year from the validity date)
      DateTime expirationDate = validityDate.add(const Duration(days: 365));

      // Get today's date
      DateTime now = DateTime.now();

      if (now.isAfter(expirationDate)) {
        // Validity period is over
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Validity Expired'),
              content: const Text('Your validity period has expired.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
         // Validity period is still active, allow login
        // Add your login logic here
        Fluttertoast.showToast(msg:'Login Permitted');
      }
    } else {
      Fluttertoast.showToast(msg:'User Not found');
    }
  }

  Row forgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ForgotPass_ScreenShow()));
          },
          child: const Text(" Forgot Password? ",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        )
      ],
    );
  }
}
