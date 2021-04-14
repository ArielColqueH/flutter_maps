import 'package:flutter/material.dart';
import 'package:great_places_app/screens/map_screen.dart';
import 'package:location/location.dart';
import '../helpers/location_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectedPlace;

  LocationInput(this.onSelectedPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageurl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl =
        LocationHelper.generateLocationPreviewImage(lat, lng);
    setState(() {
      _previewImageurl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentlocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude, locData.longitude);
      widget.onSelectedPlace(locData.latitude, locData.longitude);
    } catch (error) {}
  }

  Future<void> _selectOnMap() async {
    final LatLng selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectedPlace(
        selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageurl == null
              ? Text(
                  'No location chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageurl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentlocation,
              icon: Icon(Icons.location_on),
              label: Text('Current Location'),
              style: ElevatedButton.styleFrom(
                // primary: Theme.of(context).primaryColor,
                onPrimary: Theme.of(context).primaryColor,
              ),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text('Select on map'),
              style: ElevatedButton.styleFrom(
                // primary: Theme.of(context).primaryColor,
                onPrimary: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
