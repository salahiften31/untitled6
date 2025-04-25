import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled6/home.dart';
import 'dart:math' as Math;

class Reported extends StatefulWidget {
  const Reported({super.key});

  @override
  State<Reported> createState() => _ReportedState();
}

class _ReportedState extends State<Reported> {
  bool isHovered = false;
  bool isHovered1 = false;
  bool isHovered2 = false;
  bool isHovered3 = false;
  bool isHovered4 = false;
  List<Pod> pods = [];
  List<Report> reports = [];
  List<Chanel> chan = [];
  
  // Create StreamSubscription class variables for all realtime data
  StreamSubscription<QuerySnapshot>? _reportsSubscription;
  StreamSubscription<QuerySnapshot>? _podsSubscription;
  StreamSubscription<QuerySnapshot>? _chanelSubscription;

  // Add this to your dispose method to clean up all subscriptions
  @override
  void dispose() {
    _reportsSubscription?.cancel();
    _podsSubscription?.cancel();
    _chanelSubscription?.cancel();
    super.dispose();
  }

  // Improved real-time setup for reports
  void setupReportsRealtime() {
    // Cancel any existing subscription
    _reportsSubscription?.cancel();
    
    // Listen to reports collection in real-time
    _reportsSubscription = FirebaseFirestore.instance
      .collection('reports')
      .snapshots()
      .listen((snapshot) async {
        print("Got reports update with ${snapshot.docs.length} documents");
        
        // Create a temporary list to avoid multiple setState calls
        List<Report> updatedReports = [];
        
        // Process each document
        for (var doc in snapshot.docs) {
          final data = doc.data();
          
          // Print out the entire document for debugging
          print("Report document: ${doc.id} - $data");
          
          // Only process if both fields exist
          if (data.containsKey('text') && data.containsKey('userss')) {
            String message = data['text'] ?? '';
            String userId = data['userss'] ?? '';
            print("Processing report - message: $message, userss: $userId");
            
            String name = 'Unknown User';
            
            // Only proceed if we have valid values
            if (message.isNotEmpty && userId.isNotEmpty) {
              try {
                // First approach: Try direct document lookup
                print("Attempting to fetch user with ID: $userId");
                final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .get();
                
                print("User doc exists: ${userDoc.exists}");
                
                if (userDoc.exists) {
                  final userData = userDoc.data();
                  print("Found user data: $userData");
                  if (userData != null) {
                    String firstName = userData['firstName'] ?? '';
                    String lastName = userData['lastName'] ?? '';
                    name = '$firstName $lastName'.trim();
                    
                    if (name.isEmpty) {
                      String email = userData['email'] ?? '';
                      name = email.isNotEmpty ? email : 'Unknown User';
                    }
                  }
                } else {
                  // Second approach: Try querying users collection
                  print("Document lookup failed. Trying query...");
                  final querySnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .get();
                  
                  print("Total users in collection: ${querySnapshot.docs.length}");
                  
                  // Print first few user IDs for debugging
                  for (int i = 0; i < Math.min(5, querySnapshot.docs.length); i++) {
                    print("User ${i+1} ID: ${querySnapshot.docs[i].id}");
                  }
                  
                  // Try to find a match
                  bool foundUser = false;
                  for (var userDoc in querySnapshot.docs) {
                    print("Checking user: ${userDoc.id}");
                    if (userDoc.id == userId) {
                      print("Found matching user by ID");
                      foundUser = true;
                      final userData = userDoc.data();
                      String firstName = userData['firstName'] ?? '';
                      String lastName = userData['lastName'] ?? '';
                      name = '$firstName $lastName'.trim();
                      
                      if (name.isEmpty) {
                        String email = userData['email'] ?? '';
                        name = email.isNotEmpty ? email : 'Unknown User';
                      }
                      break;
                    }
                    
                    // Also check if userId matches a userId field
                    final userData = userDoc.data();
                    if (userData['userId'] == userId) {
                      print("Found matching user by userId field");
                      foundUser = true;
                      String firstName = userData['firstName'] ?? '';
                      String lastName = userData['lastName'] ?? '';
                      name = '$firstName $lastName'.trim();
                      
                      if (name.isEmpty) {
                        String email = userData['email'] ?? '';
                        name = email.isNotEmpty ? email : 'Unknown User';
                      }
                      break;
                    }
                  }
                  
                  if (!foundUser) {
                    print("Could not find user with ID: $userId");
                  }
                }
              } catch (e) {
                print("Error fetching user data: $e");
              }
              
              // Add to the temporary list regardless of whether we found a name
              print("Adding report with name: $name, message: $message");
              updatedReports.add(Report(
                name: name,
                message: message,
              ));
            }
          }
        }
        
        // Update state once with all the processed reports
        if (mounted) {
          setState(() {
            reports = updatedReports;
          });
        }
        
        print("Real-time reports updated: ${reports.length}");
      },
      onError: (error) {
        print("Error listening to reports: $error");
      });
  }

  // New real-time setup for pods
  void setupPodsRealtime() {
    // Cancel any existing subscription
    _podsSubscription?.cancel();
    
    // Listen to podcasts collection in real-time
    _podsSubscription = FirebaseFirestore.instance
      .collection('podcasts')
      .where('report', isGreaterThanOrEqualTo: 30)
      .snapshots()
      .listen((snapshot) {
        print("Got pods update with ${snapshot.docs.length} documents");
        
        final podsList = snapshot.docs.map((doc) {
          final data = doc.data();
          return Pod(
            name: data['name'] ?? '',
            picture: data['urlPhoto'] ?? '',
            report: data['report'] ?? '0', 
            likes: data['likes'] ?? '0', 
            comments: data['comments'] ?? '0', 
            lis: data['vue'] ?? '0', 
            user: data['idUser'] ?? '0',
            id: data['id'] ?? '0', 
          );
        }).toList();

        if (mounted) {
          setState(() {
            pods = podsList;
          });
        }
        
        print("Real-time pods updated: ${pods.length}");
      },
      onError: (error) {
        print("Error listening to pods: $error");
      });
  }

  // New real-time setup for channels
  void setupChanelRealtime() {
    // Cancel any existing subscription
    _chanelSubscription?.cancel();
    
    // Listen to channels collection in real-time
    _chanelSubscription = FirebaseFirestore.instance
      .collection('channels')
      .where('report', isGreaterThanOrEqualTo: 30)
      .snapshots()
      .listen((snapshot) {
        print("Got channels update with ${snapshot.docs.length} documents");
        
        final chanList = snapshot.docs.map((doc) {
          final data = doc.data();
          return Chanel(
            name: data['name'] ?? '',
            pic: data['photoUrl'] ?? '',
            report: data['report'] ?? '0', 
            id: data['id'] ?? '0', 
            uid: data['userId'] ?? '0', 
          );
        }).toList();

        if (mounted) {
          setState(() {
            chan = chanList;
          });
        }
        
        print("Real-time channels updated: ${chan.length}");
      },
      onError: (error) {
        print("Error listening to channels: $error");
      });
  }

  // Update initState to use all real-time methods
  @override
  void initState() {
    super.initState();
    setupPodsRealtime();
    setupChanelRealtime();
    setupReportsRealtime();
  }

  Future<void> reportPod(String userId, String podname) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
      
      // Create a unique reportId
      String reportId = FirebaseFirestore.instance.collection('reports').doc().id;
      
      // Predefined message
      String predefinedMessage = "$podname has been removed from our platform following community reports. This content violated our community guidelines, which are designed to ensure a safe and positive experience for all users. Thank you for helping maintain the quality and integrity of our community.";
      
      // Add report to Firestore
      await FirebaseFirestore.instance.collection('reports').doc(reportId).set({
        'reportId': reportId,
        'userId': userId,
        'message': predefinedMessage,
        'reportedAt': FieldValue.serverTimestamp(),
      });
      
      // Close loading indicator
      Navigator.of(context, rootNavigator: true).pop();
      
    } catch (e) {
      // Close loading indicator
      Navigator.of(context, rootNavigator: true).pop();
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error reporting user: ${e.toString()}")),
      );
      print("Error reporting user: $e");
    }
  }

  Future<void> deleteUserChannel(String chId) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // Step 1: Find and delete the channel document
      final channelDocs = await FirebaseFirestore.instance
          .collection('channels')
          .where('userId', isEqualTo: chId)
          .get();
      
      for (var doc in channelDocs.docs) {
        await doc.reference.delete();
        print('Channel deleted from Firestore: ${doc.id}');
      }

      // Step 2: Find and delete all podcasts by this user
      final podcastDocs = await FirebaseFirestore.instance
          .collection('podcasts')
          .where('idUser', isEqualTo: chId)
          .get();
      
      for (var doc in podcastDocs.docs) {
        // Delete the podcast document from Firestore
        await doc.reference.delete();
      }
      
      final playlisDocs = await FirebaseFirestore.instance
          .collection('podcasts')
          .where('idUser', isEqualTo: chId)
          .get();
      
      for (var doc in playlisDocs.docs) {
        // Delete the podcast document from Firestore
        await doc.reference.delete();
      }
      
      // Close loading indicator and show success message
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Channel and associated podcasts deleted successfully")),
      );
    } catch (e) {
      // Close loading indicator and show error message
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting channel: ${e.toString()}")),
      );
      print("Error deleting channel: $e");
    }
  }

  Future<void> deletePod(String id) async {
    try {
      // First, query for the document with the matching adcode
      final querySnapshot = await FirebaseFirestore.instance
          .collection('podcasts')
          .where('id', isEqualTo: id)
          .get();
      
      // Check if we found a document with that id
      if (querySnapshot.docs.isNotEmpty) {
        // Delete the document using its actual document ID
        await FirebaseFirestore.instance
            .collection('podcasts')
            .doc(querySnapshot.docs.first.id)
            .delete();
            
        // We don't need to update state manually since real-time listener will handle it
        
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Podcast deleted")),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Podcast not found")),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting podcast: $e")),
      );
    }
  }

  Future<void> reportcha(String userId) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
      
      // Create a unique reportId
      String reportId = FirebaseFirestore.instance.collection('reports').doc().id;
      
      // Predefined message
      String predefinedMessage = "Your channel has been removed from our platform following community reports. This content violated our community guidelines, which are designed to ensure a safe and positive experience for all users. Thank you for helping maintain the quality and integrity of our community.";
      
      // Add report to Firestore
      await FirebaseFirestore.instance.collection('reports').doc(reportId).set({
        'reportId': reportId,
        'userId': userId,
        'message': predefinedMessage,
        'reportedAt': FieldValue.serverTimestamp(),
      });
      
      // Close loading indicator
      Navigator.of(context, rootNavigator: true).pop();
      
    } catch (e) {
      // Close loading indicator
      Navigator.of(context, rootNavigator: true).pop();
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
                        color: isHovered1 ? Colors.blue[700] : Colors.white,
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
                        color: Colors.blue[700],
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
                                        MaterialPageRoute(
                                          builder: (context) => Home(),
                                        ),
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
                            child: Icon(Icons.logout),
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
          SizedBox(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12, width: 4),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          height: screenHeight * 0.9,
                          margin: EdgeInsets.only(left: screenWidth * 0.02),
                          width: screenWidth * 0.3,
                          child: ListView(
                            children: [
                              Center(
                                child: Text(
                                  "Reported Channels",
                                  style: TextStyle(fontSize: screenHeight * 0.025),
                                ),
                              ),
                              Column(
                                children: List.generate(
                                  chan.length,
                                  (index) => Container(
                                    margin: EdgeInsets.only(top: screenHeight * 0.02),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.only(right: screenWidth * 0.01),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black12, width: 3),
                                          borderRadius: BorderRadius.circular(50)
                                        ),
                                        height: screenHeight * 0.08,
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: screenWidth * 0.02),
                                              height: screenHeight * 0.055,
                                              width: screenWidth * 0.03,
                                              child: ClipOval(
                                                child: Image.network(chan[index].pic, fit: BoxFit.fill),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: screenWidth * 0.02),
                                              child: Text(
                                                chan[index].name,
                                                style: TextStyle(fontSize: screenHeight * 0.02),
                                              )
                                            ),
                                            Spacer(),
                                            Container(
                                              margin: EdgeInsets.only(left: screenWidth * 0.05),
                                              child: IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text("Confirm delete"),
                                                        content: Text("Are you sure you want to delete?"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text("Cancel"),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              reportcha(chan[index].uid);
                                                              Navigator.of(context).pop();
                                                              deleteUserChannel(chan[index].uid);
                                                            },
                                                            child: Text("Delete"),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: Icon(Icons.delete_outline)
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12, width: 4),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          height: screenHeight * 0.9,
                          margin: EdgeInsets.only(left: screenWidth * 0.16),
                          width: screenWidth * 0.3,
                          child: ListView(
                            children: [
                              Center(
                                child: Text(
                                  "Reported Podcasts",
                                  style: TextStyle(fontSize: screenHeight * 0.025),
                                ),
                              ),
                              Column(
                                children: List.generate(
                                  pods.length,
                                  (index) => Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black12, width: 3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    margin: EdgeInsets.only(top: screenHeight * 0.04),
                                    width: screenWidth * 0.28,
                                    height: screenHeight * 0.15,
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: screenWidth * 0.025),
                                          height: screenHeight * 0.065,
                                          width: screenWidth * 0.03,
                                          child: ClipOval(
                                            child: Image.network(pods[index].picture, fit: BoxFit.fill),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: screenWidth * 0.015),
                                          width: screenWidth * 0.06,
                                          child: Text(
                                            pods[index].name,
                                            style: TextStyle(fontSize: screenWidth * 0.01),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: screenWidth * 0.1),
                                          child: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Confirm delete"),
                                                    content: Text("Are you sure you want to delete?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text("Cancel"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          reportPod(pods[index].id, pods[index].name);
                                                          deletePod(pods[index].id);
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text("Delete"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(Icons.delete_outline),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(height: screenHeight * 0.02),
                    Container(
                      margin: EdgeInsets.only(left: screenWidth * 0.02),
                      width: screenWidth * 0.77,
                      height: screenHeight * 0.6,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListView(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: screenWidth * 0.02),
                            width: screenWidth * 0.08,
                            child: Text(
                              "Users Reports",
                              style: TextStyle(fontSize: screenHeight * 0.025),
                            ),
                          ),
                          Column(
                            children: List.generate(
                              reports.length,
                              (index) => Container(
                                child: Card(
                                  child: ListTile(
                                    leading: Icon(Icons.mail_outlined),
                                    title: Text(reports[index].name),
                                    subtitle: Text(reports[index].message),
                                  ),
                                ),
                              ),
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
        ],
      ),
    );
  }
}

class Pod {
  final String picture;
  final String name;
  final int report;
  final int likes;
  final int comments;
  final int lis;
  final String id;
  final String user;
  
  Pod({
    required this.comments,
    required this.likes,
    required this.lis,
    required this.picture,
    required this.name,
    required this.report,
    required this.user,
    required this.id,
  });
}

class Chanel {
  final String name;
  final String id;
  final String pic;
  final int report;
  final String uid;

Chanel ({
required this.id,
required this.name,
required this.report,
required this.pic,
required this.uid,

});



}

class Report {
final String name;
final String message;


Report ({

required this.name,

required this.message,

});



}