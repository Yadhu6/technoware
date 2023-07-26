import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'modelclass/users.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UserModel> dataList = [];
  List<UserModel> filteredDataList = []; // For storing the filtered data
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
    try {
      var url = Uri.parse("http://www.mocky.io/v2/5d565297300000680030a986");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> decodedData = json.decode(response.body);
        setState(() {
          dataList = decodedData.map((item) => UserModel.fromJson(item)).toList();
          filteredDataList = dataList; // Initially, the filtered list is the same as the data list
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _filterDataList(String searchQuery) {
    setState(() {
      // Filter the dataList based on the searchQuery
      filteredDataList = dataList
          .where((user) => user.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Employee List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterDataList,
              decoration: InputDecoration(
                labelText: 'Search by Name',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDataList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: filteredDataList[index].profileImage,
                      placeholder: (context, url) => CircularProgressIndicator(), // Show a loading indicator while the image loads
                      errorWidget: (context, url, error) => Icon(Icons.error), // Show an error icon if the image fails to load
                    ),
                    title: Text(filteredDataList[index].name),
                    subtitle: Text(filteredDataList[index].email),
                    onTap: () {
                      // Handle item tap if needed
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}