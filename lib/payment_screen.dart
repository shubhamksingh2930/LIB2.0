import 'package:flutter/material.dart';
import 'qr_display_screen.dart'; // Navigate to QR screen after payment

class PaymentScreen extends StatefulWidget {
  final bool isQuickBook;
  final String? selectedSeat; // Optional, for specific booking

  const PaymentScreen({super.key, required this.isQuickBook, this.selectedSeat});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod; // To store the selected payment method

  void _processPayment() {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method.')),
      );
      return;
    }

    // Simulate payment processing
    print('Processing payment via: $_selectedPaymentMethod');
    if (widget.selectedSeat != null) {
      print('For seat: ${widget.selectedSeat}');
    } else if (widget.isQuickBook) {
      print('For a quick booked seat.');
    }

    // Simulate success and navigate to QR display
    // In a real app, you'd get QR data from backend
    String qrData = "BookingID:${DateTime.now().millisecondsSinceEpoch}_Seat:${widget.selectedSeat ?? 'QuickBooked'}_User:DemoUser";
    Navigator.of(context).pushReplacement( // Use pushReplacement to not come back here
      MaterialPageRoute(builder: (context) => QrDisplayScreen(qrData: qrData)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              'PAY USING',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 30),

            // Payment method options (placeholders)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPaymentOption(Icons.credit_card, 'Card', 'Card'),
                _buildPaymentOption(Icons.account_balance_wallet, 'Wallet', 'Wallet'),
                _buildPaymentOption(Icons.paypal, 'UPI/App', 'UPI'), // Example UPI/PayPal
              ],
            ),
            const SizedBox(height: 40),

            // Dummy Amount Display
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      widget.isQuickBook ? 'Quick Book - Random Seat' : 'Selected Seat: ${widget.selectedSeat ?? "N/A"}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Amount: \$10.00', // Example amount
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),


            const Spacer(), // Pushes button to bottom

            ElevatedButton(
              onPressed: _processPayment,
              // style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)), // Using global theme
              child: const Text('Pay and Book'),
            ),
            const SizedBox(height: 20), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(IconData icon, String label, String value) {
    bool isSelected = _selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16), // Increased padding for a larger touch area
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.15) : Colors.grey[200],
              border: Border.all(
                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
                width: isSelected ? 2.0 : 1.5,
              ),
              borderRadius: BorderRadius.circular(12), // More rounded
            ),
            child: Icon(icon, size: 48, color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            )
          ),
        ],
      ),
    );
  }
}