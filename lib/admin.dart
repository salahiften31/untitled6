import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled6/home.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  bool isHovered = false;
  bool isHovered1 = false;
  bool isHovered2 = false;
  bool isHovered3 = false;
  bool isHovered4 = false;
  final TextEditingController verif = TextEditingController();
  final TextEditingController adcodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<Item> items = [];
  int currentPage = 1;
  final int itemsPerPage = 2;
    List<Item> filteredAdmins = [];
TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAdmins();
      searchController.addListener(() {
    filterAdmins();
  });
  }
  void filterAdmins() {
  String searchTerm = searchController.text.toLowerCase();
  setState(() {
    if (searchTerm.isEmpty) {
      filteredAdmins = List.from(items);
    } else {
      filteredAdmins = items.where((admin) {
        return admin.name.toLowerCase().contains(searchTerm)  ;
      }).toList();
    }
    // Reset to first page when search changes
    currentPage = 1;
  });
}
Future<void> deleteAdmin(String adcode) async {
  try {
    // First, query for the document with the matching adcode
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Admin')
        .where('adcode', isEqualTo: adcode)
        .get();
    
    // Check if we found a document with that adcode
    if (querySnapshot.docs.isNotEmpty) {
      // Delete the document using its actual document ID
      await FirebaseFirestore.instance
          .collection('Admin')
          .doc(querySnapshot.docs.first.id)
          .delete();
          
      setState(() {
        items.removeWhere((pod) => pod.code == adcode);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Admin deleted")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Admin not found")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error deleting Admin: $e")),
    );
  }
}

  Future<void> fetchAdmins() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('Admin').get();
      final adminList = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Item(
          name: data['name'] ?? '',
          code: data['adcode'] ?? '',
          rank: data['rank'] ?? '',
        );
      }).toList();

      setState(() {
        items = adminList;
        filteredAdmins = adminList;
      });

      
    // ignore: empty_catches
    } catch (e) {
  
    }
  }
List<Item> get paginatedItems {
  int start = (currentPage - 1) * itemsPerPage;
  int end = start + itemsPerPage;
  if (filteredAdmins.isEmpty) return [];
  return filteredAdmins.sublist(start, end > filteredAdmins.length ? filteredAdmins.length : end);
}

int get totalPages => (filteredAdmins.length / itemsPerPage).ceil();

  Widget paginationControls(double screenWidth) {
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
Future<void> showDeleteConfirmationDialog(String adminCode) async {
  final TextEditingController verificationController = TextEditingController();
  String? errorMessage;
  
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;
          
          return Dialog(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35)
              ),
              width: screenWidth * 0.3,
              height: screenHeight * 0.35,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.05),
                    child: Text(
                      "Confirm Admin Deletion",
                      style: TextStyle(
                        fontSize: screenWidth * 0.015,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.03),
                    width: screenWidth * 0.25,
                    child: Text(
                      "Enter verification code to delete this admin",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: screenWidth * 0.01),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.03),
                    width: screenWidth * 0.25,
                    child: TextField(
                      controller: verificationController,
                      decoration: InputDecoration(
                        hintText: "Verification code",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorText: errorMessage,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth * 0.1,
                          height: screenHeight * 0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey[300],
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: screenWidth * 0.01,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Container(
                          width: screenWidth * 0.1,
                          height: screenHeight * 0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(0xFF4b68ff),
                          ),
                          child: MaterialButton(
                            onPressed: () async {
                              if (verificationController.text.trim() == "slh3110") {
                                Navigator.of(context).pop();
                                // Call the deleteAdmin method with the admin code
                                await deleteAdmin(adminCode);
                              } else {
                                setDialogState(() {
                                  errorMessage = "Invalid verification code";
                                });
                              }
                            },
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.01,
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
          );
        },
      );
    },
  );
}
// Inside your _AdminState class, add a new controller for the name field:
final TextEditingController nameController = TextEditingController();

// Then, update the showAddAdminDialog method:
void showAddAdminDialog() {
  String? dialogErrorMessage;
  
  showDialog(
    context: context, 
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;
          
          return Dialog(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35)
              ),
              width: screenWidth * 0.4,
              // Increase height to accommodate the new field
              height: screenHeight * 0.55,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.08),
                    width: screenWidth * 0.3,
                    child: TextField(
                      controller: verif,
                      decoration: InputDecoration(
                        hintText: "creators code",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorText: dialogErrorMessage
                      ),
                    ),
                  ),
                  // New field for admin name
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.03),
                    width: screenWidth * 0.3,
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Admin name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.03),
                    width: screenWidth * 0.3,
                    child: TextField(
                      controller: adcodeController,
                      decoration: InputDecoration(
                        hintText: "New admin code",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.03),
                    width: screenWidth * 0.3,
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "New admin password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.05, left: screenWidth * 0.14),
                    child: Row(
                      children: [
                        Container(
                          width: screenWidth * 0.1,
                          height: screenHeight * 0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(0xFF4b68ff),
                          ),
                          child: MaterialButton(
                            onPressed: () async {
                              // Validate inputs
                              if (verif.text.trim().isEmpty || 
                                  nameController.text.trim().isEmpty ||
                                  adcodeController.text.trim().isEmpty || 
                                  passwordController.text.trim().isEmpty) {
                                setDialogState(() {
                                  dialogErrorMessage = "All fields are required";
                                });
                                return;
                              }
                              
                              if (verif.text.trim() == "slh3110") {
                                try {
                                  // Check if admin already exists
                                  final adminCode = adcodeController.text.trim();
                                  final querySnapshot = await FirebaseFirestore.instance
                                    .collection('Admin')
                                    .where('adcode', isEqualTo: adminCode)
                                    .get();
                                  
                                  if (querySnapshot.docs.isNotEmpty) {
                                    // Admin already exists
                                    setDialogState(() {
                                      dialogErrorMessage = "Admin with this code already exists";
                                    });
                                    return;
                                  }
                                  
                                  // Add new admin to Firestore
                                  await FirebaseFirestore.instance.collection('Admin').add({
                                    'name': nameController.text.trim(), // Using the actual name field
                                    'adcode': adminCode,
                                    'passw': passwordController.text.trim(),
                                    'rank': 'mod', // Set rank as "mod"
                                  });
                                  
                                  // Close dialog on success
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                  
                                  // Show success message
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('New moderator added successfully'))
                                  );
                                  
                                  // Refresh admin list
                                  fetchAdmins();
                                  
                                  // Clear text fields
                                  verif.clear();
                                  nameController.clear();
                                  adcodeController.clear();
                                  passwordController.clear();
                                  
                                } catch (e) {
                                  setDialogState(() {
                                    dialogErrorMessage = "Error adding admin: ${e.toString()}";
                                  });
                                }
                              } else {
                                // Error case - update error message
                                setDialogState(() {
                                  dialogErrorMessage = "Wrong creator code";
                                });
                              }
                            },
                            child: Text(
                              "Add admin",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.010,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      );
    }
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
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          // Handle Admins button press
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
          Expanded(
            child: Container(
              height: screenHeight,
              color: Colors.white,
              child: SingleChildScrollView( // Enable scrolling
                child: SizedBox(
                  width: screenWidth * 0.8,
                  child: Column(
                    children: [
                      // Search Bar
                      Center(
                        child: Container(
                         
                          margin: EdgeInsets.only(top: 10),
                          width: screenWidth*0.3,
                          child: Center(
                            child: TextField(
  controller: searchController,
  decoration: InputDecoration(
    hintText: "Search Admin",
    suffixIcon: IconButton(
      onPressed: () {
        searchController.clear();
      },
      icon: Icon(Icons.clear),
    ),
    prefixIcon: Icon(Icons.search),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
    ),
  ),
)
                          ),
                        ),
                      ),
                      Container( 
                        margin: EdgeInsets.only(top: screenHeight*0.14,left: screenWidth*0.7),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(100)
                        ),
                        width: screenWidth *0.07,
                        height: screenHeight*0.07,
                        child: IconButton(
                          onPressed: showAddAdminDialog,
                          icon: Icon(Icons.add)
                        ),
                      ),
                      // White Container for List
                      Container(
                        width: screenWidth * 0.75,
                        margin: EdgeInsets.only(top: screenHeight * 0.0),
                        decoration: BoxDecoration(
                          color: Colors.white, // White background
                          borderRadius: BorderRadius.circular(50), // Rounded corners
                        ),
                        child: Column(
                          children: [
                            // Table Header
                            Container(
                               decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color:Colors.blue[500]
                              ),
                              width: screenWidth *0.75,
                              height: screenHeight * 0.05,
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: screenWidth * 0.1),
                                    child: Text("Name", style: TextStyle(fontSize: screenWidth * 0.008)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: screenWidth * 0.09),
                                    child: Text("code", style: TextStyle(fontSize: screenWidth * 0.008)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: screenWidth * 0.09),
                                    child: Text("rank", style: TextStyle(fontSize: screenWidth * 0.008)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: screenWidth * 0.15),
                                    child: Text("delete", style: TextStyle(fontSize: screenWidth * 0.008)),
                                  ),
                                ],
                              ),
                            ),
                            // List of Items
                            Container(
                              width: screenWidth * 0.75,
                              margin: EdgeInsets.only(top: screenHeight * 0.03),
                              child: Column(
                                children: items.isEmpty
                                    ? [
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 20),
                                          child: Text(
                                            "No admins found",
                                            style: TextStyle(fontSize: screenWidth * 0.01),
                                          ),
                                        )
                                      ]
                                    : List.generate(
                                        paginatedItems.length, // Use paginatedItems instead of items
                                        (index) => Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50),
                                            side: BorderSide(
                                              color: Colors.black12,
                                              width: 2,
                                            )
                                          ),
                                          margin: EdgeInsets.symmetric(vertical: 10),
                                          child: Container(
                                            margin: EdgeInsets.symmetric(vertical: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                // Name
                                                Container(
                                                  width: screenWidth * 0.10,
                                                  margin: EdgeInsets.only(left: screenWidth * 0.05),
                                                  child: Center(
                                                    child: Text(
                                                      paginatedItems[index].name,
                                                      style: TextStyle(fontSize: screenWidth * 0.008),
                                                    ),
                                                  ),
                                                ),
                                                // Code
                                                Container(
                                                  width: screenWidth * 0.08,
                                                  margin: EdgeInsets.only(left: screenWidth * 0.025),
                                                  child: Center(
                                                    child: Text(
                                                      paginatedItems[index].code,
                                                      style: TextStyle(fontSize: screenWidth * 0.008),
                                                    ),
                                                  ),
                                                ),
                                                // Rank
                                                Container(
                                                  width: screenWidth * 0.08,
                                                  margin: EdgeInsets.only(left: screenWidth * 0.04),
                                                  child: Center(
                                                    child: Text(
                                                      paginatedItems[index].rank,
                                                      style: TextStyle(fontSize: screenWidth * 0.008),
                                                    ),
                                                  ),
                                                ),
                                                // Delete Button
                                                Container(
                                                  margin: EdgeInsets.only(left: screenWidth * 0.11),
                                                  child: Center(
                                                    child: IconButton(
                                                   // Replace your existing IconButton onPressed with this:
onPressed: () {
  int actualIndex = (currentPage - 1) * itemsPerPage + index;
  if (actualIndex < items.length) {
    showDeleteConfirmationDialog(items[actualIndex].code);
  }
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
                            SizedBox(height: 20),
                            if (totalPages > 0) paginationControls(screenWidth),
                            SizedBox(height: 20),
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

class Item {
  final String name;
  final String code;
  final String rank;

  Item({required this.name, required this.code, required this.rank});
}
