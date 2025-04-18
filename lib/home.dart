import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isPasswordVisible = false;
  final TextEditingController adcodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  Future<void> loginAdmin() async {
    setState(() {
      errorMessage = null;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Admin')
          .where('adcode', isEqualTo: adcodeController.text.trim())
          .where('passw', isEqualTo: passwordController.text.trim())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Navigator.of(context).pushNamed("dashb");
      } else {
        setState(() {
          errorMessage = "Invalid admin code or password.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred. Please try again.";
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 198, 198),
      body: Center(
        child: Container(
          width: screenWidth * 0.4,
          height: screenHeight * 0.4,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ListTile(
                leading: const Icon(Icons.miscellaneous_services_outlined),
                title: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: screenWidth * 0.02),
                  ),
                ),
              ),

              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: screenHeight * 0.015,
                  ),
                ),

              // Admin Code Field
              SizedBox(
                width: screenWidth * 0.4,
                height: screenHeight * 0.05,
                child: TextField(
                  controller: adcodeController,
                  decoration: InputDecoration(
                    hintText: "Admin code",
                    hintStyle: TextStyle(fontSize: screenHeight * 0.015),
                    prefixIcon: Icon(Icons.person, size: screenHeight * 0.03),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              // Password Field
              SizedBox(
                width: screenWidth * 0.4,
                height: screenHeight * 0.05,
                child: TextField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(fontSize: screenHeight * 0.015),
                    prefixIcon: Icon(Icons.lock, size: screenHeight * 0.03),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: screenHeight * 0.023,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              // Login Button
              Container(
                width: screenWidth * 0.4,
                height: screenHeight * 0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color(0xFF4b68ff),
                ),
                child: MaterialButton(
                  onPressed: loginAdmin,
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.010,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
