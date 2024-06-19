
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUsScreenShow extends StatefulWidget {
  const AboutUsScreenShow({super.key});

  @override
  State<AboutUsScreenShow> createState() => _AboutUsScreenShowState();
}

class _AboutUsScreenShowState extends State<AboutUsScreenShow> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(0.85)),
      child: Scaffold(
        backgroundColor: const Color(0xffF0F8FF),
        appBar: AppBar(
          title: const Text('A B O U T   U S',style: TextStyle(color: Colors.white),),
          backgroundColor: const Color(0xff2b3d4f),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body:Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1.0,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Welcome to VrkahDev Technology, your trusted partner in navigating the ever-evolving landscape of information technology At VrkahTech , we are committed to delivering innovative solutions that empower businesses to thrive in the digital age With a focus on cutting-edge technology and unwavering dedication to client satisfaction, we strive to exceed expectations and drive success Our journey began with a vision to revolutionize the way businesses harness the power of technology. Since our inception, we have grown into a dynamic team of experts, united by a passion for innovation and a relentless pursuit of excellence.",
                 textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                ),
              ),

              Image.asset('assets/images/persons.png',
                  height: 250,width: 250),
            ],
          ),
        ),
      ),
    );
  }
}

