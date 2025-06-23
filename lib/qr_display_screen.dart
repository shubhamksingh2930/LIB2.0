import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'user_dashboard_screen.dart'; // To navigate back

class QrDisplayScreen extends StatelessWidget {
  final String qrData;

  const QrDisplayScreen({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Booking QR Code'),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Booking Confirmed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Scan this QR code at the venue entrance.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Center( // Center the QrImageView
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 280.0, // Slightly larger
                  gapless: false,
                  // embeddedImage: const AssetImage('assets/images/app_logo_small.png'), // Optional: Ensure this asset exists
                  // embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(50, 50)),
                  errorStateBuilder: (cxt, err) {
                    return const Center(
                      child: Text(
                        'Uh oh! Error generating QR code.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Details: $qrData',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Done (Back to Dashboard)'),
                onPressed: () {
                  // Navigate back to the user dashboard (or a relevant screen)
                  // Popping until first route and then pushing replacement is a common way
                  // to reset navigation stack to a "home" or "dashboard" state.
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const UserDashboardScreen()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('QR code would be saved to your device (simulated).')),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}