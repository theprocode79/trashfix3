import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:trashfix2/providers/store_provider.dart';
import 'package:trashfix2/screens/shop_item_screen.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<StoreProvider>(
        builder: (context, dataProvider, _) {
          return StreamBuilder<QuerySnapshot>(
            stream: dataProvider.dataStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<QueryDocumentSnapshot> documents =
                    snapshot.data!.docs;

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data =
                        documents[index].data() as Map<String, dynamic>;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShopItemScreen(data: data),
                          ),
                        );
                      },
                      child: GridTile(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(data['image_url']),
                            const SizedBox(height: 5),
                            Text(
                              data['name'],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(data['amount']),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        },
      ),
    );
  }
}
