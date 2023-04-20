import 'package:college_predict/screen/home_screen.dart';
import 'package:flutter/material.dart';

class CollegeDetails extends StatefulWidget {
  List all_branch = [];
  CollegeDetails({required this.all_branch});
  @override
  State<StatefulWidget> createState() {
    return _CollegeDetailsState();
  }
}

class _CollegeDetailsState extends State<CollegeDetails> {
  List all_branch = [];

  @override
  void initState() {
    super.initState();
    this.all_branch = widget.all_branch;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/image/_ (1).jpeg'), fit: BoxFit.cover)),
      child: Scaffold(
          // appBar: AppBar(
          // title: Text('Services'),
          // backgroundColor: Color.fromARGB(255, 237, 144, 37),
          // leading: IconButton(
          // icon: const Icon(Icons.arrow_back),
          // onPressed: () => Navigator.pop(context),
          // ),
          // ),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Other Branches'),
            // title: Image.asset('assets/image/Keto Pumpkin Bread.jpeg',
            //     fit: BoxFit.cover),
            backgroundColor: Color.fromARGB(255, 237, 144, 37),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            // shadowColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: this.all_branch.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: const Text("Search Result Not Found.",
                        style: TextStyle(fontSize: 20, color: Colors.red)),
                  ),
                )
              : Container(
                  // color: Color.fromARGB(255, 255, 255, 255),
                  child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(162, 224, 224,
                              224), // Updated background color to blue
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              "${all_branch[0]['college_name'].toString()}",
                              style: TextStyle(
                                fontWeight: FontWeight
                                    .w500, // Updated font weight to FontWeight.bold
                                fontSize: 17.0, // Updated font size to 24.0
                                color: Color.fromARGB(255, 0, 0,
                                    0), // Updated text color to white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        color: Color.fromARGB(164, 255, 255, 255),
                        thickness: 1.5,
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemCount: all_branch.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              // side: BorderSide(
                              //   color: Colors.greenAccent,
                              // ),
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            // color: Colors.transparent,
                            color: Color.fromARGB(162, 224, 224, 224),
                            // color: ,
                            child: ExpansionTile(
                              title: Text(
                                "Branch Name: ${all_branch[index]["branch_name"].toString()}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        SizedBox(height: 4.0),
                                        Text(
                                          "Cut-Off: ${all_branch[index]["percentage"].toString()}",
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                        SizedBox(height: 4.0),
                                        Text(
                                          "Category: ${all_branch[index]["category_name"].toString()}",
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                        SizedBox(height: 4.0),
                                        Text(
                                          "Cap Round: ${all_branch[index]["cap_round"].toString()}",
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                        SizedBox(height: 8.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ))
                  ],
                ))),
    ));
  }
}
