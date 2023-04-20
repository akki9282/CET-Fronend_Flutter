// PAGINATION

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:number_paginator/number_paginator.dart';
import 'dart:convert';

import 'college_details.dart';
import 'home_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CollegeList extends StatefulWidget {
  List getData = [];

  CollegeList({
    required this.getData,
  });
  @override
  State<CollegeList> createState() => _CollegeListState();
}

// final List<String> item = ['OPEN', 'OBC', 'SC', 'VJ', 'NT1', 'NT2', 'NT3'];
// String? selectedcategory;

class _CollegeListState extends State<CollegeList> {
  List all_college_list = [];
  List filtered_list = [];
  List sub_list = [];
  final List<String> item = ['College Name', 'Branch', 'City', 'College Type'];
  String? selectedFilter;
  int currentPage = 0;
  int itemsPerPage = 10;

  final TextEditingController _categoryController = TextEditingController();

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

  bool searchClgName = false;
  bool searchBranch = false;
  bool searchCity = false;
  bool searchType = false;

  void _clgNameFilter(String value) {
    print('in clgNameFilter Method, $value');
    setState(() {
      if (value.isEmpty) {
        filtered_list = all_college_list;
        getCurrentPageItems();
      } else {
        filtered_list = all_college_list
            .where((clg) => clg['college_name']
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

  void _branchFilter(String value) {
    print('in branchFilter Method, $value');
    setState(() {
      if (value.isEmpty) {
        filtered_list = all_college_list;
        getCurrentPageItems();
      } else {
        filtered_list = all_college_list
            .where((clg) => clg['branch_name']
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
      // searchBranch = false;
    });
  }

  void _cityFilter(String value) {
    print('in cityFilter Method, $value');
    setState(() {
      if (value.isEmpty) {
        filtered_list = all_college_list;
        getCurrentPageItems();
      } else {
        filtered_list = all_college_list
            .where((clg) => clg['city']
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

  void _typeFilter(String value) {
    print('in cityFilter Method, $value');
    setState(() {
      if (value.isEmpty) {
        filtered_list = all_college_list;
        getCurrentPageItems();
      } else {
        filtered_list = all_college_list
            .where((clg) => clg['type']
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
      // searchCity = false;
    });
  }

  void all_branch(int c_id) {
    print(c_id);
    List all_branch = [];

    all_branch =
        all_college_list.where((clg) => clg['college_ID'] == c_id).toList();
    if (all_branch.isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CollegeDetails(
                all_branch: all_branch,
              )));
    }
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
    totalPages = ((filtered_list.length / itemsPerPage).ceil()) > 100
        ? 100
        : (filtered_list.length / itemsPerPage).ceil();

    var pages = List.generate(
      totalPages,
      (index) => Container(
          // color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
            itemCount: sub_list.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(7.4),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  color: Color.fromARGB(162, 224, 224, 224),
                  child: ExpansionTile(
                    title: Column(
                      children: [
                        Text(
                          "${sub_list[index]['college_name'].toString()}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15.5,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 0.5,
                        )
                      ],
                    ),
                    subtitle: Text(
                      "${sub_list[index]["branch_name"].toString()}",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.3,
                          color: Colors.black),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              SizedBox(height: 8.0),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: ElevatedButton(
                                      onPressed: () => all_branch(
                                          sub_list[index]['college_ID']),
                                      child: Text(
                                        '   Other \nBranches',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                175, 255, 255, 255)),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Color.fromARGB(71, 71, 179, 241),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
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
      )),
    );
    return LayoutBuilder(
      builder: (context, Constraints) {
        return Material(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/image/_ (1).jpeg'),
                    fit: BoxFit.cover)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text('College List'),
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
              body: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: selectedFilter == null
                                      ? 'Search'
                                      : 'Search $selectedFilter',
                                  prefixIcon: Icon(Icons.search),
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() {
                                      _searchController.clear();
                                      _filter('');
                                    }),
                                    icon: _searchController.text.isEmpty
                                        ? Icon(null)
                                        : Icon(Icons.clear),
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
                                    if (searchClgName == true) {
                                      _search = value.toString();
                                      _clgNameFilter(_search);
                                    } else if (searchBranch == true) {
                                      _search = value.toString();
                                      _branchFilter(_search);
                                    } else if (searchCity == true) {
                                      _search = value.toString();
                                      _cityFilter(_search);
                                    } else if (searchType == true) {
                                      _search = value.toString();
                                      _typeFilter(_search);
                                    } else {
                                      _search = value.toString();
                                      _clgNameFilter(_search);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: DropdownButton2(
                                      customButton: ImageIcon(
                                        AssetImage("assets/image/filter.png"),
                                        color:
                                            Color.fromARGB(178, 224, 224, 224),
                                        size: 35,
                                      ),
                                      isExpanded: true,
                                      hint: Row(
                                        children: const [
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Select Category',
                                              style: TextStyle(
                                                  fontSize: 15.5,
                                                  // fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 87, 86, 86)),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      items: item
                                          .map(
                                            (item) => DropdownMenuItem<String>(
                                              value: item as String,
                                              child: Text(
                                                item as String,
                                                style: const TextStyle(
                                                  fontSize: 14.5,
                                                  color: Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      value: selectedFilter,
                                      onChanged: (value) {
                                        print(
                                            'Selected Filter>> :$selectedFilter'); //chng
                                        setState(() {
                                          selectedFilter = value as String;
                                        });
                                        if (selectedFilter == 'College Name') {
                                          _searchController.clear();
                                          _filter('');
                                          searchClgName = true;
                                          searchBranch = false;
                                          searchCity = false;
                                          searchType = false;
                                        } else if (selectedFilter == 'Branch') {
                                          _searchController.clear();
                                          _filter('');
                                          searchClgName = false;
                                          searchBranch = true;
                                          searchCity = false;
                                          searchType = false;
                                        } else if (selectedFilter == 'City') {
                                          _searchController.clear();
                                          _filter('');
                                          searchClgName = false;
                                          searchBranch = false;
                                          searchCity = true;
                                          searchType = false;
                                        } else if (selectedFilter ==
                                            'College Type') {
                                          _searchController.clear();
                                          _typeFilter('');
                                          searchClgName = false;
                                          searchBranch = false;
                                          searchCity = false;
                                          searchType = true;
                                        }
                                      },
                                      onMenuStateChange: (isOpen) {
                                        if (!isOpen) {
                                          _categoryController.clear();
                                        }
                                      },
                                      /*********** */
                                      dropdownSearchData: DropdownSearchData(
                                        // searchController: _categoryController,

                                        searchInnerWidgetHeight: 50,
                                        searchInnerWidget: Container(
                                          height: 28,
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 2,
                                            right: 8,
                                            left: 8,
                                          ),
                                          child: Text(
                                            "Filter By",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),

                                            // expands: true,
                                            // maxLines: null,
                                            // controller: _categoryController,
                                            // decoration: InputDecoration(
                                            //   isDense: true,
                                            //   contentPadding:
                                            //       const EdgeInsets.symmetric(
                                            //     horizontal: 10,
                                            //     vertical: 8,
                                            //   ),
                                            //   hintText: 'Filter By..',

                                            //   hintStyle:
                                            //       const TextStyle(fontSize: 14),
                                            //   // border: OutlineInputBorder(
                                            //   //   borderRadius:
                                            //   //       BorderRadius.circular(8),
                                            //   // ),
                                            // ),
                                          ),
                                        ),
                                        // searchMatchFn: (item, searchValue) {
                                        //   return (item.value
                                        //       .toString()
                                        //       .toLowerCase()
                                        //       .contains(
                                        //           searchValue.toLowerCase(),));
                                        // },
                                      ),
                                      buttonStyleData: ButtonStyleData(
                                        height: 48,
                                        // width: 15,
                                        // padding: const EdgeInsets.only(
                                        //     left: 14, right: 14),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          // border: Border.all(
                                          //   color: Colors.black26,
                                          // ),
                                          color: orange,
                                        ),
                                        elevation: 2,
                                      ),
                                      iconStyleData: const IconStyleData(
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                        ),
                                        iconSize: 24,
                                        iconEnabledColor:
                                            Color.fromARGB(255, 112, 112, 112),
                                        iconDisabledColor: Colors.grey,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                          maxHeight: 210,
                                          width: 150,
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color: Color.fromARGB(
                                                239, 224, 224, 224),
                                          ),
                                          elevation: 8,
                                          // offset: const Offset(-1, 0),
                                          offset: const Offset(225, -7),
                                          scrollbarTheme: ScrollbarThemeData(
                                            radius: const Radius.circular(40),
                                            thickness:
                                                MaterialStateProperty.all(6),
                                            thumbVisibility:
                                                MaterialStateProperty.all(true),
                                          )),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 40,
                                        padding: EdgeInsets.only(
                                            left: 14, right: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      isListEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: const Text("Search Result Not Found.",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.red)),
                              ),
                            )
                          : Container(
                              height: ((MediaQuery.of(context).size.height) -
                                  ((MediaQuery.of(context).size.height) *
                                      0.19)),
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
                                  SizedBox(
                                    height: 4,
                                  )
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
