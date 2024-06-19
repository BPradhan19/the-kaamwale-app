import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thekaamwale/Credential/Login_ScreenShow.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Register_ScreenShow extends StatefulWidget {
  const Register_ScreenShow({super.key});

  @override
  State<Register_ScreenShow> createState() => _Register_ScreenShowState();
}

class _Register_ScreenShowState extends State<Register_ScreenShow> {
  @override

  //--------------------------------------------------------

  bool showProgress = false;
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  var options = ['CLIENT', 'WORKER'];
  var _currentItemSelected = "CLIENT";
  var role = "CLIENT";

  var email="";
  var password="";


  late Razorpay _razorpay;


  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    Future.delayed(const Duration(seconds: 1), () => showFillFormDialog(context));
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();

    emailController.dispose();
    passwordController.dispose();
    confirmpassController.dispose();
  }

  void clear(){
    emailController.clear();
    passwordController.clear();
    confirmpassController.clear();
  }

  void _openRazorpayPayment() {
    var options = {
      'key': 'rzp_test_3MjLOTBB8eEKSL',
      'amount': 9900, // Amount in paisa (10000 paisa = ₹100)
      'name': 'hello world',
      'description': 'Registration Fee',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      Fluttertoast.showToast(msg:'Error during Razorpay payment: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    signUp(emailController.text, passwordController.text, role);
    clear();
    Fluttertoast.showToast(msg: 'Payment Success');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Failed'),
        content: const Text('Failed to complete payment. Please try again.'),
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

  void signUp(String email, String password, String role) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore(email, role)})
          .catchError((e) {});
    }
  }

  Future<void> postDetailsToFirestore(String email, String role) async {

    showDialog(
        context: context,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
                color: Color(0xff2b3d4f),
                backgroundColor: Colors.white,
              ));
        });

    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = _auth.currentUser;
      final DateTime registrationDate = DateTime.now();
      final DateTime validityDate = registrationDate.add(const Duration(days: 365));

      CollectionReference ref = firebaseFirestore.collection('users');
      await ref.doc(user!.uid).set({
        'email': emailController.text,
        'role': role,
        'uid': user.uid,
        'registrationDate': registrationDate.toIso8601String(),
        'validityDate': validityDate.toIso8601String(),
      });

      Fluttertoast.showToast(msg:"Data successfully Saved");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Successfully Created'),
          content: const Text('Congratulation! can access this Account for 1 Year'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login_ScreenShow()));
              },
              child: const Text('Login'),
            ),
          ],
        ),
      );

    } catch (e) {
     // print("Error posting details to Firestore: $e");
      // Handle error posting details to Firestore
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to save data to Database: $e'),
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

  void showFillFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Create alert dialog
        return AlertDialog(
          title: const Text('Important: Filling the Form'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please take a moment to carefully review the following information before filling out the form:'),
                SizedBox(height: 15), // Add some spacing between lines
                Text('* Carefully fill Your Email Id'),
                Text('* Make Sure you Select your Role.'),
                Text('* Double-check all entered information for accuracy.'),
                Text('* If unsure about any field, seek Clarification before Submitting.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(0.85)),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff95a6a7), Color(0xff2b3d4f)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: <Widget>[
                SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/aikaamwale.png',
                            height: 250, width: 250),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 450,
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
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Enter Your Email (Carefully)',
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
                                  onChanged: (value) {},
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  obscureText: _isObscure,
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(_isObscure
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      },
                                    ),
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
                                  onChanged: (value) {},
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFormField(
                                  obscureText: _isObscure2,
                                  controller: confirmpassController,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(_isObscure2
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure2 = !_isObscure2;
                                        });
                                      },
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Confirm Password',
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
                                    if (confirmpassController.text !=
                                        passwordController.text) {
                                      return "Password did not match";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (value) {},
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Select Role Here: ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  DropdownButton<String>(
                                    dropdownColor: const Color(0xff95a6a7),
                                    borderRadius: BorderRadius.circular(20),
                                    isDense: true,
                                    isExpanded: false,
                                    alignment: Alignment.center,
                                    iconEnabledColor: Colors.deepOrange,
                                    focusColor: Colors.black,
                                    items:
                                        options.map((String dropDownStringItem) {
                                      return DropdownMenuItem<String>(
                                        value: dropDownStringItem,
                                        alignment: Alignment.center,
                                        child: Text(
                                          dropDownStringItem,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            //backgroundColor: Color(0xffdb691e),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newValueSelected) {
                                      setState(() {
                                        _currentItemSelected = newValueSelected!;
                                        role = newValueSelected;
                                      });
                                    },
                                    value: _currentItemSelected,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 80,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  MaterialButton(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    elevation: 5.0,
                                    height: 40,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const Login_ScreenShow(),
                                        ),
                                      );
                                    },
                                    color: const Color(0xff95a6a7),
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  MaterialButton(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    elevation: 5.0,
                                    height: 40,
                                    onPressed: () {
                                      setState(() {
                                        showProgress = true;
                                      });
                                        if (_formkey.currentState!.validate()) {
                                          _openRazorpayPayment();
                                        }
                                    },
                                    color: Colors.white,
                                    child: const Text(
                                      "Register",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
