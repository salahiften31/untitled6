import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled6/home.dart';

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
        List<Report> reports = [
];
    List <Chanel> chan =[];
// Create a StreamSubscription class variable
StreamSubscription<QuerySnapshot>? _reportsSubscription;

// Add this to your dispose method to clean up
@override
void dispose() {
  _reportsSubscription?.cancel();
  super.dispose();
}

// Replace fetchReports with this real-time version
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
        
        // Only process if both fields exist
        if (data.containsKey('text') && data.containsKey('userss')) {
          String message = data['text'] ?? '';
          String userId = data['userss'] ?? '';
          String name = 'Unknown User';
          
          // Only proceed if we have valid values
          if (message.isNotEmpty && userId.isNotEmpty) {
            try {
              // Get the user document directly using the ID
              final userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get();
              
              if (userDoc.exists) {
                final userData = userDoc.data();
                if (userData != null) {
                  String firstName = userData['firstName'] ?? '';
                  String lastName = userData['lastName'] ?? '';
                  
                  // Remove quotes if present
                  if (firstName.startsWith('"') && firstName.endsWith('"')) {
                    firstName = firstName.substring(1, firstName.length - 1);
                  }
                  if (lastName.startsWith('"') && lastName.endsWith('"')) {
                    lastName = lastName.substring(1, lastName.length - 1);
                  }
                  
                  name = '$firstName $lastName'.trim();
                  
                  // If name is still empty, use email as fallback
                  if (name.isEmpty) {
                    String email = userData['email'] ?? '';
                    if (email.startsWith('"') && email.endsWith('"')) {
                      email = email.substring(1, email.length - 1);
                    }
                    name = email.isNotEmpty ? email : 'Unknown User';
                  }
                }
              }
            } catch (e) {
              print("Error fetching user data for ID $userId: $e");
            }
            
            // Add to the temporary list
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

// Update your initState
@override
void initState() {
  super.initState();
  fetchPods();
  fetchChanel();
  setupReportsRealtime();  // Changed from fetchReports()
}
    Future<void> fetchPods() async {
  try {
  
    final querySnapshot = await FirebaseFirestore.instance
      .collection('podcasts')
      .where('report', isGreaterThanOrEqualTo: 30)
      .get();
    
    print("Found ${querySnapshot.docs.length} pods");
    
    final podsList = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Pod(
        name: data['name'] ?? '',
        picture: data['urlPhoto'] ?? '',
        report: data['report'] ?? '0', 
        likes: data['likes'] ?? '0', 
        comments: data['comments'] ?? '0', 
        lis: data['vue'] ?? '0', 
       user : data['idUser'] ?? '0',
  
        id: data['id'] ?? '0', 
      );
    }).toList();

    setState(() {
      pods = podsList;
    });
    
    print("Pods set in state: ${pods.length}");
  } catch (e) {
    // ignore: avoid_print
    print("Error fetching pods: $e");
  }
}

    Future<void> fetchChanel() async {
  try {
  
    final querySnapshot = await FirebaseFirestore.instance
      .collection('channels')
      .where('report', isGreaterThanOrEqualTo: 30)
      .get();
      
    final chanList = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Chanel(
        name: data['name'] ?? '',
        pic: data['photoUrl'] ?? '',
        report: data['report'] ?? '0', 
        id: data['id'] ?? '0', 
         uid: data['userId'] ?? '0', 
      );
    }).toList();

    setState(() {
      chan = chanList;
    });
    
  } catch (e) {
    // ignore: avoid_print
    print("Error fetching pods: $e");
  }
}
Future<void> reportPod(String userId ,String podname) async {
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
   // Predefined message with corrected text
String predefinedMessage = "$podname has been removed from our platform following community reports. This content violated our community guidelines, which are designed to ensure a safe and positive experience for all users. Thank you for helping maintain the quality and integrity of our community.";
    
    // Add report to Firestore
    await FirebaseFirestore.instance.collection('reports').doc(reportId).set({
      'reportId': reportId,
      'userId': userId,
      'message': predefinedMessage,
      'reportedAt': FieldValue.serverTimestamp(),
       // To identify that an admin made this report
    });
    
    // Close loading indicator
    Navigator.of(context, rootNavigator: true).pop();
    
    // Show success message
 
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

    // Initialize Supabase client    
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
          
      setState(() {
        pods.removeWhere((pod) => pod.id == id);
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("podcast deleted")),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("podcast not found")),
      );
    }
  } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error deleting podcast: $e")),
    );
  }
}
Future<void> reportcha(String userId ) async {
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
   // Predefined message with corrected text
String predefinedMessage = "you channel has been removed from our platform following community reports. This content violated our community guidelines, which are designed to ensure a safe and positive experience for all users. Thank you for helping maintain the quality and integrity of our community.";
    
    // Add report to Firestore
    await FirebaseFirestore.instance.collection('reports').doc(reportId).set({
      'reportId': reportId,
      'userId': userId,
      'message': predefinedMessage,
      'reportedAt': FieldValue.serverTimestamp(),
       // To identify that an admin made this report
    });
    
    // Close loading indicator
    Navigator.of(context, rootNavigator: true).pop();
    
    // Show success message
 
  } catch (e) {
    // Close loading indicator
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
                        color:  Colors.blue[700] ,
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
          SizedBox(child: 
             SingleChildScrollView(
               child: Container(
                 child: Column(
                  
                   children: [
                     Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black12,width: 4),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                      
                      
                      ),
                      
                      
                      height: screenHeight*0.9,
                                 margin: EdgeInsets.only(left: screenWidth*0.02),
                               width: screenWidth*0.3,
                               child: ListView(children: [Center(child: Text("Reported chanells",style: TextStyle(fontSize: screenHeight*0.025),),),
                               Column(children: List.generate(chan.length, (index)=> Container(
                                 margin: EdgeInsets.only(top: screenHeight*0.02),
                                 child: Card(
                      shape:RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                 // Set your desired radius here
                              ),
                      
                      child: Container(
                                padding: EdgeInsets.only(right: screenWidth*0.01),
                                 decoration: BoxDecoration(border: Border.all(color: Colors.black12,width: 3),
                                 borderRadius:BorderRadius.circular(50) ),
                      height: screenHeight*0.08,
                       child: Row (children: [
                         Container(
                               
                          margin: EdgeInsets.only(left: screenWidth*0.02),
                        height: screenHeight*0.055,
                        width: screenWidth*0.03,
                           child: ClipOval(
                                                  child: Image.network(chan[index].pic, fit: BoxFit.fill),
                                                ),
                         ), 
                                              Container( margin: EdgeInsets.only(left: screenWidth*0.02),  child: Text(chan[index].name,style: TextStyle(fontSize: screenHeight*0.02),)),
                                              Spacer(),
                                              Container( margin: EdgeInsets.only(left: screenWidth*0.05),  child: IconButton(onPressed: (){
                        showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Confirm delete"),
                                                  content:
                                                      Text("Are you sure you want to delete?"),
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
                                                      //  deleteUserChannel(chan[index].uid);
                                                       Navigator.of(context).pop();
                                                       deleteUserChannel(chan[index].uid);
                                                       fetchChanel();
                                                      },
                                                      child: Text("delete"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                              }, icon: Icon(Icons.delete_outline)),)
                        ],)
                        
                      ),
                      
                           
                                    ),
                               ),),)
                               
                               
                               
                               
                               ],),
                               
                               
                               
                               ),
                               Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black12,width: 4),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                      
                      ),
                      
                      
                      height: screenHeight*0.9,
                                 margin: EdgeInsets.only(left: screenWidth*0.16),
                               width: screenWidth*0.3,
                               child: ListView(children: [Center(child: Text("Reported Podcasts",style: TextStyle(fontSize: screenHeight*0.025),),),
                               Column(children: List.generate(pods.length, (index)=> Container(
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
                                 margin: EdgeInsets.only(left: screenWidth*0.1),
                                          child: IconButton(
                                            onPressed: () {
                                                    showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Confirm delete"),
                                                  content:
                                                      Text("Are you sure you want to delete?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text("Cancel"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        
                                                  reportPod(pods[index].id,pods[index].name);
                                                  deletePod(pods[index].id);
                                                       Navigator.of(context).pop();
                                                       fetchPods();
                                                      },
                                                      child: Text("delete"),
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
                                  ),),)
                               
                               
                               
                               
                               ],),
                               ),
                     
                               
                               ],),
                               Container(height: screenHeight*0.02, ),
                                                   Container(
                                                    margin: EdgeInsets.only(left: screenWidth*0.02),
                 width: screenWidth*0.77,
                 height: screenHeight *0.6,
                 
                decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black12, width: 3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                 child: ListView(
children: [
Container(margin: EdgeInsets.only(left: screenWidth*0.02 ),width: screenWidth*0.08,   child:  Text("Users Reports" ,style: TextStyle(fontSize: screenHeight*0.025) ),),
 Column( children: List.generate(reports.length, (index)=> Container(
child: Card(
  child: ListTile(
  leading: Icon(Icons.mail_outlined),
  title: Text(reports[index].name),
  subtitle: Text(reports[index].message),
  
  
  
  ),
)




 )
 )
 )

],


                 ),
                           )
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
 Pod ({
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
final int report ;
final String uid ;
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