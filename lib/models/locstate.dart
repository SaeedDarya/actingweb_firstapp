import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocStateModel with ChangeNotifier {
  // Represent latest location
  Position _lastPos = Position(longitude: 0.0, latitude: 0.0);
  StreamSubscription<Position> _positionStreamSubscription;
  final List<Position> _positions = <Position>[];

  double get latitude => _lastPos.latitude;
  double get longitude => _lastPos.longitude;
  bool get isPaused => _positionStreamSubscription.isPaused;
  List<Position> get positions => _positions;

  bool isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription.isPaused);

  void addLocation(Position pos) {
    _positions.add(pos);
    _lastPos = pos;
    notifyListeners();
  }

  void toggleListening() {
    if (_positionStreamSubscription == null) {
      const LocationOptions locationOptions =
          LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 10);
      final Stream<Position> positionStream =
          Geolocator().getPositionStream(locationOptions);
      _positionStreamSubscription =
          positionStream.listen((Position position) => addLocation(position));
      _positionStreamSubscription.pause();
    }
    if (_positionStreamSubscription.isPaused) {
      _positionStreamSubscription.resume();
    } else {
      _positionStreamSubscription.pause();
    }
    notifyListeners();
  }

  void stop() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }
  }
}
