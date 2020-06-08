import 'package:bringit/Components/Command/your_command.dart';
import 'package:bringit/Components/drawer.dart';
import 'package:bringit/Components/google_map.dart';
import 'package:bringit/Components/loading_simple.dart';
import 'package:bringit/Entities/command.dart';
import 'package:bringit/Entities/partenaire.dart';
import 'package:bringit/Entities/user.dart';
import 'package:bringit/Services/auth.dart';
import 'package:bringit/Services/command_database.dart';
import 'package:bringit/Services/partner_database.dart';
import 'package:bringit/Services/user_database.dart';
import 'package:bringit/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final User user;
  Home({ this.user });
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool loading = false;
  int number = 0;
  final AuthService _auth = AuthService();
  BitmapDescriptor pinLocationIcon;
  
  @override
  void initState() {
    super.initState();
    setCustomMapPin();
    //_setInitPosition(widget.user);
  }
  // google map implementation
  bool mapView = true;
  GoogleMapController mapController;
  
  // app bar widget
  Widget _appBar(){
    return AppBar(
      leading: Builder(
      builder: (BuildContext context) {
        return 
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.person),
              iconSize: 30.0,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
      },
    ),
     title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 15.0),
              child: Image.asset('public/images/bringit_logo.png'),
            ),
          ),
          ],
        ),
      centerTitle: true,
      backgroundColor: Colors.greenAccent[400],
      elevation: 0.0,
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            await _auth.signOut();
          }, 
          child: Text(Constants['log_out']),
        )
      ],
    );
  }
  
  // drawer widget
  Widget _drawer(){
    return SideMenu();
  }

  // marker image
  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
    ImageConfiguration(devicePixelRatio: 2.5),
    'public/images/blueCarMarker.png');
   }
  // body widget
  Widget _bodyGoogleMap(User user){
    return MultiProvider(
      providers: [
        StreamProvider<List<Partenaire>>.value(value: PartnerDatabaseService().partnersFromStream),
        StreamProvider<List<Command>>.value(value: CommandDatabaseService().getCommandStream),
        StreamProvider<List<User>>.value(value: UserDatabaseService().getUserStream)
      ],
      child: GoogleHome(user: user),
    );
  }

  Widget _bodyCommandsList(){
    return YourCommand(idUser: widget.user.id,);
  }

  // readCSV
  Widget _readCSV(User user){
    return Padding(
      padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Number is",
            style: TextStyle(
              color: Colors.amberAccent,
              letterSpacing: 2.0,
              height: 10.0,
            )
          ),
          SizedBox(width: 10.0,),
          Text(
            "$number",
            style: TextStyle(
              color: Colors.black,
              height: 10.0,
            )
            //child: Image.asset('public/images/bringit_logo.png')
          ),
          SizedBox(width: 10.0),  
          Text(
            "$number",
            style: TextStyle(
              color: Colors.black,
              height: 10.0,
            )
            //child: Image.asset('public/images/bringit_logo.png')
          ),
          SizedBox(width: 20.0),
          FloatingActionButton(
            onPressed: () async {

              //UserDatabaseService().findUserWithEmailFromStore(user.id);
              // add product to partner
              // String jsCode = await rootBundle.loadString('public/bd/creastyle.csv');
              // List<String> linePro;
              // int docNum = 81;
              // LineSplitter.split(jsCode).map((line) async => {
              //   linePro = line.split(','),
              //   //linePro[2].replaceAll('.', ','),
              //   _auth.createProducts(docNum.toString(), linePro[0], linePro[1], double.parse(linePro[2]), ''),
              //   //_auth.createProductForPartner(docNum.toString(), '04', linePro[0], linePro[1], double.parse(linePro[2]), ''),
              //   docNum += 1
              // }).toList();
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.green[600],
      ),
        ],
      ),
  );
  }

  // HOME WIDGET
  @override
  Widget build(BuildContext context) {
    User user = widget.user;

    return loading ? LoadingSimple() : StreamProvider<List<User>>.value(
      value: UserDatabaseService(uid: user.id).getUserStream,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child:_appBar(),
        ),
        body: mapView ? _bodyGoogleMap(user) : _bodyCommandsList(),
        //body: _readCSV(user),
        drawer: _drawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              mapView = !mapView;
            });
          },
          child: Icon(Icons.swap_horizontal_circle),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, //
  ),
    );
  }
}