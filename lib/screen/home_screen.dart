import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';

import 'college_list.dart';

enum SingingCharacter { Male, Female }

enum CapRound { First, Second, Third }

//base url
// final String baseURL = 'http://192.168.0.166:8080/college-predict';
final String baseURL =
    'http://192.168.0.178:8080/college-predict'; // Akash's PC IP Address

const orange = Color.fromARGB(255, 241, 171, 90);

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

final List<String> items = [
  'OPEN',
  'OBC',
  'SC',
  'ST',
  'VJ',
  'NT1',
  'NT2',
  'NT3',
  'ORPHAN',
  'General',
  'TFW',
  'EWS',
  'DEF',
  'PWD',
  'PWD1',
  'PWD2',
  'PWD3',
  'MI',
  'SEBC',
  'DEFOPEN',
  'DEFOBC',
  'DEFROBC',
  'DEFSC',
  'PWDRNT1',
  'PWDSC',
  'PWDOBC',
  'PWDRSC',
  'PWDC',
  'PWDRNT2',
  'PWDOPEN',
  'PWDRVJ',
  'PWDROBC'
];
String? selectedcategory;

class _HomeScreenState extends State<HomeScreen> {
  SingingCharacter? _gender = SingingCharacter.Male;

  CapRound? _capRound = CapRound.First;

  // SingingCharacter? _capRound=SingingCharacter.;
  List getData = [];
  bool isLoading = false;
  final TextEditingController _percentageController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _rankController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  final FocusNode percentageFocusNode = FocusNode();
  final FocusNode rankFocusNode = FocusNode();

  Future<void> _getPrediction() async {
    if (_formkey.currentState!.validate()) {
      final String percentage = _percentageController.text;
      final String category = _categoryController.text;
      final String gender = _gender.toString().split('.').last;
      final String rank = _rankController.text;
      // final String gender = 'male'; // Hardcoded to male for this example
      final String capRound = _capRound.toString().split('.').last;

      // print(capRound);
      int cap_round = capRound == "First"
          ? 1
          : capRound == "Second"
              ? 2
              : 3;

      // print(cap_round);

      setState(() {
        isLoading = true;
      });
      // fn(page){
      final String endPoint =
          '/colleges?percentage=$percentage&category=$selectedcategory&gender=$gender&capRound=$cap_round&ranking=$rank';

      http.Response response;
      try {
        String finalURL = (baseURL + endPoint);
        print(finalURL);
        response = await http.get(Uri.parse(finalURL));
        if (response.statusCode == 200) {
          setState(() {
            isLoading = false;
            getData = json.decode(response.body);

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CollegeList(
                      getData: this.getData,
                    )));
          });
        } else if (response.statusCode == 404) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "College not found based on your detail please try again"),
              duration: Duration(seconds: 5),
              backgroundColor: Color.fromARGB(255, 187, 54, 67),
            ),
          );
        } else {
          setState(() {
            isLoading = false;
          });
          throw Exception("Failed");
        }
      } on Exception catch (_) {
        // make it explicit that a SocketException will be thrown if the network connection fails
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text("Sorry! server not responding try again later"),
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Color.fromARGB(255, 187, 54, 67),
          ),
        );
        print("Occure SocketException");
      }
    }
  }

  bool hasDigits(String str) {
    return RegExp(r'\d').hasMatch(str);
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('College Predictor'),
        backgroundColor: Color.fromARGB(255, 237, 144, 37),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // SizedBox(
          //   height: 20,
          // ),
          SingleChildScrollView(
            child: Container(
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    margin: EdgeInsets.only(
                        top: 20, left: 10, right: 10, bottom: 10),
                    child: Image.asset('assets/image/exam-flow.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // PhysicalModel(
                          //   borderRadius: BorderRadius.circular(16.0),
                          //   color: Colors.white,
                          //   elevation: 5.0,
                          //   shadowColor: Colors.black,
                          // child:
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _percentageController,
                            // focusNode: percentageFocusNode,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '  Enter Percentage',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: orange,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a percentage';
                              } else if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              } else if (double.parse(value) < 0 ||
                                  double.parse(value) > 100) {
                                return 'Please enter a percentage between 0 and 100';
                              }
                              return null;
                            },
                          ),
                          // ),
                          SizedBox(height: 30.0),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _rankController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '  Enter Rank (Optional)',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: orange,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              } else if (!value.contains(RegExp(r'^[0-9]+$'))) {
                                return 'Please enter a valid rank';
                              }
                              //else if (double.parse(value) < 0 ||
                              //     double.parse(value) > 100) {
                              //   return 'Please enter a percentage between 0 and 100';
                              // }
                              return null;
                            },
                          ),
                          SizedBox(height: 30.0),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField2(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration:
                                    InputDecoration.collapsed(hintText: ''),
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
                                                158, 34, 34, 34)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: items
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              // fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return '     Please select Category.';
                                  }
                                  return null;
                                },
                                value: selectedcategory,
                                onChanged: (value) {
                                  setState(() {
                                    selectedcategory = value as String;
                                  });
                                },
                                dropdownSearchData: DropdownSearchData(
                                  searchController: _categoryController,
                                  searchInnerWidgetHeight: 50,
                                  searchInnerWidget: Container(
                                    height: 50,
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 4,
                                      right: 8,
                                      left: 8,
                                    ),
                                    child: TextFormField(
                                      expands: true,
                                      maxLines: null,
                                      controller: _categoryController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        hintText: 'Search Category...',

                                        hintStyle:
                                            const TextStyle(fontSize: 14),
                                        // border: OutlineInputBorder(
                                        //   borderRadius:
                                        //       BorderRadius.circular(8),
                                        // ),
                                      ),
                                    ),
                                  ),
                                  searchMatchFn: (item, searchValue) {
                                    return (item.value
                                        .toString()
                                        .toLowerCase()
                                        .contains(searchValue.toLowerCase()));
                                  },
                                ),
                                onMenuStateChange: (isOpen) {
                                  if (!isOpen) {
                                    _categoryController.clear();
                                  }
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 48,
                                  // width: 450,
                                  // padding: const EdgeInsets.only(
                                  //     left: 14, right: 14),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    // border: Border.all(
                                    //   color: Colors.black26,
                                    // ),
                                    color: orange,
                                  ),
                                  elevation: 2,
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    // Icons.arrow_drop_down,
                                    Icons.keyboard_arrow_down,
                                  ),
                                  iconSize: 24,
                                  iconEnabledColor:
                                      Color.fromARGB(255, 112, 112, 112),
                                  iconDisabledColor: Colors.grey,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 210,
                                  width: 165,
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  elevation: 8,
                                  // offset: const Offset(-1, 0),
                                  offset: const Offset(208, -7),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness: MaterialStateProperty.all(5),
                                    thumbVisibility:
                                        MaterialStateProperty.all(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          // SizedBox(
                          //   width: 100,
                          // ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Cap-Round :",
                                style: TextStyle(fontSize: 17),
                              ),
                              // Expanded(
                              //     child: ListTile(
                              //   title: const Text("1"),
                              //   leading: Radio<CapRound>(
                              //     groupValue: _capRound,
                              //     value: CapRound.First,
                              //     onChanged: (CapRound? value) {
                              //       setState(() {
                              //         _capRound = value;
                              //       });
                              //     },
                              //     activeColor: orange,
                              //   ),
                              //   contentPadding: EdgeInsets.all(2),
                              // )),
                              SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width) * 0.01,
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Radio(
                                            value: CapRound.First,
                                            groupValue: _capRound,
                                            onChanged: (CapRound? value) {
                                              setState(() {
                                                _capRound = value;
                                              });
                                            },
                                            activeColor: orange,
                                          ),
                                          const Text('1'),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Radio(
                                            value: CapRound.Second,
                                            groupValue: _capRound,
                                            onChanged: (CapRound? value) {
                                              setState(() {
                                                _capRound = value;
                                              });
                                            },
                                            activeColor: orange,
                                          ),
                                          const Text('2'),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Radio(
                                                value: CapRound.Third,
                                                groupValue: _capRound,
                                                onChanged: (CapRound? value) {
                                                  setState(() {
                                                    _capRound = value;
                                                  });
                                                },
                                                activeColor: orange,
                                              ),
                                              const Text('3'),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Expanded(
                              //   child: ListTile(
                              //     title: Row(
                              //       children: <Widget>[
                              //         Radio(
                              //           value: CapRound.Second,
                              //           groupValue: _capRound,
                              //           onChanged: (CapRound? value) {
                              //             setState(() {
                              //               _capRound = value;
                              //             });
                              //           },
                              //           activeColor: orange,
                              //         ),
                              //         const Text('2'),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // Expanded(
                              //   child: ListTile(
                              //     title: Row(
                              //       children: <Widget>[
                              //         Radio(
                              //           value: CapRound.Third,
                              //           groupValue: _capRound,
                              //           onChanged: (CapRound? value) {
                              //             setState(() {
                              //               _capRound = value;
                              //             });
                              //           },
                              //           activeColor: orange,
                              //         ),
                              //         const Text('3'),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                "Gender :",
                                style: TextStyle(fontSize: 17),
                              ),
                              SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width) * 0.08,
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Row(
                                    children: <Widget>[
                                      Radio(
                                        value: SingingCharacter.Male,
                                        groupValue: _gender,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _gender = value;
                                          });
                                        },
                                        activeColor: orange,
                                      ),
                                      const Text('Male'),
                                      SizedBox(
                                        width: (MediaQuery.of(context)
                                                .size
                                                .width) *
                                            0.015,
                                      ),
                                      Radio(
                                        value: SingingCharacter.Female,
                                        groupValue: _gender,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _gender = value;
                                          });
                                        },
                                        activeColor: orange,
                                      ),
                                      const Text('Female'),
                                    ],
                                  ),
                                  // const Text("Male"),
                                  // leading: Radio<SingingCharacter>(
                                  //   value: SingingCharacter.Male,
                                  //   groupValue: _gender,
                                  //   onChanged: (SingingCharacter? value) {
                                  //     setState(() {
                                  //       _gender = value;
                                  //     });
                                  //   },
                                  //   activeColor: orange,
                                  // ),
                                ),
                              ),
                              // SizedBox(width: 16.0),
                              // SizedBox(width: 8.0),
                              // Expanded(
                              //   child: ListTile(
                              //     title: Row(
                              //       children: <Widget>[
                              //         Radio(
                              //           value: SingingCharacter.Female,
                              //           groupValue: _gender,
                              //           onChanged: (SingingCharacter? value) {
                              //             setState(() {
                              //               _gender = value;
                              //             });
                              //           },
                              //           activeColor: orange,
                              //         ),
                              //         const Text('Female'),
                              //       ],
                              //     ),
                              //     // const Text("Female"),
                              //     // leading: Radio<SingingCharacter>(
                              //     //   groupValue: _gender,
                              //     //   value: SingingCharacter.Female,
                              //     //   onChanged: (SingingCharacter? value) {
                              //     //     setState(() {
                              //     //       _gender = value;
                              //     //     });
                              //     //   },
                              //     //   activeColor: orange,
                              //     // ),
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(height: 35.0),
                          Center(
                            child: ElevatedButton(
                              onPressed: _getPrediction,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 13),
                                child: Text(
                                  'Predict',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 83, 80, 80)),
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(orange),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(orange),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
