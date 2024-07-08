import 'package:flutter/material.dart';
import 'package:jan31/detail.dart';
import 'package:jan31/logic.dart';
import 'package:jan31/shimmer.dart';
import 'package:shimmer/shimmer.dart';
import 'model.dart';
import 'package:intl/intl.dart';


class FootballPage extends StatefulWidget {
  const FootballPage({Key? key}) : super(key: key);

  @override
  State<FootballPage> createState() => _FootballPageState();
}

class _FootballPageState extends State<FootballPage> {
  String selectedValue = DateFormat('yyyy-MM-dd').format(DateTime.now());

  late Future footballs;
  late Future total_rates;
  Logic logic = Logic();
  late ScrollController _scrollController;
  int currentPage = 1; // Keep track of the current page

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    initialize();
    _scrollController.addListener(_scrollListener);
  }

  initialize() {
    footballs =  logic.getFootballApi(currentPage);
    print("GO");
    // print(footballs);
    //
    // total_rates = logic.getApiTotal();
  }

  loadMoreFootballers(football) async {
    if(currentPage<football.totalPages){
      int nextPage = currentPage + 1;
      var newData = await logic.getFootballApi(currentPage); // Adjust the API function accordingly
      setState(() {
        print("Previous");
        footballs = Future.value(Football(footballers: [
          ...football.footballers,...newData.footballers
        ],
            totalPages: football.totalPages,
        ));

        currentPage = nextPage; // Update the current page
      });
    }

  }



  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade700,
        centerTitle: true,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Footballers"),

            ]
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: footballs,

          builder: (context, snapshot) {
            // var currency = snapshot.hasData ? snapshot.data!.data!.payload![0].rates : "";
            var names = snapshot.hasData?snapshot.data!.footballers:[];
            return snapshot.hasData
                ? NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                    // Reached the end of the list, load more data
                    print("Loading..........");
                    loadMoreFootballers(snapshot.data);
                  }
                  return false;
                },child:ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: Offset(5.0, 5.0),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(names[index].toString())
                      ,SizedBox(
                        height: 15,
                      ),

                    ],
                  ),
                );
              },
              itemCount: snapshot.data.footballers.length,

            )
            )
                : ShimmerPage();
          },
        ),
      ),
    );
  }
}