import 'package:flutter/material.dart';
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
  List<Item> items = [
    Item(name: "iften salah eddine", code: "123", rank: "creator"),
    Item(name: "benslimane youness", code: "456", rank: "creator"),
    Item(name: "Alice Johnson", code: "789", rank: "3"),
    Item(name: "Aln", code: "89", rank: "4"),
    Item(name: " Johnson", code: "9", rank: "5"),
    Item(name: " Johnson", code: "9", rank: "5"),
    Item(name: " Johnson", code: "9", rank: "5"),
        Item(name: "iften salah eddine", code: "123", rank: "Goat"),
    Item(name: "benslimane youness", code: "456", rank: "gg"),
    Item(name: "Alice Johnson", code: "789", rank: "3"),
    Item(name: "Aln", code: "89", rank: "4"),
    Item(name: " Johnson", code: "9", rank: "5"),
    Item(name: " Johnson", code: "9", rank: "5"),
    Item(name: " Johnson", code: "9", rank: "5"),
  ];

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
                      ),
                      Container( 
                        margin: EdgeInsets.only(top: screenHeight*0.14,left: screenWidth*0.7),
                        decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(100)
      
                        ),
                        width: screenWidth *0.07,
                      height: screenHeight*0.07,
                     child: IconButton(onPressed: (){
                      setState(() {
                        showDialog(context: context,builder :(BuildContext context ){
      return Dialog(
      child: Container(
        decoration: BoxDecoration(  color: Colors.white,
        borderRadius: BorderRadius.circular(35)
        
        ),
      
        width: screenWidth*0.4,
        height: screenHeight*0.45,
        child: Column(
      children: [
      Container(
      
        margin: EdgeInsets.only(top: screenHeight*0.08),
        width: screenWidth*0.3,
      child: TextField
      
      (decoration: InputDecoration(hintText: "creators code",
      border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
      ),
      ),
      
      ),
      Container(
      
        margin: EdgeInsets.only(top: screenHeight*0.03),
        width: screenWidth*0.3,
      child: TextField
      
      (decoration: InputDecoration(hintText: "New admin code",
      border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
      ),
      ),
      
      ),
      Container(
      
        margin: EdgeInsets.only(top: screenHeight*0.03),
        width: screenWidth*0.3,
      child: TextField
      
      (decoration: InputDecoration(hintText: "New admin password",
      border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
      ),
      ),
      
      ),
      
      Container(
        margin: EdgeInsets.only(top: screenHeight*0.05,left: screenWidth*0.14),
        child: Row(   children: [     Container(
          
                width: screenWidth * 0.1, // ✅ Responsive width
                height: screenHeight * 0.06,
                 // ✅ Responsive height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xFF4b68ff),
                ),
                child: MaterialButton(
                  onPressed: () {
      
                  },
                  child: Text(
                    "Add admin",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.010, // ✅ Responsive font size
                    ),
                  ),
                ),
              ),],),
      )
      ],
      
      
        ),
       
      ),
      
      
      );
      
      
      
                        });
                      });
                     }, icon: Icon(Icons.add)),
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
                                children: List.generate(
                                  items.length,
                                  (index) => Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50),
                                          side: BorderSide(
                                            color: Colors.black12,
                                            width: 2,
                                          )
                                        ),
                                    margin: EdgeInsets.symmetric(
                                      vertical: 10, ),
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
                                                items[index].name,
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
                                                items[index].code,
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
                                                items[index].rank,
                                                style: TextStyle(fontSize: screenWidth * 0.008),
                                              ),
                                            ),
                                          ),
                                          // Delete Button
                                          Container(
                                            margin: EdgeInsets.only(left: screenWidth * 0.11),
                                            child: Center(
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    items.removeAt(index);
                                                  });
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