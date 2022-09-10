import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RateChart extends StatefulWidget {
  //RateChart({Key? key}) : super(key: key);
  static const routeName = 'rate-chart';

  @override
  State<RateChart> createState() => _RateChartState();
}

class _RateChartState extends State<RateChart> {
  final CollectionReference _sellers =
      FirebaseFirestore.instance.collection('sellers');
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Chart'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _sellers.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  //final sellers = snapshot.data!;
                  //print('sellers : ${sellers.length}');
                  return ListView.builder(
                    itemCount: streamSnapshot.data!.docs
                        .where((doc) => doc['email'] == user.email!)
                        .length,
                    itemBuilder: (context, index) {
                      var newDocs = streamSnapshot.data!.docs
                          .where((doc) => doc['email'] == user.email!)
                          .toList();
                      final DocumentSnapshot documentSnapshot = newDocs[index];
                      return GestureDetector(
                        onTap: () {},
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(documentSnapshot['email']),
                            subtitle: Text(
                                'Rate of orange per kg - ${documentSnapshot['rate']}'),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          // SizedBox(
          //   height: 20,
          // ),
          // Container(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //         padding: EdgeInsets.symmetric(vertical: 15)),
          //     onPressed: () => FirebaseAuth.instance.signOut(),
          //     child: Text('Log Out'),
          //   ),
          // )
        ],
      ),
    );
  }
}
