import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled6/home.dart';
import 'package:intl/intl.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  bool isHovered = false;
  bool isHovered1 = false;
  bool isHovered2 = false;
  bool isHovered3 = false;
  bool isHovered4 = false;
  late String te;
  List<USR> users = [];
  int currentPage = 1;
  final int itemsPerPage = 2;

  @override
  void initState() {
    super.initState();
    fetchuser();
  }

  Future<void> fetchuser() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      print("Fetched ${querySnapshot.docs.length} users");

      final usersList = await Future.wait(querySnapshot.docs.map((doc) async {
        final data = doc.data();
        print("User data: $data");

        // Handle Timestamp conversion
        String formattedDate = '';
        if (data['createdAt'] != null) {
          if (data['createdAt'] is Timestamp) {
            formattedDate = DateFormat('yyyy-MM-dd').format(data['createdAt'].toDate());
          } else if (data['createdAt'] is String) {
            formattedDate = data['createdAt'];
          }
        }

        // Fetch channel data if userId exists
        Map<String, dynamic>? channelData;
        int followers = 0;
        int following = 0;
        String channelName = data['chanel']?.toString() ?? 'N/A';
        String channelPhotoUrl = '';
        
        if (data['userId'] != null) {
          try {
            final channelDocs = await FirebaseFirestore.instance
                .collection('channels')
                .where('userId', isEqualTo: data['userId'])
                .get();
            
            if (channelDocs.docs.isNotEmpty) {
              channelData = channelDocs.docs.first.data();
              followers = channelData['followers'] is int ? channelData['followers'] : 
                        int.tryParse(channelData['followers']?.toString() ?? '0') ?? 0;
              following = channelData['following'] is int ? channelData['following'] : 
                        int.tryParse(channelData['following']?.toString() ?? '0') ?? 0;
              channelName = channelData['name']?.toString() ?? channelName;
              channelPhotoUrl = channelData['photoUrl']?.toString() ?? '';
            }
          } catch (e) {
            print("Error fetching channel data: $e");
          }
        }

        return USR(
          firstName: data['firstName']?.toString() ?? 'N/A',
          lastName: data['lastName']?.toString() ?? 'N/A',
          email: data['email']?.toString() ?? 'N/A',
          country: data['country']?.toString() ?? 'N/A',
          signupd: formattedDate,
          picture: data['photoUrl']?.toString() ?? '',
          age: data['age']?.toString() ?? 'N/A',
          chanel: channelName,
          channelPhotoUrl: channelPhotoUrl,
          followers: followers,
          following: following,
          likes: 0, // Set default value for likes
          pods: 0,  // Set default value for pods
          userId: data['userId']?.toString() ?? '',
        );
      }).toList());

      setState(() {
        users = usersList;
        print("Users list updated: ${users.length} users");
      });
    } catch (e) {
      print("Error fetching users: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading users: ${e.toString()}")),
      );
    }
  }

  List<USR> get paginatedItems {
    int start = (currentPage - 1) * itemsPerPage;
    int end = start + itemsPerPage;
    if (users.isEmpty) return [];
    return users.sublist(start, end > users.length ? users.length : end);
  }

  int get totalPages => (users.length / itemsPerPage).ceil();

  Widget paginationControls(double screenWidth) {
    if (totalPages <= 1) return SizedBox.shrink(); // Don't show pagination if only one page
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        int pageNumber = index + 1;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: pageNumber == currentPage ? Colors.blue[700] : Colors.grey[300],
              foregroundColor: Colors.black,
              minimumSize: Size(screenWidth * 0.03, 36),
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              setState(() {
                currentPage = pageNumber;
              });
            },
            child: Text('$pageNumber'),
          ),
        );
      }),
    );
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
              border: Border.all(color: Colors.black12, width: 3),
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
                      height: screenHeight * 0.08,
                      width: screenWidth * 0.045,
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
                        fontSize: screenWidth * 0.013,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  margin: EdgeInsets.only(top: screenHeight * 0.1),
                  child: MouseRegion(
                    onEnter: (_) => setState(() => isHovered = true),
                    onExit: (_) => setState(() => isHovered = false),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: isHovered ? Colors.blue[700] : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed("dashb");
                        },
                        child: ListTile(
                          leading: Icon(Icons.dashboard, size: screenHeight * 0.022),
                          title: Text("Dashboard", style: TextStyle(fontSize: screenWidth * 0.01)),
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
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed("user");
                        },
                        child: ListTile(
                          leading: Icon(Icons.person, size: screenHeight * 0.022),
                          title: Text("Users", style: TextStyle(fontSize: screenWidth * 0.01)),
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
                          leading: Icon(Icons.admin_panel_settings, size: screenHeight * 0.022),
                          title: Text("Admins", style: TextStyle(fontSize: screenWidth * 0.01)),
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
                          leading: Icon(Icons.flag, size: screenHeight * 0.022),
                          title: Text("Reported", style: TextStyle(fontSize: screenWidth * 0.01)),
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
                                content: Text("Are you sure you want to logout?"),
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
                                        MaterialPageRoute(builder: (context) => Home()),
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
                            child: Icon(Icons.logout, size: screenHeight * 0.022),
                          ),
                          title: Text("Logout", style: TextStyle(fontSize: screenWidth * 0.01)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: Container(
              height: screenHeight,
              color: Colors.white,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: screenWidth * 0.8,
                  child: Column(
                    children: [
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        margin: EdgeInsets.only(top: 10),
                        width: 600,
                        child: Center(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "search user",
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.search),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // White Container for List
                      Container(
                        margin: EdgeInsets.only(top: screenHeight * 0.1),
                        child: Column(
                          children: [
                            // Table Header
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.blue[500],
                              ),
                              width: screenWidth * 0.75,
                              height: screenHeight * 0.05,
                              margin: EdgeInsets.only(top: screenHeight * 0.1),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: screenWidth * 0.095),
                                    child: Text("Name", style: TextStyle(fontSize: screenWidth * 0.008)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: screenWidth * 0.095),
                                    child: Text("email", style: TextStyle(fontSize: screenWidth * 0.008)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: screenWidth * 0.085),
                                    child: Text("chanel", style: TextStyle(fontSize: screenWidth * 0.008)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: screenWidth * 0.055),
                                    child: Text("sign up date", style: TextStyle(fontSize: screenWidth * 0.008)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: screenWidth * 0.056),
                                    child: Text("country", style: TextStyle(fontSize: screenWidth * 0.008)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: screenWidth * 0.06),
                                    child: Text("age", style: TextStyle(fontSize: screenWidth * 0.008)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: screenWidth * 0.042),
                                    child: Text("report", style: TextStyle(fontSize: screenWidth * 0.008)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: screenWidth * 0.019),
                                    child: Text("delete", style: TextStyle(fontSize: screenWidth * 0.008)),
                                  ),
                                ],
                              ),
                            ),
                            // List of USRs
                            Container(
                              width: screenWidth,
                              margin: EdgeInsets.only(top: screenHeight * 0.03),
                              child: Column(
                                children: [
                                  // User List
                                  Column(
                                    children: List.generate(
                                      paginatedItems.length, // Use paginatedItems instead of users
                                      (index) => Container(
                                        width: screenWidth * 0.75,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50),
                                            side: BorderSide(
                                              color: Colors.black12,
                                              width: 2,
                                            ),
                                          ),
                                          margin: EdgeInsets.symmetric(vertical: 10),
                                          child: Container(
                                            margin: EdgeInsets.symmetric(vertical: 10),
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    color: Colors.black,
                                                  ),
                                                  margin: EdgeInsets.only(left: screenWidth * 0.02),
                                                  height: screenHeight * 0.055,
                                                  width: screenWidth * 0.028,
                                                  child: ClipOval(
                                                    child: Image.network(
                                                      paginatedItems[index].picture,
                                                      fit: BoxFit.fill,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        // Fallback for image loading errors
                                                        return Icon(Icons.person, color: Colors.white);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                // Name
                                                Container(
                                                  width: screenWidth * 0.10,
                                                  margin: EdgeInsets.only(left: screenWidth * 0.01),
                                                  child: Center(
                                                    child: Text(
                                                      paginatedItems[index].name,
                                                      style: TextStyle(fontSize: screenWidth * 0.008),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: screenWidth * 0.1,
                                                  margin: EdgeInsets.only(left: screenWidth * 0.018),
                                                  child: Center(
                                                    child: Text(
                                                      paginatedItems[index].email,
                                                      style: TextStyle(fontSize: screenWidth * 0.008),
                                                    ),
                                                  ),
                                                ),
                                                // Chanel
                                                Container(
                                                  width: screenWidth * 0.08,
                                                  margin: EdgeInsets.only(left: screenWidth * 0.018),
                                                  child: Center(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return Dialog(
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    border: Border.all(color: Colors.black12),
                                                                    borderRadius: BorderRadius.circular(20),
                                                                  ),
                                                                  width: screenWidth * 0.4,
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min, // Make dialog size fit content
                                                                    children: [
                                                                      // User info part
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                                                          color: Colors.white,
                                                                        ),
                                                                        height: screenHeight * 0.265,
                                                                        width: screenWidth * 0.45,
                                                                        child: SizedBox(
                                                                          height: screenHeight * 0.1,
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            children: [
                                                                              Center(
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                  height: screenHeight * 0.075,
                                                                                  width: screenWidth * 0.04,
                                                                                  margin: EdgeInsets.only(top: screenHeight * 0.03),
                                                                                  child: ClipOval(
                                                                                    child: Image.network(
                                                                                      paginatedItems[index].channelPhotoUrl ,
                                                                                       
                                                                                        
                                                                                      fit: BoxFit.cover,
                                                                                      errorBuilder: (context, error, stackTrace) {
                                                                                        return Icon(Icons.person, color: Colors.white);
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                margin: EdgeInsets.only(top: screenHeight * 0.02),
                                                                                child: Text(
                                                                                  paginatedItems[index].chanel,
                                                                                  style: TextStyle(fontSize: screenHeight * 0.02),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                margin: EdgeInsets.only(left: screenWidth * 0.1, top: screenHeight * 0.03),
                                                                                child: Center(
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Column(
                                                                                        children: [
                                                                                          Text("follows  ", style: TextStyle(fontSize: screenHeight * 0.018)),
                                                                                          Container(
                                                                                            margin: EdgeInsets.only(top: screenHeight * 0.005),
                                                                                            child: Text(
                                                                                              "${paginatedItems[index].following}", 
                                                                                              style: TextStyle(fontSize: screenHeight * 0.015)
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Container(
                                                                                        margin: EdgeInsets.only(left: screenWidth * 0.02),
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Text("followers ", style: TextStyle(fontSize: screenHeight * 0.018)),
                                                                                            Container(
                                                                                              margin: EdgeInsets.only(top: screenHeight * 0.005),
                                                                                              child: Text(
                                                                                                "${paginatedItems[index].followers}", 
                                                                                                style: TextStyle(fontSize: screenHeight * 0.015)
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        margin: EdgeInsets.only(left: screenWidth * 0.02),
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Text("likes ", style: TextStyle(fontSize: screenHeight * 0.018)),
                                                                                            Container(
                                                                                              margin: EdgeInsets.only(top: screenHeight * 0.005),
                                                                                              child: Text(
                                                                                                "${paginatedItems[index].likes}", 
                                                                                                style: TextStyle(fontSize: screenHeight * 0.015)
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        margin: EdgeInsets.only(left: screenWidth * 0.02),
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Text("pods ", style: TextStyle(fontSize: screenHeight * 0.018)),
                                                                                            Container(
                                                                                              margin: EdgeInsets.only(top: screenHeight * 0.005),
                                                                                              child: Text(
                                                                                                "${paginatedItems[index].pods}", 
                                                                                                style: TextStyle(fontSize: screenHeight * 0.015)
                                                                                              ),
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
                                                                      // Close button
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                        child: Text("Close"),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        });
                                                      },
                                                      child: Text(
                                                        paginatedItems[index].chanel,
                                                        style: TextStyle(fontSize: screenWidth * 0.008),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: screenWidth * 0.06,
                                                  margin: EdgeInsets.only(left: screenWidth * 0.018),
                                                  child: Center(
                                                    child: Text(
                                                      paginatedItems[index].signupd,
                                                      style: TextStyle(fontSize: screenWidth * 0.008),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: screenWidth * 0.10,
                                                  margin: EdgeInsets.only(left: screenWidth * 0.015),
                                                  child: Center(
                                                    child: Text(
                                                      paginatedItems[index].country,
                                                      style: TextStyle(fontSize: screenWidth * 0.008),
                                                    ),
                                                  ),
                                                ),
                                                // Age
                                                Container(
                                                  width: screenWidth * 0.02,
                                                  margin: EdgeInsets.only(left: screenWidth * 0.018),
                                                  child: Center(
                                                    child: Text(
                                                      paginatedItems[index].age,
                                                      style: TextStyle(fontSize: screenWidth * 0.008),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(left: screenWidth * 0.04),
                                                  child: Center(
                                                    child: IconButton(
                                                      onPressed: () {
                                                        // Add report functionality
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Text("Report User"),
                                                              content: Text("Do you want to report this user?"),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: Text("Cancel"),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () {
                                                                    // Add report logic here
                                                                    Navigator.of(context).pop();
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                      SnackBar(content: Text("User reported")),
                                                                    );
                                                                  },
                                                                  child: Text("Report"),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      icon: Icon(Icons.warning),
                                                    ),
                                                  ),
                                                ),
                                                // Delete Button
                                                Container(
                                                  margin: EdgeInsets.only(left: screenWidth * 0.02),
                                                  child: Center(
                                                    child: IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Text("Delete User"),
                                                              content: Text("Are you sure you want to delete this user?"),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: Text("Cancel"),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () {
                                                                    // Remove from the main list, not just paginated view
                                                                    final userToDelete = paginatedItems[index];
                                                                    setState(() {
                                                                      users.remove(userToDelete);
                                                                      // If page becomes empty after deletion, go to previous page
                                                                      if (paginatedItems.isEmpty && currentPage > 1) {
                                                                        currentPage--;
                                                                      }
                                                                    });
                                                                    Navigator.of(context).pop();
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                      SnackBar(content: Text("User deleted")),
                                                                    );
                                                                  },
                                                                  child: Text("Delete"),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      icon: Icon(Icons.delete),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Pagination controls
                                  SizedBox(height: 20),
                                  paginationControls(screenWidth),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class USR {
  final String firstName;
  final String lastName;
  final String email;
  late final String picture;
  late final String signupd;
  final String country;
  final String age;
  final String chanel;
final String  channelPhotoUrl;
final int followers;
final int following;
final int likes;
final int pods;
final String userId;


  // Computed property to get full name
  String get name => '$firstName $lastName'.trim();

  USR({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.country,
    required this.signupd,
    required this.picture,
    required this.age,
    required this.chanel, required this.channelPhotoUrl, 
    required this.followers, 
    required this.following, 
    required this.likes, 
    required this.pods, 
    required this.userId,
  });
  
}