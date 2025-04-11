import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isPasswordVisible = false; // Toggle password visibility

  @override
  Widget build(BuildContext context) {
    // ✅ Get screen width & height using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 198, 198),
      body: Center(
        child: Container(
          width: screenWidth * 0.4, // ✅ Responsive width (60% of screen width)
          height: screenHeight * 0.35, // ✅ Responsive height (50% of screen height)
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Header
              ListTile(
                leading: Icon(Icons.miscellaneous_services_outlined),
                title: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: screenWidth * 0.02), // ✅ Responsive font size
                  ),
                ),
              ),
              
              // Admin Code Field
              SizedBox(
                width: screenWidth * 0.4,
                height: screenHeight * 0.04, // ✅ Responsive width
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Admin code",
                    hintStyle: TextStyle(
fontSize: screenHeight*0.015

                    ),
                    prefixIcon: Icon(Icons.person,size: screenHeight *0.03,),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              // Password Field
              SizedBox(
                width: screenWidth * 0.4,
                height: screenHeight * 0.04, // ✅ Responsive width
                child: TextField(
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Password",
                                        hintStyle: TextStyle(
fontSize: screenHeight*0.015

                    ),
                    prefixIcon: Icon(Icons.lock,size: screenHeight *0.03,), // Changed icon for better UX
                    suffixIcon: IconButton(
                        
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        size: screenHeight *0.023,
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
                width: screenWidth * 0.4, // ✅ Responsive width
                height: screenHeight * 0.04, // ✅ Responsive height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xFF4b68ff),
                ),
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pushNamed("dashb");
                    });
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.010, // ✅ Responsive font size
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
