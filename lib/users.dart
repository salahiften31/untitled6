
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled6/home.dart';
import 'package:intl/intl.dart';
import 'package:untitled6/admin.dart';


class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  List<Pod> pods = [];
  List<USR> filteredUsers = [];
  
TextEditingController searchController = TextEditingController();

  bool isHovered = false;
  bool isHovered1 = false;
  bool isHovered2 = false;
  bool isHovered3 = false;
  bool isHovered4 = false;
  late String te;
  List<USR> users = [];
  int currentPage = 1;
  final int itemsPerPage = 20;
   StreamSubscription<QuerySnapshot>? _usersSubscription;
  StreamSubscription<QuerySnapshot>? _podsSubscription;
  StreamSubscription<QuerySnapshot>? _channelsSubscription;
StreamSubscription<QuerySnapshot>? _podcastsSubscription;


   @override
  void initState() {
    super.initState();
    _setupRealTimeListeners();
    searchController.addListener(() {
      filterUsers();
    });
  }

  @override
  void dispose() {
    _usersSubscription?.cancel();
   _channelsSubscription?.cancel();
  _podcastsSubscription?.cancel();
  _podsSubscription?.cancel();
  _currentUserPodsSubscription?.cancel(); // Make sure this is here
  searchController.dispose();
  super.dispose();
  }
void _setupRealTimeListeners() {
  // Users listener
  _usersSubscription = FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .listen((snapshot) {
    // When users collection changes, update users list
    final userIds = snapshot.docs.map((doc) => doc.data()['userId']).toList();
    
    // Update users basic info
    final basicUsersList = snapshot.docs.map((doc) {
      final data = doc.data();
      
      // Handle Timestamp conversion
      String formattedDate = '';
      if (data['createdAt'] != null) {
        if (data['createdAt'] is Timestamp) {
          formattedDate = DateFormat('yyyy-MM-dd').format(data['createdAt'].toDate());
        } else if (data['createdAt'] is String) {
          formattedDate = data['createdAt'];
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
        chanel: data['chanel']?.toString() ?? 'N/A',
        channelPhotoUrl: '',
        followers: 0,
        following: 0,
        likes: 0,
        pods: 0,
        userId: data['userId']?.toString() ?? '',
      );
    }).toList();
    
    setState(() {
      users = basicUsersList;
      filteredUsers = basicUsersList;
    });
    
    // Cancel existing channels listener if any
    _channelsSubscription?.cancel();
    
    // Setup channels listener
    _channelsSubscription = FirebaseFirestore.instance
        .collection('channels')
        .where('userId', whereIn: userIds.isEmpty ? [''] : userIds)
        .snapshots()
        .listen((channelsSnapshot) {
      // Update user objects with channel data
      final updatedUsers = List<USR>.from(users);
      
      for (var channelDoc in channelsSnapshot.docs) {
        final channelData = channelDoc.data();
        final userId = channelData['userId']?.toString() ?? '';
        
        // Find and update the corresponding user
        final userIndex = updatedUsers.indexWhere((u) => u.userId == userId);
        if (userIndex >= 0) {
          final user = updatedUsers[userIndex];
          
          updatedUsers[userIndex] = USR(
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            country: user.country,
            signupd: user.signupd,
            picture: user.picture,
            age: user.age,
            chanel: channelData['name']?.toString() ?? user.chanel,
            channelPhotoUrl: channelData['photoUrl']?.toString() ?? user.channelPhotoUrl,
            followers: channelData['followers'] is int ? channelData['followers'] :
                      int.tryParse(channelData['followers']?.toString() ?? '0') ?? 0,
            following: channelData['following'] is int ? channelData['following'] :
                      int.tryParse(channelData['following']?.toString() ?? '0') ?? 0,
            likes: user.likes,
            pods: user.pods,
            userId: user.userId,
          );
        }
      }
      
      setState(() {
        users = updatedUsers;
        filterUsers(); // Apply current filter
      });
    });
    
    // Cancel existing podcasts listener if any
    _podcastsSubscription?.cancel();
    
    // Setup podcasts listener - this is a heavy operation
    _podcastsSubscription = FirebaseFirestore.instance
        .collection('podcasts')
        .where('idUser', whereIn: userIds.isEmpty ? [''] : userIds)
        .snapshots()
        .listen((podsSnapshot) {
      // Group podcasts by user
      final podsByUser = <String, List<Map<String, dynamic>>>{};
      
      for (var podDoc in podsSnapshot.docs) {
        final podData = podDoc.data();
        final userId = podData['idUser']?.toString() ?? '';
        
        if (!podsByUser.containsKey(userId)) {
          podsByUser[userId] = [];
        }
        
        podsByUser[userId]!.add(podData);
      }
      
      // Update user objects with podcast data
      final updatedUsers = List<USR>.from(users);
      
      for (final userId in podsByUser.keys) {
        final userPods = podsByUser[userId]!;
        final userIndex = updatedUsers.indexWhere((u) => u.userId == userId);
        
        if (userIndex >= 0) {
          final user = updatedUsers[userIndex];
          
          // Calculate totals
          int totalPods = userPods.length;
          int totalLikes = 0;
          
          for (var podData in userPods) {
            var podLikes = podData['likes'];
            if (podLikes != null) {
              if (podLikes is int) {
                totalLikes += podLikes;
              } else {
                totalLikes += int.tryParse(podLikes.toString()) ?? 0;
              }
            }
          }
          
          updatedUsers[userIndex] = USR(
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            country: user.country,
            signupd: user.signupd,
            picture: user.picture,
            age: user.age,
            chanel: user.chanel,
            channelPhotoUrl: user.channelPhotoUrl,
            followers: user.followers,
            following: user.following,
            likes: totalLikes,
            pods: totalPods,
            userId: user.userId,
          );
        }
      }
      
      setState(() {
        users = updatedUsers;
        filterUsers(); // Apply current filter
      });
    });
  });
}
String formatNumber(dynamic value) {
  // Convert value to int if it's not already
  int numValue = 0;
  if (value is int) {
    numValue = value;
  } else if (value is String) {
    numValue = int.tryParse(value) ?? 0;
  }
  
  // Format the number
  if (numValue >= 1000000) {
    return '${(numValue / 1000000).toStringAsFixed(1)}M';
  } else if (numValue >= 1000) {
    return '${(numValue / 1000).toStringAsFixed(1)}k';
  } else {
    return numValue.toString();
  }
}
void filterUsers() {
  String searchTerm = searchController.text.toLowerCase();
  setState(() {
    if (searchTerm.isEmpty) {
      filteredUsers = List.from(users);
    } else {
      filteredUsers = users.where((user) {
        return user.name.toLowerCase().contains(searchTerm) ||
               user.chanel.toLowerCase().contains(searchTerm) ;
      }).toList();
    }
    // Reset to first page when search changes
    currentPage = 1;
  });
}
StreamSubscription<QuerySnapshot>? _currentUserPodsSubscription;

void setupPodsListener(String userId) {
  // Cancel any existing subscription first
  _currentUserPodsSubscription?.cancel();
  
  // Clear the current pods list immediately
  setState(() {
    pods = [];
  });
  
  print("Setting up pods listener for user ID: $userId");
  
  // Set up real-time listener for this user's podcasts
  _currentUserPodsSubscription = FirebaseFirestore.instance
    .collection('podcasts')
    .where('idUser', isEqualTo: userId)
    .snapshots()
    .listen((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        print("No podcasts found for user ID: $userId");
        setState(() {
          pods = [];
        });
        return;
      }
      
      print("Found ${querySnapshot.docs.length} podcasts for user ID: $userId");
      
      final podsList = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Pod(
          name: data['name'] ?? '',
          picture: data['urlPhoto'] ?? '',
          likes: data['likes'] is int ? data['likes'] : int.tryParse(data['likes']?.toString() ?? '0') ?? 0, 
          comments: data['comments'] is int ? data['comments'] : int.tryParse(data['comments']?.toString() ?? '0') ?? 0, 
          lis: data['vue'] is int ? data['vue'] : int.tryParse(data['vue']?.toString() ?? '0') ?? 0, 
          id: doc.id,
        );
      }).toList();

      setState(() {
        pods = podsList;
      });
    }, onError: (error) {
      print("Error fetching podcasts: $error");
      setState(() {
        pods = [];
      });
    });
}
Future deleteUserAccount(String userId) async {
  try {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    
    // Step 1: Find and delete the user document
    final userDocs = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: userId)
        .get();
    
    for (var doc in userDocs.docs) {
      await doc.reference.delete();
      print('User deleted from Firestore: ${doc.id}');
    }
    
    // Step 2: Find all relationships where the deleted user is following others
    final following = await FirebaseFirestore.instance
        .collection('follow')
        .where('idfollowers', isEqualTo: userId)
        .get();
    
    // Get each followed channel ID and decrement their followers count
    for (var doc in following.docs) {
      String followedUserId = doc.data()['idfollowing'];
      
      // Get the channel document of the followed user
      final channelDocs = await FirebaseFirestore.instance
          .collection('channels')
          .where('userId', isEqualTo: followedUserId)
          .get();
      
      if (channelDocs.docs.isNotEmpty) {
        var channelDoc = channelDocs.docs.first;
        int currentFollowers = channelDoc.data()['followers'] ?? 0;
        if (currentFollowers > 0) {
          await channelDoc.reference.update({'followers': currentFollowers - 1});
          print('Updated follower count for channel: ${channelDoc.id}');
        }
      }
      
      // Delete the follow relationship
      await doc.reference.delete();
    }
    
    // Step 3: Find all relationships where others are following the deleted user
    final followers = await FirebaseFirestore.instance
        .collection('follow')
        .where('idfollowing', isEqualTo: userId)
        .get();
    
    // Get each follower's channel ID and decrement their following count
    for (var doc in followers.docs) {
      String followerUserId = doc.data()['idfollowers'];
      
      // Get the channel document of the follower user
      final channelDocs = await FirebaseFirestore.instance
          .collection('channels')
          .where('userId', isEqualTo: followerUserId)
          .get();
      
      if (channelDocs.docs.isNotEmpty) {
        var channelDoc = channelDocs.docs.first;
        int currentFollowing = channelDoc.data()['following'] ?? 0;
        if (currentFollowing > 0) {
          await channelDoc.reference.update({'following': currentFollowing - 1});
          print('Updated following count for channel: ${channelDoc.id}');
        }
      }
      
      // Delete the follow relationship
      await doc.reference.delete();
    }

    // Close loading indicator and show success message
    Navigator.of(context, rootNavigator: true).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User account deleted successfully")),
    );
    
    // Refresh the user list
    _setupRealTimeListeners();
  } catch (e) {
    // Close loading indicator and show error message
    Navigator.of(context, rootNavigator: true).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error deleting user account: ${e.toString()}")),
    );
    print("Error deleting user account: $e");
  }
}


List<USR> get paginatedItems {
  int start = (currentPage - 1) * itemsPerPage;
  int end = start + itemsPerPage;
  if (filteredUsers.isEmpty) return [];
  return filteredUsers.sublist(start, end > filteredUsers.length ? filteredUsers.length : end);
}

int get totalPages => (filteredUsers.length / itemsPerPage).ceil();
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
Future<void> showDeleteUserDialog(String userId) async {
  bool deleteUser = true;
  bool deleteChannel = true;
  
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
              width: screenWidth * 0.35,
              height: screenHeight * 0.45,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.05),
                    child: Text(
                      "Confirm User Deletion",
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
                      "select to  delete",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: screenWidth * 0.01),
                    ),
                  ),
                 
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.03),
                    width: screenWidth * 0.25,
                    child: Row(
                      children: [
                        Checkbox(
                          value: deleteUser,
                          onChanged: (value) {
                            setDialogState(() {
                              deleteUser = value ?? true;
                            });
                          },
                        ),
                        Text(
                          "Delete User",
                          style: TextStyle(fontSize: screenWidth * 0.01),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.25,
                    child: Row(
                      children: [
                        Checkbox(
                          value: deleteChannel,
                          onChanged: (value) {
                            setDialogState(() {
                              deleteChannel = value ?? true;
                            });
                          },
                        ),
                        Text(
                          "Delete Channel",
                          style: TextStyle(fontSize: screenWidth * 0.01),
                        ),
                      ],
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
  Navigator.of(context).pop();
  
  // Store user data before deletion to reference it after

  if (deleteUser) {
    await deleteUserAccount(userId);
    await deleteUserChannel(userId);
  }
  if (deleteChannel) {
    await deleteUserChannel(userId);
  }
  
  
  // Show success message
  String message = "";
  if (deleteUser && deleteChannel) {
    message = "User and channel deleted successfully";
  } else if (deleteChannel) {
    message = "Channel deleted successfully";
  }
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
  
  // No need to call _setupRealTimeListeners() here
  // The state is already updated in the deletion methods
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


Future<void> deleteUserChannel(String userId) async {
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
        .where('userId', isEqualTo: userId)
        .get();
    
    for (var doc in channelDocs.docs) {
      await doc.reference.delete();
      print('Channel deleted from Firestore: ${doc.id}');
    }

    // Step 2: Find and delete all podcasts by this user
    final podcastDocs = await FirebaseFirestore.instance
        .collection('podcasts')
        .where('idUser', isEqualTo: userId)
        .get();
    
    for (var doc in podcastDocs.docs) {
      final podcastId = doc.id;
      
      // Delete all references to this podcast in playinpod
      final playInPodRefs = await FirebaseFirestore.instance
          .collection('playinpod')
          .where('podcastId', isEqualTo: podcastId)
          .get();
          
      for (var playInPodDoc in playInPodRefs.docs) {
        await playInPodDoc.reference.delete();
        print('Deleted playinpod reference: ${playInPodDoc.id}');
      }
      
      // Now delete the podcast
      await doc.reference.delete();
      print('Deleted podcast: ${doc.id}');
    }
    
    // Step 3: Find and delete all playlists by this user
    final playlisDocs = await FirebaseFirestore.instance
        .collection('playlist')
        .where('userId', isEqualTo: userId)
        .get();
    
    for (var doc in playlisDocs.docs) {
      final playlistId = doc.id;
      
      // Delete all references to this playlist in playinpod
      final playInPodRefs = await FirebaseFirestore.instance
          .collection('playinpod')
          .where('playlistId', isEqualTo: playlistId)
          .get();
          
      for (var playInPodDoc in playInPodRefs.docs) {
        await playInPodDoc.reference.delete();
        print('Deleted playinpod reference: ${playInPodDoc.id}');
      }
      
      // Now delete the playlist
      await doc.reference.delete();
      print('Deleted playlist: ${doc.id}');
    }
    
    // NEW CODE: Delete references in myplaylist for this user
    final myPlaylistRefs = await FirebaseFirestore.instance
        .collection('myplaylist')
        .where('iduser', isEqualTo: userId)
        .get();
        
    for (var doc in myPlaylistRefs.docs) {
      await doc.reference.delete();
      print('Deleted myplaylist reference: ${doc.id}');
    }
    
    // NEW CODE: Delete references in mesplaylist for this user
    final mesPlaylistRefs = await FirebaseFirestore.instance
        .collection('mesplaylist')
        .where('iduser', isEqualTo: userId)
        .get();
        final followers = await FirebaseFirestore.instance
        .collection('follow')
        .where('idfollowing', isEqualTo: userId)
        .get();
    
    // Get each follower's channel ID and decrement their following count
    for (var doc in followers.docs) {
      String followerUserId = doc.data()['idfollowers'];
      
      // Get the channel document of the follower user
      final channelDocs = await FirebaseFirestore.instance
          .collection('channels')
          .where('userId', isEqualTo: followerUserId)
          .get();
      
      if (channelDocs.docs.isNotEmpty) {
        var channelDoc = channelDocs.docs.first;
        int currentFollowing = channelDoc.data()['following'] ?? 0;
        if (currentFollowing > 0) {
          await channelDoc.reference.update({'following': currentFollowing - 1});
          print('Updated following count for channel: ${channelDoc.id}');
        }
      }
      
      // Delete the follow relationship
      await doc.reference.delete();
    }

        
    for (var doc in mesPlaylistRefs.docs) {
      await doc.reference.delete();
      print('Deleted mesplaylist reference: ${doc.id}');
    }
    
    reportcha(userId);
    
    // Update local state after deletion
    setState(() {
      // Find and update the user in both users and filteredUsers lists
      for (int i = 0; i < users.length; i++) {
        if (users[i].userId == userId) {
          // Create a new user object with updated channel info
          users[i] = USR(
            firstName: users[i].firstName,
            lastName: users[i].lastName,
            email: users[i].email,
            country: users[i].country,
            signupd: users[i].signupd,
            picture: users[i].picture,
            age: users[i].age,
            chanel: 'N/A',  // Reset channel name
            channelPhotoUrl: '',  // Reset channel photo
            followers: 0,  // Reset followers
            following: users[i].following,
            likes: 0,  // Reset likes from channel
            pods: 0,  // Reset pods count
            userId: users[i].userId,
          );
          break;
        }
      }
      
      // Also update the filtered users list
      for (int i = 0; i < filteredUsers.length; i++) {
        if (filteredUsers[i].userId == userId) {
          filteredUsers[i] = USR(
            firstName: filteredUsers[i].firstName,
            lastName: filteredUsers[i].lastName,
            email: filteredUsers[i].email,
            country: filteredUsers[i].country,
            signupd: filteredUsers[i].signupd,
            picture: filteredUsers[i].picture,
            age: filteredUsers[i].age,
            chanel: 'N/A',  // Reset channel name
            channelPhotoUrl: '',  // Reset channel photo
            followers: 0,  // Reset followers
            following: filteredUsers[i].following,
            likes: 0,  // Reset likes from channel
            pods: 0,  // Reset pods count
            userId: filteredUsers[i].userId,
          );
          break;
        }
      }
    });

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
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    
    // First, query for the document with the matching id
    final querySnapshot = await FirebaseFirestore.instance
        .collection('podcasts')
        .where('id', isEqualTo: id)
        .get();
        
    // Check if we found a document with that id
    if (querySnapshot.docs.isNotEmpty) {
      final podcastDocId = querySnapshot.docs.first.id;
      final podcastData = querySnapshot.docs.first.data();
      final userId = podcastData['idUser']; // Get the user ID
      
      // Before deleting the podcast, delete all references in playinpod
      final playInPodRefs = await FirebaseFirestore.instance
          .collection('playinpod')
          .where('podcastId', isEqualTo: podcastDocId)
          .get();
          
      for (var playInPodDoc in playInPodRefs.docs) {
        // Get the playlist ID to potentially update its podcast count
        final playlistId = playInPodDoc.data()['playlistId'];
        
        // Delete the playinpod reference
        await playInPodDoc.reference.delete();
        print('Deleted playinpod reference: ${playInPodDoc.id}');
        
        // Optionally: Update the playlist's podcast count
        if (playlistId != null) {
          final playlistDoc = await FirebaseFirestore.instance
              .collection('playlist')
              .doc(playlistId)
              .get();
              
          if (playlistDoc.exists) {
            final currentCount = playlistDoc.data()?['podcast'] ?? 0;
            final newCount = currentCount > 0 ? currentCount - 1 : 0;
            
            await FirebaseFirestore.instance
                .collection('playlist')
                .doc(playlistId)
                .update({'podcast': newCount});
                
            print('Updated playlist podcast count: $playlistId');
          }
        }
      }
      
      // NEW CODE: Delete references in myplaylist related to this podcast
      if (userId != null) {
        final myPlaylistRefs = await FirebaseFirestore.instance
            .collection('myplaylist')
            .where('iduser', isEqualTo: userId)
            .where('idpod', isEqualTo: podcastDocId)
            .get();
            
        for (var doc in myPlaylistRefs.docs) {
          await doc.reference.delete();
          print('Deleted myplaylist reference: ${doc.id}');
        }
        
        // NEW CODE: Delete references in mesplaylist related to this podcast
        final mesPlaylistRefs = await FirebaseFirestore.instance
            .collection('mesplaylist')
            .where('iduser', isEqualTo: userId)
            .where('idpod', isEqualTo: podcastDocId)
            .get();
            
        for (var doc in mesPlaylistRefs.docs) {
          await doc.reference.delete();
          print('Deleted mesplaylist reference: ${doc.id}');
        }
      }
      
      // Now delete the actual podcast
      await FirebaseFirestore.instance
          .collection('podcasts')
          .doc(podcastDocId)
          .delete();
          
      // Close loading indicator
      Navigator.of(context, rootNavigator: true).pop();
          
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Podcast deleted successfully")),
      );
    } else {
      // Close loading indicator
      Navigator.of(context, rootNavigator: true).pop();
          
      // Show not found message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Podcast not found")),
      );
    }
  } catch (e) {
    // Close loading indicator
    Navigator.of(context, rootNavigator: true).pop();
      
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error deleting podcast: $e")),
    );
    print("Error deleting podcast: $e");
  }
}
Future<void> reportUser(String userId) async {
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
String predefinedMessage = "Warning: We've noticed some suspicious activity in your account that violates our community guidelines. We will investigate this matter further. Please be aware that repeated offenses may result in a temporary or permanent ban.";
    
    // Add report to Firestore
    await FirebaseFirestore.instance.collection('reports').doc(reportId).set({
      'reportId': reportId,
      'userId': userId,
      'message': predefinedMessage,
      'reportedAt': FieldValue.serverTimestamp(),
      'isviewed':false,
       // To identify that an admin made this report
    });
    
    // Close loading indicator
    Navigator.of(context, rootNavigator: true).pop();
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User reported successfully")),
    );
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
      'isviewed':false,
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
        'isviewed':false,
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
  controller: searchController,
  decoration: InputDecoration(
    hintText: "Search users",
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
                                                      fit: BoxFit.cover,
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
                                                     onPressed: () async { if  (paginatedItems[index].chanel == 'N/A') 
                            {}                         
                                                     else {
       
    setupPodsListener(paginatedItems[index].userId);
    
    await Future.delayed(Duration(milliseconds: 300));

  setState(() {}); // Wait for pods to load
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
                            paginatedItems[index].channelPhotoUrl,
                            fit: BoxFit.cover,
                            // Removed caching parameters that were causing issues
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
                                    formatNumber(paginatedItems[index].following),
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
                                    formatNumber(paginatedItems[index].followers),
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
                                      formatNumber(paginatedItems[index].likes),
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
                                     formatNumber(paginatedItems[index].pods),
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
            // Pod list - limiting height and using builder for lazy loading
            Container(
              color: Colors.white,
              width: screenWidth * 0.4,
              height: screenHeight * 0.4,
               // Fixed height instead of Expanded
              child:  ListView.builder( // Changed to ListView.builder for efficiency
                itemCount: pods.length,
                itemBuilder: (context, index) {
                  
                  return Container(
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
                          child: ClipOval(
                            child: Image.network(
                              pods[index].picture, 
                              fit: BoxFit.fill,
                            ),
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
                                  title: Text(formatNumber(pods[index].lis), style: TextStyle(fontSize: screenHeight * 0.015)),
                                  dense: true, // Make ListTile more compact
                                ),
                              ),
                              Container(
                                height: screenHeight * 0.02,
                                margin: EdgeInsets.only(top: screenHeight * 0.015),
                                child: ListTile(
                                  leading: Icon(Icons.thumb_up_alt_outlined, size: screenHeight * 0.015),
                                  title: Text(formatNumber(pods[index].likes), style: TextStyle(fontSize: screenHeight * 0.015)),
                                  dense: true,
                                ),
                              ),
                              Container(
                                height: screenHeight * 0.02,
                                margin: EdgeInsets.only(top: screenHeight * 0.015),
                                child: ListTile(
                                  leading: Icon(Icons.comment_outlined, size: screenHeight * 0.015),
                                  title: Text(formatNumber(pods[index].comments), style: TextStyle(fontSize: screenHeight * 0.015)),
                                  dense: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: screenWidth * 0.008),
                          child: IconButton(
                            onPressed: () async{ 
               await reportPod(pods[index].id, pods[index].name);
    await deletePod(pods[index].id);
               _setupRealTimeListeners();
              
                              
                              },
                            icon: Icon(Icons.delete_outline),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Close button with improved performance
            TextButton(
              onPressed: () {
                // Use pop without rebuilding the entire dialog
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        ),
      ),
    );
    },
  ).then((_) {
      // When dialog closes, cancel the pods subscription
      _currentUserPodsSubscription?.cancel();
          setState(() {
        pods = [];
      });
    });
  
  }
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
    int actualIndex = (currentPage - 1) * itemsPerPage + index;
    if (actualIndex < filteredUsers.length) {
      // Show a simple confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Report User"),
            content: Text("Are you sure you want to report this user?"),
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
                  reportUser(filteredUsers[actualIndex].userId);
                },
                child: Text("Report"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          );
        },
      );
    }
  },
  icon: Icon(Icons.warning),
  tooltip: "Report User",
),
                                                  ),
                                                ),
                                                // Delete Button
                                                Container(
                                                  margin: EdgeInsets.only(left: screenWidth * 0.02),
                                                  child: Center(
                                                    child: IconButton(
                                                      onPressed: () {
                                                         int actualIndex = (currentPage - 1) * itemsPerPage + index;
  if (actualIndex < users.length) {
    // Assuming your User class has userId and channelId properties
    showDeleteUserDialog(users[actualIndex].userId);
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
class Pod {
 final String picture;
 final String name;
 final String id;
 final int likes;
 final int comments;
 final int lis;
 Pod ({
required this.picture,
required this.name,
required this.likes,
required this.comments,
required this.lis,
required this.id,
 });


}
