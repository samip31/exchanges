import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerPage extends StatefulWidget {
  const ShimmerPage({Key? key}) : super(key: key);

  @override
  State<ShimmerPage> createState() => _ShimmerPageState();
}

class _ShimmerPageState extends State<ShimmerPage> {
  @override
  Widget build(BuildContext context) {
    return  Container(
        padding: EdgeInsets.all(8),
        child: Container(
          color: Colors.grey.shade200,
          child: Column(
            children: [
              Shimmer.fromColors(child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                ),
                margin: EdgeInsets.all(15),
                height: 30,

                width: 150,
              ), baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context,position) {
                    return Shimmer.fromColors(

                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade400,width: 5),

                        ),
                        child: ListTile(
                          leading: Container(


                            height: 100,


                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey, width: 2.0),

                                color: Colors.grey.shade700,
                              shape: BoxShape.circle
                            ),
                            child: CircleAvatar(

                              radius: 28,
                            ),
                          ),
                          title: Container(
                            height: 30,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          trailing: Container(
                            height: 30,
                            width: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: 7,
                ),
              ),
            ],
          ),
        ),
    );
  }
}
