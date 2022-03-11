import 'dart:async';

import 'package:banking/models/model.dart';
import 'package:banking/pages/home_page.dart';
import 'package:banking/services/service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailPage extends StatefulWidget {
  static String id = "detail_page";
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isLoading = false;
  var cardController = TextEditingController();
  var dateController = TextEditingController();
  var svvController = TextEditingController();
  var nameController = TextEditingController();
  bool isOffline = false;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    //_connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();

  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("$e \nCouldn't check connectivity status",);
      }
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
    if (_connectionStatus == ConnectivityResult.none) {
      setState(() {
        isOffline = true;
      });
    }
    else{
      setState(() {
        isOffline = false;
      });
    }
  }

  void addCard(BuildContext context) async {
    String? card = cardController.text;
    String? date = dateController.text;
    String? svv = svvController.text;
    String? name = nameController.text;

    BankApp body = BankApp(cardnumber: card,date: date,username: name,svv: svv);
    setState(() {
      isLoading = true;
    });
    await Network.POST(Network.API_LIST, Network.paramsAdd(body));
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pushReplacementNamed(HomePage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
       title: Text("Add your Card"),
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.menu))],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Your card number"),
              TextField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: cardController,
                decoration: InputDecoration(
                    hintText: "Card number",
                ),
              ),
              SizedBox(height: 30,),
              Text("Name"),
              TextField(
                textInputAction: TextInputAction.next,
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Card number",
                ),
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        keyboardType: TextInputType.number,
                        controller: dateController,
                        decoration: InputDecoration(
                          hintText: "Expiry date",
                        ),
                      ),
                  ),
                  SizedBox(width: 30,),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: svvController,
                      decoration: InputDecoration(
                        hintText: "SVV2",
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 30,),
          MaterialButton(onPressed: (){
            if(!isOffline){
              addCard(context);
            }else{
              //Utils.fireSnackBar("Please try again later");
            }
          },
            color: Colors.blue,
            textColor: Colors.white,
          child: Text("Add Card"),
          ),
        ],
      ),
    );
  }
}

