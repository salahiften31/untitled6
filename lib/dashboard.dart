// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:untitled6/Graphe/bar_graphe.dart';
import 'package:untitled6/home.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isHovered = false;
  bool isHovered1 = false;
  bool isHovered2 = false;
  bool isHovered3 = false;
  bool isHovered4 = false;
 int totalUsers = 0;
  int newUsersThisMonth = 0;
  int totalPodcasts = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch data when widget initializes
    fetchMetrics();
  }


    Future<void> fetchMetrics() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      // Get current date and first day of current month
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      
      // Get total users
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();
      totalUsers = userSnapshot.size;
      
      // Get new users this month
      final newUsersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('createdAt', isGreaterThanOrEqualTo: firstDayOfMonth)
          .get();
      newUsersThisMonth = newUsersSnapshot.size;
      
      // Get total podcasts
      final podcastSnapshot = await FirebaseFirestore.instance
          .collection('podcasts')
          .get();
      totalPodcasts = podcastSnapshot.size;
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching metrics: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
decoration: BoxDecoration(
border: Border.all(color: Colors.black12 ,width: 3),
borderRadius: BorderRadius.circular(10),
     color: Colors.white,
),

         
            padding: EdgeInsets.all(10),
            width: screenWidth * 0.2, // 20% of screen width
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.05),
                  child: ListTile(
                    leading: SizedBox(
                      height: screenHeight*0.08,
                      width: screenWidth *0.045,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          "assets/5907.jpg",
                          scale: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      "My App",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth*0.013,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Container(
                   decoration: BoxDecoration(  
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.blue[700],),
                  margin: EdgeInsets.only(top: screenHeight * 0.1),
                  child: MouseRegion(
                    onEnter: (_) => setState(() => isHovered = true),
                    onExit: (_) => setState(() => isHovered = false),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MaterialButton(
                        onPressed: () {},
                        child: ListTile(
                          leading: Icon(Icons.dashboard,size: screenHeight*0.022,),
                          title: Text("Dashboard",style: TextStyle(fontSize: screenWidth *0.01),),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.05),
                  child: MouseRegion(
                    onEnter: (_) => setState(() => isHovered1 = true),
                    onExit: (_) => setState(() => isHovered1 = false),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: isHovered1 ? Colors.blue[700] : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed("user");
                        },
                        child: ListTile(
                          leading: Icon(Icons.person,size: screenHeight*0.022,),
                          title: Text("Users",style: TextStyle(fontSize: screenWidth *0.01),),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.05),
                  child: MouseRegion(
                    onEnter: (_) => setState(() => isHovered2 = true),
                    onExit: (_) => setState(() => isHovered2 = false),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: isHovered2 ? Colors.blue[700] : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed("admin");
                        },
                        child: ListTile(
                          leading: Icon(Icons.admin_panel_settings,size: screenHeight*0.022,),
                          title: Text("Admins",style: TextStyle(fontSize: screenWidth *0.01),),
                        ),
                      ),
                    ),
                  ),
                ),
 Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.05),
                  child: MouseRegion(
                    onEnter: (_) => setState(() => isHovered4 = true),
                    onExit: (_) => setState(() => isHovered4 = false),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: isHovered4 ? Colors.blue[700] : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed("rep");
                        },
                        child: ListTile(
                          leading: Icon(Icons.flag,size: screenHeight*0.022,),
                          title: Text("Reported",style: TextStyle(fontSize: screenWidth *0.01),),
                        ),
                      ),
                    ),
                  ),
                ),




                Spacer(), // Push the logout button to the bottom
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.05),
                  child: MouseRegion(
                    onEnter: (_) => setState(() => isHovered3 = true),
                    onExit: (_) => setState(() => isHovered3 = false),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: isHovered3 ? Colors.blue[700] : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm Logout"),
                                content:
                                    Text("Are you sure you want to logout?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => Home()),
                                      );
                                    },
                                    child: Text("Logout"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: ListTile(
                          leading: Transform.rotate(
                            angle: 3.14,
                            child: Icon(Icons.logout,size: screenHeight*0.022,),
                          ),
                          title: Text("Logout",style: TextStyle(fontSize: screenWidth*0.01),),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content Area
          Container(
            height: screenHeight,
            width: screenWidth * 0.8,
            color:  Color(0xffd9d9d9),
            child: Container(
              margin: EdgeInsets.only(top: screenHeight * 0.002),
              
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth * 0.8,
                      margin: EdgeInsets.only(top: screenHeight * 0.08),
                      child: Wrap(
                        spacing: 20, // Horizontal spacing between cards
                        runSpacing: 16, // Vertical spacing between cards
                        alignment: WrapAlignment.spaceAround,
                        children: [
                          _buildDashboardCard(
                              "New users this month", screenWidth,"11539820.jpg",screenHeight,newUsersThisMonth.toString()),
                          _buildDashboardCard("Total users", screenWidth,"11539820.jpg",screenHeight,totalUsers.toString()),
                          _buildDashboardCard(
                              "New podcasts this month", screenWidth,"38772.jpg",screenHeight,totalPodcasts.toString()),
                        ],
                      ),
),

Row(children: [
Container( 
  margin: EdgeInsets.only(top: screenHeight*0.1,left: screenWidth*0.032),
  padding: EdgeInsets.only(top: screenHeight*0.05,bottom:  screenHeight*0.03,left: screenWidth*0.03),
decoration: BoxDecoration(
  border: Border.all(color: Colors.black12,width: 3),
borderRadius: BorderRadius.circular(50),
color: Colors.white,

),

height: screenHeight*0.5,
width: screenWidth*0.6,
child: Mybar_G(),

)
], )
                    
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build dashboard cards
 Widget _buildDashboardCard(String title, double screenWidth, String picture, double screenHeight, String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 3),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      width: screenWidth * 0.2, // 15% of screen width
      height: screenHeight * 0.15, // Fixed height for cards
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  value, // Display the actual value
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: screenHeight * 0.045,
            margin: EdgeInsets.only(left: screenWidth * 0.15),
            child: ClipRRect(
              child: Image.asset("assets/$picture"),
            ),
          )
        ],
      ),
    );
  }
}
