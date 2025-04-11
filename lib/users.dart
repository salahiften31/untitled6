import 'package:flutter/material.dart';
import 'package:untitled6/home.dart';

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
List<Pod> pods = [
Pod(picture: "10919202.jpg", name: "salah first",likes: "1220",comments: "120",lis: "3200"),
Pod(picture: "4778173.jpg", name: "salah second",likes: "1000",comments: "20",lis: "1440"),
Pod(picture: "4764773.jpg", name: "salah third",likes: "200",comments: "10",lis: "900" ),
Pod(picture: "4764773.jpg", name: "salah third",likes: "200",comments: "10",lis: "900" ),
Pod(picture: "4764773.jpg", name: "salah third",likes: "200",comments: "10",lis: "900" ),

];


List<Item> items = [
  Item(
    name: "John Doe",
    email: "iftensalah48@gmail.com",
    age: "19",
    chanel: " salah motivation",
    signupd: "22/10/2024",
    country: "demonican republique",
    picture: "5907.jpg", // Add image path
    password: "1234" //hello world
  ),
  Item(
    name: "Jane Smith",
    email: "smith@gmail.com",
    age: "85",
        chanel: " hello",
          signupd: "22/10/2024",
    country: "algeria",
    picture: "assets/user2.png", // Add image path
     password: "1234"
  ),
  Item(
    name: "Alice Johnson",
    email: "polo@gmail.com",
    age: "22",
        chanel: " hello",
          signupd: "22/10/2024",
    country: "algeria",
    picture: "assets/user3.png", // Add image path
     password: "1234"
  ),
  Item(
    name: "Bob Brown",
    email: "hytgl@gmail.com",
    age: "14",
        chanel: " hello",
          signupd: "22/10/2024",
    country: "algeria",
    picture: "assets/user4.png", // Add image path
     password: "1234"
  ),
    Item(
    name: "John Doe",
    email: "hhhh@gmail.com",
    age: "19",
    chanel: " hello",
      signupd: "22/10/2024",
    country: "algeria",
    picture: "assets/user1.png", // Add image path
    password: "1234"
  ),
  Item(
    name: "Jane Smith",
    email: "smith@gmail.com",
    age: "85",
        chanel: " hello",
          signupd: "22/10/2024",
    country: "algeria",
    picture: "assets/user2.png", // Add image path
     password: "1234"
  ),
  Item(
    name: "Alice Johnson",
    email: "polo@gmail.com",
    age: "22",
        chanel: " hello",
          signupd: "22/10/2024",
    country: "algeria",
    picture: "assets/user3.png", // Add image path
     password: "1234"
  ),
  Item(
    name: "Bob Brown",
    email: "hytgl@gmail.com",
    age: "14",
        chanel: " hello",
          signupd: "22/10/2024",
    country: "algeria",
    picture: "assets/user4.png", // Add image path
     password: "1234"
  ),
    Item(
    name: "John Doe",
    email: "hhhh@gmail.com",
    age: "19",
    chanel: " hello",
      signupd: "22/10/2024",
    country: "algeria",
    picture: "assets/user1.png", // Add image path
    password: "1234"
  ),
  Item(
    name: "Jane Smith",
    email: "smith@gmail.com",
    age: "85",
        chanel: " hello",
          signupd: "22/10/2024",
    country: "algeria",
    picture: "assets/user2.png", // Add image path
     password: "1234"
  ),
  Item(
    name: "Alice Johnson",
    email: "polo@gmail.com",
    age: "22",
        chanel: " hello",
          signupd: "22/10/2024",
    country: "algeria",
    picture: "assets/user3.png", // Add image path
     password: "1234"
  ),
  Item(
    name: "Bob Brown",
    email: "hytgl@gmail.com",
    age: "14",
        chanel: " hello",
          signupd: "22/10/2024",
    country: "algeria",
    picture: "assets/user4.png", // Add image path
     password: "1234"
  ),
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
                      color:  Colors.blue[700] ,
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
                          child: Icon(Icons.logout, size: screenHeight*0.022,),
                        ),
                        title: Text("Logout",style: TextStyle(fontSize: screenWidth *0.01),),
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
                                color:Colors.blue[500]
                              ),
                              width: screenWidth *0.75,
                              height: screenHeight * 0.05,
                              margin: EdgeInsets.only(top: screenHeight*0.1),
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
                            // List of Items
                            Container(
           
                              width: screenWidth ,
                              margin: EdgeInsets.only(top: screenHeight * 0.03),
                              child: Column(
                                children: List.generate(
                                  items.length,
                                  (index) => Container(
                                    width:screenWidth*0.75,
                                    decoration: BoxDecoration(
                                      
                                    ),
                                    child: Card(
                                    
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        side: BorderSide(
                                          color: Colors.black12,
                                          width: 2,
                                        )
                                      ),
                                  
                                  
                                      margin: EdgeInsets.symmetric(
                                        vertical: 10,),
                                      child: Container(
                                        margin: EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          children: [
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100), // Optional: Not needed for ClipOval
                                   color: Colors.black, ),
                                    margin: EdgeInsets.only(left: screenWidth * 0.02),
                                    height: screenHeight * 0.055,
                                    width: screenWidth * 0.028,
                                    child: ClipOval( // Use ClipOval for a circular clip
                                      child: Image.asset(
                                        items[index].picture, // Ensure this is a valid asset path
                                        fit: BoxFit.fill, // Adjust the fit as needed
                                      ),
                                    ),
                                  ),
                                            // Name
                                            Container(
                                             
                                              width: screenWidth * 0.10,
                                              margin: EdgeInsets.only(left: screenWidth * 0.01),
                                              child: Center(
                                                child: Text(
                                                  items[index].name,
                                                  style: TextStyle(fontSize: screenWidth * 0.008),
                                                ),
                                              ),
                                            ),
                                               Container(
                                               
                                              width: screenWidth * 0.1,
                                              margin: EdgeInsets.only(left: screenWidth * 0.018),
                                              child: Center(
                                                child: Text(
                                                  items[index].email,
                                                  style: TextStyle(fontSize: screenWidth * 0.008),
                                                ),
                                              ),
                                            ),
                                            // Code
                                            Container(
                                             
                                              width: screenWidth * 0.08,
                                              margin: EdgeInsets.only(left: screenWidth * 0.018),
                                              child: Center(
                                                child: TextButton(
                                                  onPressed: () { setState(() {
                          showDialog(context: context,builder :(BuildContext context ){
return Dialog(
child: Container(
  decoration: BoxDecoration( 
    color: Colors.white,
    border: Border.all(color: Colors.black12),
    borderRadius: BorderRadius.circular(20),
  ),
  width: screenWidth * 0.4,
  child: Column(
  children: [
    // Non-scrollable part
    Container(
      decoration: BoxDecoration(
borderRadius:BorderRadius.all(Radius.circular(50)),


 color: Colors.white,

      ),
    
      height: screenHeight*0.265,
      width: screenWidth*0.45,
child: SizedBox(
  height: screenHeight*0.1,
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [Center(
    child: Container(
      decoration: BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(50)),
    color: Colors.black,
    
      ),
    height: screenHeight*0.075,
    width: screenWidth*0.04,
    margin: EdgeInsets.only(top: screenHeight*0.03),
    
    child: ClipOval(),
    ),
  ),
  Container( margin: EdgeInsets.only(top: screenHeight*0.02),  child: Text("salah Motivation",style: TextStyle(fontSize: screenHeight*0.02),)),
  Container(
  margin: EdgeInsets.only(left: screenWidth*0.1,top: screenHeight*0.03),
  
  
    child: Center(
  child: Row(children: [
  Column(  children: [Text("follows  ",style: TextStyle(fontSize: screenHeight*0.018),),Container( margin: EdgeInsets.only(top: screenHeight*0.005),  child: Text("587580",style: TextStyle(fontSize: screenHeight*0.015)))],),
  Container(  margin: EdgeInsets.only(left: screenWidth*0.02), child: Column(  children: [Text("followers ",style: TextStyle(fontSize: screenHeight*0.018)),Container( margin: EdgeInsets.only(top: screenHeight*0.005),  child: Text("587580",style: TextStyle(fontSize: screenHeight*0.015)))],),),
  Container(margin: EdgeInsets.only(left: screenWidth*0.02),child: Column(  children: [Text("likes ",style: TextStyle(fontSize: screenHeight*0.018)),Container( margin: EdgeInsets.only(top: screenHeight*0.005),  child: Text("587580",style: TextStyle(fontSize: screenHeight*0.015)))],),),
  Container(margin: EdgeInsets.only(left: screenWidth*0.02),child: Column(  children: [Text("pods ",style: TextStyle(fontSize: screenHeight*0.018)),Container( margin: EdgeInsets.only(top: screenHeight*0.005),  child: Text("380",style: TextStyle(fontSize: screenHeight*0.015)))],),),
  
  
  
  ],),
    ),
  )
  
  
  ],
  
  
  
  )
),

      ),
   
    
    // Scrollable ListView
    Expanded(
      child: Container(

          color: Colors.white,
        width: screenWidth * 0.4,
        child: ListView(
          children: List.generate(pods.length, (index) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: EdgeInsets.only(top: screenHeight * 0.04),
                  width: screenWidth * 0.38,
                  height: screenHeight * 0.15,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: screenWidth * 0.03),
                        height: screenHeight * 0.08,
                        width: screenWidth * 0.05,
                        child: ClipRRect(
                          child: Image.asset(pods[index].picture, fit: BoxFit.fill),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: screenWidth * 0.03),
                        width: screenWidth * 0.08,
                        child: Text(
                          pods[index].name,
                          style: TextStyle(fontSize: screenWidth * 0.01),
                        ),
                      ),
                      Container(
                        height: screenHeight * 0.15,
                        width: screenWidth * 0.1,
                        margin: EdgeInsets.only(left: screenWidth * 0.05),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: screenHeight * 0.02),
                              height: screenHeight * 0.017,
                              child: ListTile(
                                leading: Icon(Icons.headphones_outlined, size: screenHeight * 0.015),
                                title: Text(pods[index].lis, style: TextStyle(fontSize: screenHeight * 0.015)),
                              ),
                            ),
                            Container(
                              height: screenHeight * 0.02,
                              margin: EdgeInsets.only(top: screenHeight * 0.015),
                              child: ListTile(
                                leading: Icon(Icons.thumb_up_alt_outlined, size: screenHeight * 0.015),
                                title: Text(pods[index].likes, style: TextStyle(fontSize: screenHeight * 0.015)),
                              ),
                            ),
                            Container(
                              height: screenHeight * 0.02,
                              margin: EdgeInsets.only(top: screenHeight * 0.015),
                              child: ListTile(
                                leading: Icon(Icons.comment_outlined, size: screenHeight * 0.015),
                                title: Text(pods[index].comments, style: TextStyle(fontSize: screenHeight * 0.015)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: screenWidth * 0.008),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.delete_outline),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    ),
  ],
)
)



);



                          });
                        });},
                                                    child: Text(
                                                  items[index].chanel,
                                                  style: TextStyle(fontSize: screenWidth * 0.008),)
                                                ),
                                              ),
                                            ),
                                                  Container(
                                                   
                                              width: screenWidth * 0.06,
                                              margin: EdgeInsets.only(left: screenWidth * 0.018),
                                              child: Center(
                                                child: Text(
                                                  items[index].signupd,
                                                  style: TextStyle(fontSize: screenWidth * 0.008),
                                                ),
                                              ),
                                            ),
                                                  Container(
                                                   
                                              width: screenWidth * 0.10,
                                              margin: EdgeInsets.only(left: screenWidth * 0.015),
                                              child: Center(
                                                child: Text(
                                                  items[index].country,
                                                  style: TextStyle(fontSize: screenWidth * 0.008),
                                                ),
                                              ),
                                            ),
                                            // Rank
                                            Container(
                                             
                                              width: screenWidth * 0.02,
                                              margin: EdgeInsets.only(left: screenWidth * 0.018),
                                              child: Center(
                                                child: Text(
                                                  items[index].age,
                                                  style: TextStyle(fontSize: screenWidth * 0.008),
                                                ),
                                              ),
                                            ),
                                                 Container(
                                              margin: EdgeInsets.only(left: screenWidth * 0.04),
                                              child: Center(
                                                child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      items.removeAt(index);
                                                    });
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
  final String email;
 late final String password;
 late final String picture;
late  final  String signupd ;
  final  String country ;
  final String age; 
final String chanel;
  Item({
    required this.name,
    required this.email,
    required this.password,
  required this.country,
  required this.signupd,
    required this.picture,
    required this.age,
    required this.chanel // Add this
  });
}

class Pod {
 final String picture;
 final String name;
 final String likes;
 final String comments;
 final String lis;
 Pod ({
required this.picture,
required this.name,
required this.likes,
required this.comments,
required this.lis,
 });


}