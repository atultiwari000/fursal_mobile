import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/venue.dart';

class VenueMapView extends StatelessWidget {
  final List<Venue> venues;
  final Venue? selectedVenue;
  final Function(Venue) onVenueSelected;

  const VenueMapView({
    super.key,
    required this.venues,
    this.selectedVenue,
    required this.onVenueSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Default center (Kathmandu) if no venues or selected venue
    LatLng center = const LatLng(27.7172, 85.3240);
    double zoom = 13.0;

    if (selectedVenue != null) {
      center = LatLng(selectedVenue!.latitude, selectedVenue!.longitude);
      zoom = 15.0;
    } else if (venues.isNotEmpty) {
      // Center on the first venue if available
      center = LatLng(venues.first.latitude, venues.first.longitude);
    }

    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: zoom,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.fursal_mobile',
        ),
        MarkerLayer(
          markers: venues.map((venue) {
            final isSelected = venue.id == selectedVenue?.id;
            return Marker(
              point: LatLng(venue.latitude, venue.longitude),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => onVenueSelected(venue),
                child: Icon(
                  Icons.location_on,
                  color: isSelected ? Colors.red : Colors.green,
                  size: 40,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
