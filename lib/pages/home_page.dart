import 'package:banking/models/model.dart';
import 'package:banking/pages/detail_page.dart';
import 'package:banking/services/service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static String id = "home_page";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BankApp> list=[];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    // connecting server
    await Network.GET(Network.API_LIST, Network.paramsEmpty()).then(parseData);
    setState(() {
      isLoading = false;
    });
  }

  void parseData(String? response) {
    if(response != null) {
      list = Network.parseResponse(response);
    } else {
      //Utils.fireSnackBar("Please try again later");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         elevation: 0,
         title: Text("Good Moning\nUserName"),
         actions: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: CircleAvatar(
               radius: 20,
               child: Icon(Icons.person),
             ),
           ),
         ],
       ),
      body: ListView(
        children: [
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            itemCount: list.length,
              itemBuilder: (context,index){
                return buildBody(context, index);
              }
          ),
          InkWell(
            onTap: (){
             Navigator.pushReplacementNamed(context, DetailPage.id);
            },
            child: Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 200,width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(15)
            ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add,size: 40,),
                  SizedBox(height: 10,),
                  Text("Add new card")
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget buildBody(BuildContext context, int index) {
    return Dismissible(
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete,color: Colors.white,),
      ),
      key: ValueKey(list[index]),
      onDismissed: (DismissDirection direction) async{
        setState(() async {
          await Network.DELETE(Network.API_ID + list[index].id.toString(), Network.paramsEmpty());
          list.removeAt(index);
        });
      },
      child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(20),
                  height: 200,width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Visa",textAlign: TextAlign.end,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                      Text("${list[index].cardnumber}",textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${list[index].username}"),
                          Text("${list[index].date}")
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
