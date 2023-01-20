import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_10.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class userDetails extends StatefulWidget {
  userDetails({Key? key, this.username, this.uid}) : super(key: key);
  final uid;
  final username;

  @override
  State<userDetails> createState() => _userDetailsState(uid, username);
}

class _userDetailsState extends State<userDetails> {
  final uid;
  final username;
  _userDetailsState(this.uid, this.username);
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference chats = FirebaseFirestore.instance.collection("chat");

  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  var chatDoc;

  var _textController = new TextEditingController();
  sendMessage(String msg) async {
    var id = currentUserId + uid;

    if (msg == '') return;
    try {
      await chats.doc("$currentUserId${uid}").collection('messageData').add({
        'createdOn': FieldValue.serverTimestamp(),
        'uid': currentUserId,
        'msg': msg
      }).then((value) {
        _textController.text = '';
      });

      await chats.doc("${uid}$currentUserId").collection('messageData').add({
        'createdOn': FieldValue.serverTimestamp(),
        'uid': currentUserId,
        'msg': msg
      }).then((value) {
        _textController.text = '';
      });
    } catch (e) {
      print(e);
    }
  }

  bool isSender(String friend) {
    return friend == currentUserId;
  }

  Alignment getAlignment(friend) {
    if (friend == uid) {
      return Alignment.topLeft;
    } else {
      return Alignment.topRight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .doc("${currentUserId}${uid}")
          .collection('messageData')
          .orderBy('createdOn', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Something has error"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text("Loading...."),
          );
        }
        if (snapshot.hasData) {
   
          return Scaffold(
          
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back)),
            ),
            body: SafeArea(
                child: Column(
              children: [
                Expanded(
                    child: ListView(
                  reverse: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    // var data = document.data()!;
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return ChatBubble(
                        clipper: ChatBubbleClipper10(
                          nipSize: 8,
                          radius: 34,
                          sizeRatio: 4,
                          type: isSender(data['uid'].toString())
                              ? BubbleType.sendBubble
                              : BubbleType.receiverBubble,
                        ),
                        alignment: getAlignment(data['uid'].toString()),
                        margin: EdgeInsets.only(top: 20),
                        backGroundColor: isSender(data['uid'].toString())
                            ? Color(0xFF08C187)
                            : Color.fromARGB(248, 26, 173, 199),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: Flexible(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['msg'],
                                      style: TextStyle(
                                        color: isSender(data['uid'].toString())
                                            ? Color.fromARGB(255, 248, 251, 249)
                                            : Color.fromARGB(255, 216, 206, 206),
                                      ),
                                      maxLines: 100,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      data['createdOn'] == null
                                          ? DateTime.now().toString()
                                          : data['createdOn'].toDate().toString(),
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: isSender(data['uid'].toString())
                                              ? Colors.white
                                              : Colors.black),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ));
                  }).toList(),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: TextField(
                      controller: _textController,
                    )),
                    CupertinoButton(
                        child: Icon(Icons.send_sharp),
                        onPressed: () {
                          sendMessage(_textController.text);
                        })
                  ],
                )
              ],
            )),
          );
        }
        return Container();
      },
    );
  }
}












// Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SafeArea(
//         child: Scaffold(
//             appBar: AppBar(
//                 title: Text(widget.username),
//                 leading: CircleAvatar(
//                   backgroundImage: NetworkImage(
//                       "https://images.unsplash.com/photo-1603570388466-eb4fe5617f0d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTd8fHdvbWVufGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"),
//                 ),
//                 actions: [
//                   IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
//                 ]),
//             body: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(),
//                 Container(
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           decoration:
//                               InputDecoration(prefixIcon: Icon(Icons.message)),
//                         ),
//                       ),
//                       IconButton(
//                           onPressed: () {
//                             // sendMessage();
//                           },
//                           icon: Icon(Icons.send))
//                     ],
//                   ),
//                 )
//               ],
//             )),
//       ),
//     );
