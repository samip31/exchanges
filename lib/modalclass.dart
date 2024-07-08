


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Footballer Names App',
      home: FootballerList(),
    );
  }
}

class FootballerList extends StatefulWidget {
  @override
  _FootballerListState createState() => _FootballerListState();
}

class _FootballerListState extends State<FootballerList> {
  List<String> footballers = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isLoading = false;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchFootballers();

    _scrollController.addListener(() {
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        if (!isLoading && currentPage < totalPages) {
          setState(() {
            isLoading = true;
            currentPage += 1;
          });
          fetchFootballers();
        }
      }
    });
  }

  Future<void> fetchFootballers() async {
    final url = Uri.parse('http://10.0.2.2:5000/footballers?page=$currentPage');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        isLoading = false;
        currentPage = jsonData['current_page'];
        totalPages = jsonData['total_pages'];
        footballers.addAll(jsonData['footballers']);
      });
    } else {
      throw Exception('Failed to load footballers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Footballer Names'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: fetchFootballers(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? _buildLoadingWidget()
                : snapshot.hasError
                ? _buildErrorWidget()
                : _buildFootballerListWidget();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Text("Error loading data. Please try again."),
    );
  }

  Widget _buildFootballerListWidget() {
    return ListView.builder(
      itemCount: footballers.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == footballers.length && isLoading) {
          return _buildLoadingWidget();
        }
        return ListTile(
          title: Text(footballers[index]),
        );
      },
      controller: _scrollController,
    );
  }
}


class Model{
  var date;
  var name;

  var sell;
  var buy;
  var unit;

  Model({this.date,this.name,this.buy,this.sell,this.unit});

}


