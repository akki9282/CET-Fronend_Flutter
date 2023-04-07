// PAGINATION

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:number_paginator/number_paginator.dart';
import 'dart:convert';

import 'home_screen.dart';

class CollegeList extends StatefulWidget {
  List getData = [];

  CollegeList({
    required this.getData,
  });
  @override
  State<CollegeList> createState() => _CollegeListState();
}

class _CollegeListState extends State<CollegeList> {
  List all_college_list = [];
  List filtered_list = [];
  List sub_list = [];

  int currentPage = 0;
  int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    this.all_college_list = this.filtered_list = widget.getData;
// sub_list = filtered_list.sublist(0, 9);
    int startIndex = currentPage * itemsPerPage;
    int endIndex = (currentPage + 1) * itemsPerPage;
    sub_list = filtered_list.sublist(startIndex, endIndex);
  }

  TextEditingController _searchController = TextEditingController();
  String _search = '';
  bool isListEmpty = false;

  void _filter(String value) {
    setState(() {
      if (value.isEmpty) {
        filtered_list = all_college_list;
        getCurrentPageItems();
      } else {
        filtered_list = all_college_list
            .where((clg) =>
                clg['college_name']
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase()) ||
                clg['branch_name']
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase()))
            .toList();
        getCurrentPageItems();
      }

      if (filtered_list.isEmpty) {
        isListEmpty = true;
        sub_list = [];
      } else {
        isListEmpty = false;
      }
    });
  }

// int startIndex = currentPage * itemsPerPage;
// int endIndex = (currentPage + 1) * itemsPerPage;
// sub_list = filtered_list.sublist(startIndex, endIndex);
  void getCurrentPageItems() {
    int startIndex = currentPage * itemsPerPage;
    int endIndex = (currentPage + 1) * itemsPerPage;
    if (filtered_list.length < endIndex) {
      sub_list = filtered_list.sublist(startIndex, filtered_list.length);
    } else {
      sub_list = filtered_list.sublist(startIndex, endIndex);
    }
  }

  int totalPages = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    totalPages = (filtered_list.length / itemsPerPage).ceil();

    var pages = List.generate(
      totalPages,
      (index) => Container(
          // color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
        children: <Widget>[
          // Padding(
          //     padding: const EdgeInsets.all(10.0),
          //     child: TextFormField(
          //       controller: _searchController,
          //       decoration: InputDecoration(
          //         hintText: 'Search College Or Branch',
          //         prefixIcon: Icon(Icons.search),
          //         suffixIcon: IconButton(
          //           onPressed: () => setState(() {
          //             _searchController.clear();
          //             _filter('');
          //           }),
          //           icon: Icon(Icons.clear),
          //         ),
          //         contentPadding: EdgeInsets.symmetric(
          //             horizontal: 16.0, vertical: 8.0),
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(16.0),
          //           borderSide: BorderSide.none,
          //         ),
          //         filled: true,
          //         fillColor: Color.fromARGB(148, 224, 224, 224),
          //       ),
          //       onChanged: (String? value) {
          //         setState(() {
          //           _search = value.toString();

          //           _filter(_search);
          //         });
          //       },
          //     )),
          // isListEmpty
          //     ? Center(
          //         child: Padding(
          //           padding: const EdgeInsets.all(10.0),
          //           child: const Text("Search Result Not Found",
          //               style: TextStyle(
          //                 fontSize: 20,
          //               )),
          //         ),
          //       )
          //     :
          Expanded(
              child: ListView.builder(
            itemCount: sub_list.length,
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
                      "${sub_list[index]['college_ID'].toString()} : ${sub_list[index]['college_name'].toString()}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 8.0),
                          Text(
                            "Branch Name: ${sub_list[index]["branch_name"].toString()}",
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            "College Type: ${sub_list[index]["type"].toString()}",
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            "Cut-Off: ${sub_list[index]["percentage"].toString()}",
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            "Category: ${sub_list[index]["category_name"].toString()}",
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            "City: ${sub_list[index]["city"].toString()}",
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            "Cap Round: ${sub_list[index]["cap_round"].toString()}",
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(height: 8.0),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ))
        ],
      )),
    );
    return Material(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/image/_ (1).jpeg'),
                fit: BoxFit.cover)),
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
              title: Text('College List'),
              // title: Image.asset('assets/image/Keto Pumpkin Bread.jpeg',
              //     fit: BoxFit.cover),
              backgroundColor: Color.fromARGB(255, 237, 144, 37),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              shadowColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search Here',
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() {
                                _searchController.clear();
                                _filter('');
                              }),
                              icon: Icon(Icons.clear),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(148, 224, 224, 224),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              _search = value.toString();

                              _filter(_search);
                            });
                          },
                        )),
                    isListEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: const Text("Search Result Not Found",
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                            ),
                          )
                        : Container(
                            height:
                                ((MediaQuery.of(context).size.height) - 150),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: pages[currentPage],
                                  ),
                                ),
                                NumberPaginator(
                                  numberPages: totalPages,
                                  onPageChange: (index) {
                                    setState(() {
                                      currentPage = index;
                                      getCurrentPageItems();
                                    });
                                  },
                                  config: NumberPaginatorUIConfig(
                                    buttonSelectedBackgroundColor:
                                        Color.fromARGB(255, 250, 250, 250),
                                    buttonSelectedForegroundColor:
                                        Color.fromARGB(255, 10, 10, 10),
                                    buttonUnselectedForegroundColor:
                                        Color.fromARGB(255, 252, 249, 246),
                                  ),
                                ),
                              ],
                            ),
                          )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
