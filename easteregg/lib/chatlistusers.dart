import 'package:flutter/material.dart';
import 'package:meeting/services/api.dart';
import 'package:meeting/model/user_model.dart';
import 'package:meeting/services/api.dart';
import 'constants/color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chatlistusers extends StatefulWidget {
  const Chatlistusers({super.key});

  @override
  State<Chatlistusers> createState() => _ChatlistusersState();
}

class _ChatlistusersState extends State<Chatlistusers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Handle filter button press
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 16),
              child: MessageList(),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomRow(),
    );
  }
}

class SearchInput extends StatefulWidget {
  final Function(String) onSearch;

  SearchInput({required this.onSearch});

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.search),
          ),
          Expanded(
            child: TextFormField(
              controller: _searchController,
              onChanged: widget.onSearch,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search by name',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageList extends StatefulWidget {
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  List<ProfileUser> pdata = [];
  List<ProfileUser> filteredData = [];
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    pdata = await Api.getMatchUser();
    setState(() {
      isloading = false;
      filteredData = pdata;
    });
  }

  ///
  void searchByName(String query) {
    setState(() {
      if (query.isEmpty) {
        // Show all users if the query is empty
        filteredData = pdata;
      } else {
        filteredData = pdata
            .where((user) =>
                user.firstname!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

/*
  void searchByName(String query) {
    setState(() {
      if (query.isEmpty) {
        // Show all users if the query is empty
        filteredData = pdata;
      } else {
        filteredData = pdata
            .where((user) =>
                user.firstname!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
*/

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        SearchInput(onSearch: searchByName),
        SizedBox(
          height: 30,
        ),
        Expanded(
          child: filteredData.length == 0
              ? Container(
                  child: Center(
                      child: Text("no Friend Founded",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                            color: Colors.purple,
                          ))))
              : ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (BuildContext context, int index) {
                    ProfileUser profile = filteredData[index];
                    List imageUrls = profile.image;

                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/chatscreen',
                            arguments: profile.user);
                      },
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(
                              width: 80,
                              height: 80,
                              child: ClipOval(
                                child: imageUrls.isNotEmpty
                                    ? Image.network(
                                        '${Api.baseUrl}uploads/${imageUrls[0].toString()}',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  "${profile.firstname}",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                            subtitle: Text("message"),
                            trailing: Text("time ex:23:11"),
                          ),
                          SizedBox(height: 18),
                          if (index != filteredData.length - 1)
                            Divider(height: 1, color: Colors.grey),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class BottomRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: Icon(Icons.unarchive_rounded), onPressed: () {}),
          IconButton(icon: Icon(Icons.email), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.favorite_outline_sharp), onPressed: () {}),
          IconButton(icon: Icon(Icons.person), onPressed: () {}),
        ],
      ),
    );
  }
}
