import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'logic.dart';
import 'modalclass.dart';

class DetailPage extends StatefulWidget {
  late String name;
  late String iso3;
  

  DetailPage(this.name,this.iso3);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future totalRates;
  TooltipBehavior tooltipBehavior = TooltipBehavior();
  late TrackballBehavior trackballBehavior ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
    tooltipBehavior = TooltipBehavior(enable: true,);
    trackballBehavior = TrackballBehavior(
      enable: true,
      builder: (BuildContext context, TrackballDetails trackballDetails) {
        return Container(
          height: 60,
          width: 150,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 8, 22, 0.75),
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: CircleAvatar(

                    backgroundImage: AssetImage('assets/${widget.iso3}.png',),

                    radius: 20,
                  )
              ),
              Center(
                  child: Container(
                      padding: EdgeInsets.only(top: 11, left: 7),
                      height: 60,
                      width: 100,
                      child: Text(
                          '${trackballDetails.point!.x.toString()} : ${trackballDetails.point!.y.toString()}',
                          style: TextStyle(
                              fontSize: 13,
                              color: Color.fromRGBO(255, 255, 255, 1)
                          )
                      )
                  )
              )
            ],
          ),
        );
      },
    );
  }

  initialize() {
    totalRates = Logic().getApiTotal();

  }

  @override
  Widget build(BuildContext context) {
    print(totalRates);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade700,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: widget.iso3,
              child: CircleAvatar(

                backgroundImage: AssetImage('assets/${widget.iso3}.png',),

                radius: 20,
              ),
            ),
            SizedBox(width: 5,),
            Text(widget.name,
              style: TextStyle(
                  color: Colors.white
              ),),
          ],

        )
      ),
      body: FutureBuilder(
          future: totalRates,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Model> model_list = [];

              for (int i = 0; i < snapshot.data.data.payload.length; i++) {
                for (int j = 0;
                    j < snapshot.data.data.payload[i].rates.length;
                    j++) {
                  if (snapshot.data.data.payload[i].rates[j].currency.name ==
                      widget.name) {
                    model_list.add(Model(
                      date: snapshot.data.data.payload[i].date,
                      buy: snapshot.data.data.payload[i].rates[j].buy,
                      sell: snapshot.data.data.payload[i].rates[j].sell,
                      name:
                          snapshot.data.data.payload[i].rates[j].currency.name,
                      unit:
                          snapshot.data.data.payload[i].rates[j].currency.unit,
                    ));
                    print(model_list[i].name);
                  }
                }
              }
              List sell_list=[];
              for(int i=0;i<model_list.length;i++){
                sell_list.add(double.parse(model_list[i].sell));
              }
              double min = sell_list.reduce( (current, next) => current < next ? current : next);
              double max = sell_list.reduce((a, b) => a > b ? a : b);
              return SfCartesianChart(



            tooltipBehavior: tooltipBehavior,
                trackballBehavior: trackballBehavior,

                legend: Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                  position: LegendPosition.bottom,
                ),

                title: ChartTitle(text: "Daily rates of ${widget.name} for last month"),
                primaryXAxis: CategoryAxis(
                  edgeLabelPlacement: EdgeLabelPlacement.hide,
                  isVisible: true,
                  minimum: 0,
                  maximum: 32,
                  title: AxisTitle(text: 'Date'),
                ),
                primaryYAxis: NumericAxis(
                  isVisible: true,
                  minimum: min - 5,
                  maximum: max + 5,
                  title: AxisTitle(text: 'Rate'),

                ),

                series: <LineSeries<Model, dynamic>>[
                  LineSeries<Model,dynamic>(
                    dataSource: model_list,
                    xValueMapper: (Model model, _) => model.date,
                    yValueMapper: (Model model, _) => num.parse(model.sell),
                    color: double.parse(model_list[0].sell)>
                        double.parse(model_list[model_list.length-1].sell)? Colors.red:Colors.green,
                    name: 'Rate',
                    dataLabelSettings: DataLabelSettings(

                      isVisible: false,
                      labelAlignment: ChartDataLabelAlignment.middle,

                    ),

                    enableTooltip: true,


                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  Shimmer.fromColors(child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    margin: EdgeInsets.all(15),
                    height: 30,

                    width: 250,
                  ), baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,),

                  Expanded(
                    child: Shimmer.fromColors(

                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,

                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.symmetric(vertical: 10,
                            horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,

                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade400,width: 5),

                            ),

                          ),
                        ),
                  )

                ],
              );
            }
          }),
    );
  }
}

