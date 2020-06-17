import 'dart:async';
import 'dart:math';
import 'package:bringit/Components/Command/your_command.dart';
import 'package:bringit/Entities/command.dart';
import 'package:bringit/Entities/partenaire.dart';
import 'package:bringit/Entities/user.dart';
import 'package:bringit/Services/command_database.dart';
import 'package:bringit/Services/partner_database.dart';
import 'package:bringit/Services/user_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
//import 'package:geolocator/geolocator.dart';

class GoogleHome extends StatefulWidget {
  final User user;
  GoogleHome({ this.user });
  @override
  _GoogleHomeState createState() => _GoogleHomeState();
}

class _GoogleHomeState extends State<GoogleHome> {
  // stream 
  List<Partenaire> listPartners;
  List<Command> listCommands;
  List<User> listUsers;
  // google
  BitmapDescriptor pinUserLocation;
  BitmapDescriptor pinCommandWaitingLocation;
  BitmapDescriptor pinCommandTakenLocation;
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  final Map<String, Marker> _markers = {};
  bool showCommandDetails;
  String chosenPartner;
  List<Command> defautCommand;

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
    showCommandDetails = false;
    chosenPartner = null;
    defautCommand = [];
  }
  // marker image
  void setCustomMapPin() async {
    // pin for user
    pinUserLocation = await BitmapDescriptor.fromAssetImage(
    ImageConfiguration(devicePixelRatio: 2.5),
    'public/images/blueCarMarker.png');
    // pin for waiting command
    pinCommandWaitingLocation = await BitmapDescriptor.fromAssetImage(
    ImageConfiguration(devicePixelRatio: 2.5, size: Size(25.0, 25.0)),
    'public/images/shopping_cart_green.png');
    // pin for taken command
    pinCommandTakenLocation = await BitmapDescriptor.fromAssetImage(
    ImageConfiguration(devicePixelRatio: 2.5),
    'public/images/blueCarMarker.png');
   }
  // create a marker
  Marker _createMarker(String id, double lat, double long, String title, String snippet, BitmapDescriptor pinLocationIcon, Command command) {
    return Marker(
      markerId: MarkerId(id),
      position: LatLng(lat, long),
      infoWindow: InfoWindow(
        title: title,
        snippet: snippet,
        onTap: () {
          //Navigator.pushNamed(context, '/your_command', arguments: {'idUser': widget.user.id});
          setState(() {
            showCommandDetails = true;
            chosenPartner = title;
            defautCommand.clear();
            defautCommand.add(command);
            print('chosenpartner $chosenPartner');
          });
      }
      ),
      icon: pinLocationIcon ?? BitmapDescriptor.defaultMarker,
    );
  }
  // 
  Future<Marker> _getUserMarkers() async {
    //List<Placemark> userPlacemarks = [];
    try{
      //userPlacemarks = await Geolocator().placemarkFromAddress("${widget.user.adress.getAdressString()}");
      // return _createMarker(widget.user.id, userPlacemarks[0].position.latitude, userPlacemarks[0].position.longitude, 
      //                     widget.user.nom, 'Vous êtes ici', pinUserLocation);
      return _createMarker(widget.user.id, widget.user.adress.latitude, widget.user.adress.longitude, 
                          widget.user.nom, 'Vous êtes ici', pinUserLocation, null);
    }catch(e){
      print('ERROR '+e.toString());
      return null;
    }
  }
  //
  Future<Map<String,Marker>> _getCommandsMarkers(List<Command> listCommands, List<Partenaire> listPartners) async {
    try{
      Map<String,Marker> commandsMarkers = Map();
      for(Command command in listCommands) {
        Partenaire partner = PartnerDatabaseService().getPartnerFromID(command.idMagasin, listPartners);
        //List<Placemark> partnerPlaceMarks = await Geolocator().placemarkFromAddress("${partner.adress.getAdressString()}");
        //double lat = partnerPlaceMarks[0].position.latitude + (sin(commandsMarkers.length * pi / 6.0) / 200.0);
        double lat = partner.adress.latitude + (sin(commandsMarkers.length * pi / 6.0) / 180.0);
        //double long = partnerPlaceMarks[0].position.longitude + (cos(commandsMarkers.length * pi / 6.0) / 200.0);
        double long = partner.adress.longitude + (cos(commandsMarkers.length * pi / 6.0) / 180.0);
        commandsMarkers[command.id] = _createMarker(command.id, lat, long, 
                                          partner.name, '${command.totalEnEuro.toStringAsFixed(2).toString()}€ - ${command.point}point(s)',
                                          pinCommandWaitingLocation, command);
      }
      print('commandmarker length ${commandsMarkers.length}');
      return commandsMarkers;
    }catch(e) {
      print(e.toString());
      return null;
    }
  }
  List<Command> getUnfinishedCommandsOfOthers(String userID, List<Command> allCommands){
    List<Command> unfinishedCommandsOfOthers = CommandDatabaseService().getUnfinishedCommands(listCommands);
    for(Command command in CommandDatabaseService().getUnfinishedCommands(listCommands)){
      if (command.idDemandeur == userID){
        unfinishedCommandsOfOthers.remove(command);
      }
    }
    return unfinishedCommandsOfOthers;
  }
  void _onMapCreated(GoogleMapController controller) async{
    mapController = controller;
    Marker marker = await _getUserMarkers();
    Map<String,Marker> commandMarkers = await _getCommandsMarkers(getUnfinishedCommandsOfOthers(widget.user.id, listCommands), listPartners);
    setState(() {
      _markers[widget.user.id] = marker;
      commandMarkers.forEach((key, value) {
        _markers[key] = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // stream
    listPartners = Provider.of<List<Partenaire>>(context);
    listCommands = Provider.of<List<Command>>(context);
    listUsers = Provider.of<List<User>>(context);
    // User info
    final user = widget.user;
    User found = UserDatabaseService(uid: user.id).findUserWithIdFromList(user.id, listUsers);
    user.setDetails(nom: found.nom, prenom: found.prenom, adress: found.adress, tel: found.tel);
    final _userInitPosition = LatLng(user.adress.latitude, user.adress.longitude);
    // command
    //List<Command> unfinishedCommandsOfOthers = getUnfinishedCommandsOfOthers(user.id, listCommands);

    // _getPlaceMarkers(_markers);
    // Future.delayed(Duration(seconds: 3), () {});

    return showCommandDetails ?
      YourCommand(idUser: widget.user.id, defaultChoice: chosenPartner, defautCommand: defautCommand)
      :
      GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _userInitPosition,
          zoom: 15.0,
        ),
        markers: _markers.values.toSet(),
      );
  }
}