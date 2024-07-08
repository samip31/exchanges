import 'package:flutter/material.dart';
import 'package:jan31/detail.dart';
import 'package:jan31/logic.dart';
import 'package:jan31/shimmer.dart';
import 'package:shimmer/shimmer.dart';
import 'model.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedValue = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<String> items =
  List.generate(30, (index) => DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: index))));
  late Future exchanges;
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
    exchanges = logic.getApi(selectedValue);
    total_rates = logic.getApiTotal();
  }
  loadMoreData(exchange) async {
    int nextPage = currentPage + 1;
    var newData = await logic.getApi(selectedValue);
    setState(() {
      print(newData.pagination!.links.prev);
      print("Previous");
      exchanges = Future.value(Exchange(
        data: Data(
          payload: [...exchange.data!.payload!, ...newData.data!.payload!],
        ),
      ));
      currentPage = nextPage; // Update the current page
    });
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
              Text("Exchange Rates"),
              SizedBox(width: 10,),
              Container(
                child: DropdownButton(
                  dropdownColor: Colors.grey.shade700,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                  ),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  value: selectedValue,
                  onChanged: (newValue) {
                    setState(() {
                      selectedValue = newValue!;
                      initialize();
                    });
                  },
                  items: items.map((location) {
                    return DropdownMenuItem(
                      child: new Text(location),
                      value: location,
                    );
                  }).toList(),
                ),
              ),
            ]
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: exchanges,
          builder: (context, snapshot) {
            var currency = snapshot.hasData ? snapshot.data!.data!.payload![0].rates : "";

            return snapshot.hasData
                ? NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                    // Reached the end of the list, load more data
                    print("Loading..........");
                    loadMoreData(snapshot.data);
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
                      Text(
                        snapshot.data.data.payload[index].date,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, position) {
                          print(
                              (double.parse(currency[position].sell) /
                                  (currency[position].currency.unit))
                                  .toStringAsFixed(2));

                          return InkWell(
                            splashColor: Colors.red,
                            highlightColor: Colors.red,
                            focusColor: Colors.red,
                            onTap: () {
                              print("hello123");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    currency[position].currency.name,
                                    currency[position].currency.iso3,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.symmetric(vertical: 10),
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
                              child: ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey, width: 2.0),
                                  ),
                                  child: Hero(
                                    tag: currency[position].currency.iso3,
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(
                                        "assets/${currency[position].currency.iso3}.png",
                                      ),
                                      radius: 28.0,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  currency[position].currency.iso3,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                trailing: Text(
                                  (double.parse(currency[position].sell) / (currency[position].currency.unit))
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: snapshot.data.data.payload[0].rates.length,
                      ),
                    ],
                  ),
                );
              },
              itemCount: snapshot.data.data.payload.length,
            )
            )
                : ShimmerPage();
          },
        ),
      ),
    );
  }
}