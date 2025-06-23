import 'package:flutter/material.dart';
// For actual QR Scanner, you'd import a package like 'mobile_scanner'
// import 'package:mobile_scanner/mobile_scanner.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Dummy data
  final List<Map<String, String>> _arrivedList = [
    {'name': 'Alice Smith', 'seat': '3A', 'status': 'Scanned'},
    {'name': 'Bob Johnson', 'seat': '5C', 'status': 'Scanned'},
  ];
  final List<Map<String, String>> _toBeArrivingList = [
    {'name': 'Charlie Brown', 'seat': '2B', 'status': 'Booked'},
    {'name': 'Diana Prince', 'seat': '7F', 'status': 'Booked'},
    {'name': 'Edward Nigma', 'seat': '10G', 'status': 'Booked'},
  ];

  String? _lastScannedQrData;

  // MobileScannerController? cameraController; // For actual QR scanner

  // @override
  // void initState() {
  //   super.initState();
  //   // cameraController = MobileScannerController(); // Initialize if using mobile_scanner
  // }

  // @override
  // void dispose() {
  //   // cameraController?.dispose(); // Dispose if using mobile_scanner
  //   super.dispose();
  // }

  void _simulateScanAndProcess(String qrData) {
    // Expected QR Data format: "BookingID:SOME_ID_Seat:SEAT_NO_User:USERNAME"
    setState(() {
      _lastScannedQrData = qrData;
      // Try to parse seat information (very basic parsing)
      String? seatToFind;
      if (qrData.contains("_Seat:")) {
        try {
          seatToFind = qrData.split("_Seat:")[1].split("_")[0];
        } catch (e) {
          print("Error parsing seat from QR: $e");
        }
      }

      if (seatToFind != null) {
        int indexInToBeArriving = _toBeArrivingList.indexWhere((booking) => booking['seat'] == seatToFind);

        if (indexInToBeArriving != -1) {
          Map<String, String> guest = _toBeArrivingList.removeAt(indexInToBeArriving);
          guest['status'] = 'Scanned - Arrived';
          _arrivedList.insert(0, guest); // Add to top of arrived list
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${guest['name']} (Seat ${guest['seat']}) marked as arrived! Seat turns green.'), backgroundColor: Colors.green),
          );
        } else {
          bool alreadyArrived = _arrivedList.any((booking) => booking['seat'] == seatToFind && booking['status']!.contains('Scanned'));
          if (alreadyArrived) {
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text('Guest for Seat $seatToFind already marked as arrived.')),
             );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Booking for Seat $seatToFind not found in "To Be Arriving" list.')),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid QR data format. Could not extract seat information.')),
        );
      }
    });
  }

  void _openQrScanner() {
    // This is where you would navigate to a dedicated scanner screen or show a modal with the scanner
    // For mobile_scanner, you might do something like:
    /*
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Scan QR Code')),
        body: MobileScanner(
          controller: cameraController, // Use the initialized controller
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
              _simulateScanAndProcess(barcodes.first.rawValue!);
              Navigator.pop(context); // Close scanner screen after detection
            }
          },
        ),
      ),
    ));
    */
    // For now, just simulate
    print('QR Scanner button pressed. (Implement actual scanner here)');
    // Simulate a successful scan with some dummy data matching _toBeArrivingList
    List<String> simScans = [
      "BookingID:XYZ123_Seat:2B_User:Charlie Brown",
      "BookingID:ABC789_Seat:7F_User:Diana Prince",
      "BookingID:INVALID_Seat:XX_User:Unknown" // Test invalid scan
    ];
    // Pick one randomly for simulation
    _simulateScanAndProcess(simScans[DateTime.now().second % simScans.length]);
  }

  @override
  Widget build(BuildContext context) {
    // SC6: "mangaer" (should be Manager), two lists, camera icon below
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst); // Go to splash
                // Potentially push LoginUserScreen if you want to land there
                // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginUserScreen()));
              },
              child: const Text('Logout Admin', style: TextStyle(color: Colors.white)),
            )
        ],
      ),
      body: Column(
        children: <Widget>[
          // Top section with "Arrived" and "To Be Arriving" lists
          // Using a V-shape like design is hard with standard widgets directly.
          // We can use two Expanded widgets side-by-side.
          Expanded(
            flex: 3, // Lists take more space
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserListWidget("Arrived", _arrivedList, Colors.green.shade50, Icons.how_to_reg, Colors.green),
                _buildUserListWidget("To Be Arriving", _toBeArrivingList, Colors.orange.shade50, Icons.pending_actions, Colors.orange),
              ],
            ),
          ),

          // Bottom section for Camera/QR Scanner
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            color: Colors.grey[850], // Darker background for camera section
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_lastScannedQrData != null && _lastScannedQrData!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left: 16, right: 16),
                    child: Text(
                      'Last Scan: $_lastScannedQrData',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                Material( // For inkwell effect
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _openQrScanner,
                    borderRadius: BorderRadius.circular(50),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.qr_code_scanner_rounded, size: 70, color: Colors.blueAccent.shade100),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text("Scan Guest QR", style: TextStyle(color: Colors.white70, fontSize: 14))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserListWidget(String title, List<Map<String, String>> users, Color backgroundColor, IconData headerIcon, Color headerIconColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 8, 4, 8), // Adjust margins for side-by-side
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0,2))
          ]
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(headerIcon, color: headerIconColor, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: users.isEmpty
                  ? Center(child: Text('No users here.', style: TextStyle(color: Colors.grey.shade700, fontStyle: FontStyle.italic)))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          title: Text(user['name'] ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text('Seat: ${user['seat'] ?? 'N/A'} - ${user['status'] ?? 'Unknown'}'),
                          dense: true,
                          leading: CircleAvatar(
                            backgroundColor: title == "Arrived" ? Colors.green : Colors.orangeAccent,
                            child: Text(user['name']![0], style: const TextStyle(color: Colors.white)), // First letter
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(indent: 16, endIndent: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}