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
    List<Pod> pods = [
Pod(picture: "10919202.jpg", name: "salah first",likes: "1220",comments: "120",lis: "3200"),
Pod(picture: "4778173.jpg", name: "salah second",likes: "1000",comments: "20",lis: "1440"),
Pod(picture: "4764773.jpg", name: "salah third",likes: "200",comments: "10",lis: "900" ),
Pod(picture: "4764773.jpg", name: "salah third",likes: "200",comments: "10",lis: "900" ),
Pod(picture: "4764773.jpg", name: "salah third",likes: "200",comments: "10",lis: "900" ),

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
          SizedBox(child: Container(

child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [Container(
    decoration: BoxDecoration(border: Border.all(color: Colors.black12,width: 4),
    borderRadius: BorderRadius.all(Radius.circular(20))
    
    
    ),
    
    
    height: screenHeight*0.9,
  margin: EdgeInsets.only(left: screenWidth*0.02),
width: screenWidth*0.3,
child: ListView(children: [Center(child: Text("Reported chanells",style: TextStyle(fontSize: screenHeight*0.025),),),
Column(children: List.generate(pods.length, (index)=> Container(
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
                                child: Image.asset(pods[index].picture, fit: BoxFit.fill),
                              ),
       ), 
                            Container( margin: EdgeInsets.only(left: screenWidth*0.02),  child: Text(pods[index].name,style: TextStyle(fontSize: screenHeight*0.02),)),
                            Spacer(),
                            Container( margin: EdgeInsets.only(left: screenWidth*0.05),  child: IconButton(onPressed: (){}, icon: Icon(Icons.delete_outline)),)
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
                        margin: EdgeInsets.only(left: screenWidth * 0.03),
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.03,
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
  margin: EdgeInsets.only(left: screenWidth*0.05),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.delete_outline),
                        ),
                      ),
                     
                    ],
                  ),
                ),),)




],),
),





],),






          ),
          )
        ],
      ),
    );
  }
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