import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_avatar/random_avatar.dart';
import '../../../const_config/color_config.dart';
import '../../../models/user_model.dart';


class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> with WidgetsBindingObserver {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final pageViewController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus('online', DateTime.now());
  }

  void setStatus(String status, DateTime time) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      "status": status,
      "lastOnline": time,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.scaffoldColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
            var documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var doc = documents[index];
                var user = UserData.fromMap(doc.data() as Map<String, dynamic>);
                if (user.uuid != auth.currentUser!.uid) {
                  return ListTile(
                    leading: RandomAvatar(user.name!, trBackground: false),
                    title: Text(user.name ?? "Unknown"),
                    subtitle: Text('Last Online: ${user.lastOnline}'),
                  );
                }
                return SizedBox.shrink();
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setStatus('online', DateTime.now());
    } else {
      setStatus('offline', DateTime.now());
    }
  }
}

