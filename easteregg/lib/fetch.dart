import 'package:flutter/material.dart';
import 'package:meeting/model/user_model.dart';
import 'package:meeting/services/api.dart';

class FetchData extends StatefulWidget {
  const FetchData({super.key});

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: Api.getProfileUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<ProfileUser> pdata = snapshot.data;

            return ListView.builder(
                itemCount: pdata.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Icon(Icons.storage),
                    title: Text("${pdata[index].firstname}"),
                    subtitle: Text("${pdata[index].lastname}"),
                    trailing: Text("${pdata[index].age}" + '\$'),
                  );
                });
          }
        },
      ),
    );
  }
}
