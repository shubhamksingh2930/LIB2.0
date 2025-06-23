import 'package:flutter/material.dart';
import 'payment_screen.dart';
import 'dart:math'; // For min function

// --- Data Models for Seat Layout (SeatType, Seat, SeatRowConfig, RoomSectionConfig) ---
// These remain the same as the previous version.
enum SeatType { regular, nil, spaceRow }

class Seat {
  final String id;
  final String displayNumber;
  final SeatType type;
  bool isBooked;

  Seat({
    required this.id,
    this.displayNumber = "",
    this.type = SeatType.regular,
    this.isBooked = false,
  });
}

class SeatRowConfig {
  final List<Seat?> seats;
  final bool isSpaceRow;
  final int numSeatsInRow;

  SeatRowConfig({required this.seats, this.isSpaceRow = false, required this.numSeatsInRow});

  factory SeatRowConfig.space() {
    return SeatRowConfig(seats: [], isSpaceRow: true, numSeatsInRow: 0);
  }
}

class RoomSectionConfig {
  final String name;
  final List<SeatRowConfig> rows;
  final int seatsPerRowVisual;

  RoomSectionConfig({required this.name, required this.rows, required this.seatsPerRowVisual});
}
// --- End Data Models ---


class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({super.key});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  String? _selectedSeatId;
  String? _selectedSeatDisplayNumber;

  late List<RoomSectionConfig> _roomLayouts;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _initializeSeatLayouts();
    // Add listener to pageController to rebuild page indicator
    _pageController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    _pageController.dispose();
    super.dispose();
  }

  void _initializeSeatLayouts() {
    // --- ROOM-1 (LOBBY-A) ---
    List<SeatRowConfig> lobbyARows = [];
    lobbyARows.add(SeatRowConfig(numSeatsInRow: 8, seats: List.generate(8, (i) {
      if (i == 0) return Seat(id: "A27", displayNumber: "27");
      if (i == 7) return Seat(id: "A20", displayNumber: "20");
      return Seat(id: "A_r1_s${7-i}"); // Unique ID for empty but bookable seat
    })));
    lobbyARows.add(SeatRowConfig.space());
    lobbyARows.add(SeatRowConfig(numSeatsInRow: 8, seats: List.generate(8, (i) {
      if (i == 0) return Seat(id: "A28", displayNumber: "28");
      if (i == 7) return Seat(id: "A34", displayNumber: "34");
      return Seat(id: "A_r2_s${7-i}");
    })));
    lobbyARows.add(SeatRowConfig(numSeatsInRow: 8, seats: List.generate(8, (i) {
      if (i == 0) return Seat(id: "A40", displayNumber: "40");
      if (i == 2) return Seat(id: "ANIL1", type: SeatType.nil, displayNumber: "NIL");
      if (i == 7) return Seat(id: "A35", displayNumber: "35");
      return Seat(id: "A_r3_s${7-i}");
    })));
    lobbyARows.add(SeatRowConfig.space());
    lobbyARows.add(SeatRowConfig(numSeatsInRow: 8, seats: List.generate(8, (i) {
      if (i == 0) return Seat(id: "A41", displayNumber: "41");
      if (i == 7) return Seat(id: "A48", displayNumber: "48");
      return Seat(id: "A_r4_s${7-i}");
    })));
    lobbyARows.add(SeatRowConfig(numSeatsInRow: 8, seats: List.generate(8, (i) {
      if (i == 0) return Seat(id: "A55", displayNumber: "55");
      if (i == 2) return Seat(id: "ANIL2", type: SeatType.nil, displayNumber: "NIL");
      if (i == 7) return Seat(id: "A49", displayNumber: "49");
      return Seat(id: "A_r5_s${7-i}");
    })));
    lobbyARows.add(SeatRowConfig.space());
     lobbyARows.add(SeatRowConfig(numSeatsInRow: 8, seats: List.generate(8, (i) {
      if (i == 0) return Seat(id: "A56", displayNumber: "56");
      if (i == 7) return Seat(id: "A63", displayNumber: "63");
      return Seat(id: "A_r6_s${7-i}");
    })));
    lobbyARows.add(SeatRowConfig(numSeatsInRow: 8, seats: List.generate(8, (i) {
      if (i == 0) return Seat(id: "A71", displayNumber: "71");
      if (i == 7) return Seat(id: "A64", displayNumber: "64");
      return Seat(id: "A_r7_s${7-i}");
    })));
    lobbyARows.add(SeatRowConfig.space());
    lobbyARows.add(SeatRowConfig(numSeatsInRow: 8, seats: List.generate(8, (i) {
      if (i == 0) return Seat(id: "A72", displayNumber: "72");
      if (i == 7) return Seat(id: "A79", displayNumber: "79");
      return Seat(id: "A_r8_s${7-i}");
    })));
    lobbyARows.add(SeatRowConfig(numSeatsInRow: 8, seats: List.generate(8, (i) {
      if (i == 0) return Seat(id: "A86", displayNumber: "86");
      if (i == 2) return Seat(id: "ANIL3", type: SeatType.nil, displayNumber: "NIL");
      if (i == 7) return Seat(id: "A80", displayNumber: "80");
      return Seat(id: "A_r9_s${7-i}");
    })));
    lobbyARows.add(SeatRowConfig.space());
    lobbyARows.add(SeatRowConfig(numSeatsInRow: 8, seats: List.generate(8, (i) {
      if (i == 0) return Seat(id: "A87", displayNumber: "87");
      if (i == 7) return Seat(id: "A94", displayNumber: "94");
      return Seat(id: "A_r10_s${7-i}");
    })));
    lobbyARows.add(SeatRowConfig(numSeatsInRow: 8, seats: List.generate(8, (i) {
      if (i == 0) return Seat(id: "A101", displayNumber: "101");
      if (i == 2) return Seat(id: "ANIL4", type: SeatType.nil, displayNumber: "NIL");
      if (i == 7) return Seat(id: "A95", displayNumber: "95");
      return Seat(id: "A_r11_s${7-i}");
    })));

    List<SeatRowConfig> lobbyBRows = [];
    lobbyBRows.add(SeatRowConfig(numSeatsInRow: 5, seats: [Seat(id: "B1", displayNumber: "1"), Seat(id: "B2", displayNumber: "2"), Seat(id: "B_r1_3"), Seat(id: "B_r1_4"), Seat(id: "B5", displayNumber: "5")]));
    lobbyBRows.add(SeatRowConfig.space());
    lobbyBRows.add(SeatRowConfig(numSeatsInRow: 5, seats: [Seat(id: "B10", displayNumber: "10"), Seat(id: "B_r2_2"), Seat(id: "B_r2_3"), Seat(id: "B_r2_4"), Seat(id: "B6", displayNumber: "6")]));
    lobbyBRows.add(SeatRowConfig(numSeatsInRow: 5, seats: [Seat(id: "B11", displayNumber: "11"), Seat(id: "B_r3_2"), Seat(id: "B_r3_3"), Seat(id: "B14", displayNumber: "14"), Seat(id: "B_r3_5")]));
    lobbyBRows.add(SeatRowConfig.space());
    lobbyBRows.add(SeatRowConfig(numSeatsInRow: 5, seats: [Seat(id: "B19", displayNumber: "19"), Seat(id: "B_r4_2"), Seat(id: "B_r4_3"), Seat(id: "B_r4_4"), Seat(id: "B15", displayNumber: "15")]));

    List<SeatRowConfig> room2Rows = [];
    // Room 2: 2 rows of 8 seats
    // Row 1 (102-109)
    room2Rows.add(SeatRowConfig(numSeatsInRow: 8, seats: List.generate(8, (i) => Seat(id: "C${102 + i}", displayNumber: (102 + i).toString()))));
    // Row 2 (119-126 based on the image showing 102 and 119 at the start of rows)
    room2Rows.add(SeatRowConfig(numSeatsInRow: 8, seats: List.generate(8, (i) => Seat(id: "C${119 + i}", displayNumber: (119 + i).toString()))));


    _roomLayouts = [
      RoomSectionConfig(name: "ROOM-1 (LOBBY-A)", rows: lobbyARows, seatsPerRowVisual: 8),
      RoomSectionConfig(name: "ROOM-1 (LOBBY-B)", rows: lobbyBRows, seatsPerRowVisual: 5),
      RoomSectionConfig(name: "ROOM-2", rows: room2Rows, seatsPerRowVisual: 8),
    ];

    final Set<String> bookedSeatIds = {'A20', 'A40', 'B5', 'C103', 'A35', 'B11', 'C120', 'A_r1_s2', 'B_r2_3'}; // Book some empty display seats
    for (var section in _roomLayouts) {
      for (var rowConfig in section.rows) {
        for (var seat in rowConfig.seats) {
          if (seat != null && bookedSeatIds.contains(seat.id)) {
            seat.isBooked = true;
          }
        }
      }
    }
  }

  // --- CORRECTED _buildSeatWidget ---
  Widget _buildSeatWidget(Seat seat, double seatSize) {
    bool isSelected = _selectedSeatId == seat.id;
    Color borderColor = Colors.black38;
    double borderWidth = 0.8;
    Widget seatContent;
    Color currentContentColor; // Will be determined by state

    if (seat.type == SeatType.nil) {
      return Container(
        margin: const EdgeInsets.all(2.0),
        width: seatSize, height: seatSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: Colors.grey.shade500, width: 0.5)
        ),
        child: const Text("NIL", style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
      );
    }

    Color seatColor;
    if (seat.isBooked) {
      seatColor = Colors.red.shade700.withOpacity(0.8);
      currentContentColor = Colors.white.withOpacity(0.7); // Color for booked seat icon/text
      seatContent = Icon(Icons.person_off_outlined, color: currentContentColor, size: seatSize * 0.6);
    } else if (isSelected) {
      seatColor = Colors.green.shade600;
      currentContentColor = Colors.white; // Color for selected seat icon/text
      seatContent = Icon(Icons.check_circle_outline, color: currentContentColor, size: seatSize * 0.6);
      borderColor = Colors.green.shade800;
      borderWidth = 1.5;
    } else { // Regular available seat
      seatColor = Colors.blueGrey.shade100.withOpacity(0.8);
      currentContentColor = Colors.blueGrey.shade800; // Color for available seat icon/text
      seatContent = seat.displayNumber.isNotEmpty
          ? Text(
              seat.displayNumber,
              style: TextStyle(color: currentContentColor, fontSize: min(seatSize * 0.35, 10.0) , fontWeight: FontWeight.bold),
            )
          : Icon(Icons.event_seat_outlined, color: Colors.blueGrey.shade600, size: seatSize * 0.6);
    }

    return GestureDetector(
      onTap: () {
        if (seat.type == SeatType.regular && !seat.isBooked) {
          setState(() {
            if (_selectedSeatId == seat.id) {
              _selectedSeatId = null;
              _selectedSeatDisplayNumber = null;
            } else {
              _selectedSeatId = seat.id;
              _selectedSeatDisplayNumber = seat.displayNumber.isNotEmpty ? seat.displayNumber : seat.id; // Use ID if no display number
            }
          });
        } else if (seat.isBooked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Seat ${seat.displayNumber.isNotEmpty ? seat.displayNumber : seat.id} is already booked.')),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(2.0),
        width: seatSize,
        height: seatSize,
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: borderColor, width: borderWidth)
        ),
        alignment: Alignment.center,
        child: seatContent,
      ),
    );
  }
  // --- End CORRECTED _buildSeatWidget ---


  Widget _buildSpaceRowWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(5.0),
      ),
      alignment: Alignment.center,
      child: const Text(
        "S P A C E",
        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w500, letterSpacing: 3, fontSize: 10),
      ),
    );
  }

  Widget _buildRoomSectionPage(RoomSectionConfig section, BoxConstraints constraints) {
    double availableWidth = constraints.maxWidth - 32; // Account for page padding
    double seatSize = (availableWidth / section.seatsPerRowVisual) - 4; // (margin * 2)
    seatSize = min(max(seatSize, 25.0), 40.0); // Min 25, Max 40 seat size

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            section.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          const Divider(height: 20, thickness: 1.5),
          ...section.rows.map((seatRowConfig) {
            if (seatRowConfig.isSpaceRow) {
              return _buildSpaceRowWidget();
            }
            List<Widget> seatWidgetsInRow = [];
            for (int i = 0; i < section.seatsPerRowVisual; i++) {
              if (i < seatRowConfig.seats.length && seatRowConfig.seats[i] != null) {
                seatWidgetsInRow.add(_buildSeatWidget(seatRowConfig.seats[i]!, seatSize));
              } else {
                // This is an empty slot in the visual grid.
                // We previously made it a non-interactive placeholder.
                // If these are meant to be "empty but selectable seats", they should be actual Seat objects in the data.
                // Assuming data definition now correctly makes all small boxes Seats:
                // This 'else' might not be hit if data is complete.
                // If it is hit, it means a visual slot has no corresponding Seat object.
                seatWidgetsInRow.add(Container(
                    margin: const EdgeInsets.all(2.0),
                    width: seatSize,
                    height: seatSize,
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Make it truly empty visually if no data
                      borderRadius: BorderRadius.circular(4.0),
                      // border: Border.all(color: Colors.grey.shade200, width: 0.5)
                    ),
                  ));
              }
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: seatWidgetsInRow,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _proceedToPayment() {
    if (_selectedSeatId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a seat to continue.')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          isQuickBook: false,
          selectedSeat: _selectedSeatDisplayNumber ?? _selectedSeatId,
        ),
      ),
    );
  }

  void _showCancelBookingDialog() {
    if (_selectedSeatId == null) return;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Cancel Selection?'),
          content: Text('Cancel selection for seat ${_selectedSeatDisplayNumber ?? _selectedSeatId}?'),
          actions: <Widget>[
            TextButton(child: const Text('No'), onPressed: () => Navigator.of(dialogContext).pop()),
            TextButton(
              child: const Text('Yes, Cancel'),
              onPressed: () {
                setState(() {
                  _selectedSeatId = null;
                  _selectedSeatDisplayNumber = null;
                });
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Seat selection cancelled.')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Seat'),
        actions: [
          if (_selectedSeatId != null)
            IconButton(
              icon: const Icon(Icons.cancel_presentation_rounded),
              tooltip: 'Cancel My Selection',
              onPressed: _showCancelBookingDialog,
            )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(5)),
            child: const Center(child: Text("SCREEN THIS SIDE", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 3))),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _roomLayouts.length,
              itemBuilder: (context, index) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return _buildRoomSectionPage(_roomLayouts[index], constraints);
                  }
                );
              },
            ),
          ),
          if (_roomLayouts.length > 1)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_roomLayouts.length, (index) {
                  // Check if controller is attached and has clients (page is built)
                  bool isActive = _pageController.hasClients &&
                                  _pageController.page?.round() == index;
                  return Container(
                    width: isActive ? 10.0 : 8.0,
                    height: isActive ? 10.0 : 8.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade400,
                    ),
                  );
                }),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 15.0, runSpacing: 8.0,
              children: [
                _buildLegendItem(Colors.blueGrey.shade100.withOpacity(0.8), 'Available'),
                _buildLegendItem(Colors.green.shade600, 'Selected'),
                _buildLegendItem(Colors.red.shade700.withOpacity(0.8), 'Booked'),
                _buildLegendItem(Colors.grey.shade400, 'NIL'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0,8.0,16.0,20.0),
            child: ElevatedButton(
              onPressed: _proceedToPayment,
              child: const Text('Pay and Book Selected Seat'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 18, height: 18, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)), margin: const EdgeInsets.only(right: 6)),
        Text(label)
      ]
    );
  }
}