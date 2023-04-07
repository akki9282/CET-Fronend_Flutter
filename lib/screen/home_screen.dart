// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _HomeScreenState();
//   }
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Text('helo'),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'college_list.dart';

enum SingingCharacter { Male, Female }

final String baseURL = 'http://192.168.0.166:8080/college-predict';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  SingingCharacter? _gender = SingingCharacter.Male;
  List getData = [];
  bool isLoading = false;
  final TextEditingController _percentageController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Future<void> _getPrediction() async {
    if (_formkey.currentState!.validate()) {
      final String percentage = _percentageController.text;
      final String category = _categoryController.text;
      final String gender = _gender.toString().split('.').last;
      // final String gender = 'male'; // Hardcoded to male for this example
      setState(() {
        isLoading = true;
      });
      // fn(page){
      final String endPoint =
          '/colleges?percentage=$percentage&category=$category&gender=$gender';

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
          throw Exception("Faild");
        }
      } on SocketException catch (_) {
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('College Predictor'),
          backgroundColor: Color.fromARGB(255, 237, 144, 37),
          centerTitle: true,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.vertical(
          //     bottom: Radius.circular(30),
          //   ),
          // ),
        ),
        body:
            // isLoading
            // ? Center(
            //     child: CircularProgressIndicator(
            //     backgroundColor: Colors.black,
            //   ))
            // :
            Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                color: Color.fromARGB(255, 255, 255, 255),
                child: Column(
                  children: <Widget>[
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
                            TextFormField(
                              controller: _percentageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Percentage',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Color.fromARGB(255, 241, 171, 90),
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
                            SizedBox(height: 25.0),
                            TextFormField(
                              controller: _categoryController,
                              decoration: InputDecoration(
                                hintText: 'Category',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Color.fromARGB(255, 241, 171, 90),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid category';
                                } else if (hasDigits(value)) {
                                  return 'Category should not contain number';
                                }
                                return null;
                              },
                            ),
                            // SizedBox(
                            //   height: 16.0,
                            // ),
                            // Column(
                            //   children: <Widget>[
                            //     SizedBox(
                            //       height: 16.0,
                            //     ),
                            //     ListTile(
                            //       title: const Text("Male"),
                            //       leading: Radio<SingingCharacter>(
                            //         value: SingingCharacter.Male,
                            //         groupValue: _gender,
                            //         onChanged: (SingingCharacter? value) {
                            //           setState(() {
                            //             _gender = value;
                            //           });
                            //         },
                            //       ),
                            //     ),
                            //     SizedBox(height: 16.0),
                            //     ListTile(
                            //       title: const Text("Female"),
                            //       leading: Radio<SingingCharacter>(
                            //         groupValue: _gender,
                            //         value: SingingCharacter.Female,
                            //         onChanged: (SingingCharacter? value) {
                            //           setState(() {
                            //             _gender = value;
                            //           });
                            //         },
                            //       ),
                            //     )
                            //   ],
                            // ),
                            SizedBox(height: 17.0),
                            Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: const Text("Male"),
                                    leading: Radio<SingingCharacter>(
                                      value: SingingCharacter.Male,
                                      groupValue: _gender,
                                      onChanged: (SingingCharacter? value) {
                                        setState(() {
                                          _gender = value;
                                        });
                                      },
                                      activeColor:
                                          Color.fromARGB(255, 241, 171, 90),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                Expanded(
                                  child: ListTile(
                                    title: const Text("Female"),
                                    leading: Radio<SingingCharacter>(
                                      groupValue: _gender,
                                      value: SingingCharacter.Female,
                                      onChanged: (SingingCharacter? value) {
                                        setState(() {
                                          _gender = value;
                                        });
                                      },
                                      activeColor:
                                          Color.fromARGB(255, 241, 171, 90),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 16.0),
                            Center(
                              child: ElevatedButton(
                                onPressed: _getPrediction,
                                child: Text(
                                  'Predict',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 83, 80, 80)),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 241, 171, 90)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Image.asset('assets/image/clg-1.png'),
                    Container(
                        // height: 400,
                        margin: EdgeInsets.only(
                            top: 25, left: 10, right: 10, bottom: 10),
                        // width: 170,
                        child: Center(
                          child: Image.asset('assets/image/clg-1.png'),
                        ))
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 241, 171, 90)),
                  ),
                ),
              ),
          ],
        ));
  }
}
