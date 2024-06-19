import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thekaamwale/Credential/Login_ScreenShow.dart';

class ForgotPass_ScreenShow extends StatefulWidget {
  const ForgotPass_ScreenShow({super.key});

  @override
  State<ForgotPass_ScreenShow> createState() => _ForgotPass_ScreenShowState();
}

class _ForgotPass_ScreenShowState extends State<ForgotPass_ScreenShow> {
  @override
  TextEditingController email=TextEditingController();

  final _formkey = GlobalKey<FormState>();

  resetpassword() async{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Message Send Successfully')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login_ScreenShow()));

    }).catchError((error) {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error! on Sanding Message')));
    });
    }


  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(0.85)),
      child: Scaffold(

        appBar: AppBar(
            title: const Text('Forgot Password',style: TextStyle(color: Colors.white),),
            backgroundColor: const Color(0xff2b3d4f),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff95a6a7),
          child: const Icon(Icons.login_sharp,color: Colors.white,),
          onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=> const Login_ScreenShow()));
          },
        ),
        body: Form(
          key: _formkey,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff95a6a7), Color(0xff2b3d4f)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
                     child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/images/forgotpass.jpg',height: 350,width: 350),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: TextFormField(
                                    controller: email,
                                    decoration:  InputDecoration(hintText: "Enter Email ID (Carefully)",
                                      labelStyle: const TextStyle(color: Colors.grey),
                                      filled: true,
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                          borderSide: const BorderSide(width: 0,style: BorderStyle.none)
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
                              ),

                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(onPressed: (){
                                if(_formkey.currentState!.validate())
                                  {
                                    setState(() {
                                      resetpassword();
                                    });
                                  }

                              },
                                  style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xff95a6a7), // Text color
                              ), child: const Text("Send Link"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("*Please Check Your Email after Clicking on SEND LINK button",style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                   backgroundColor: Colors.white,
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
}
