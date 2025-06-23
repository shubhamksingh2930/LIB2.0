// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- User Management ---
  Future<void> saveUser(String uid, String name, String email) async {
    DocumentReference userDocRef = _db.collection('users').doc(uid);

    try {
      DocumentSnapshot userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        // User is new, create their document
        await userDocRef.set({
          'uid': uid, // Storing uid again can be redundant if doc ID is uid, but explicit
          'name': name,
          'email': email, // Store email
          'createdAt': Timestamp.now(), // Firestore server timestamp
          'lastLogin': Timestamp.now(),
          // 'role': 'user', // Default role, if you add roles later
        });
        print('New user created in Firestore: $uid - $name');
      } else {
        // User exists, update last login time.
        // Optionally update name/email if they changed and you allow it.
        Map<String, dynamic> dataToUpdate = {'lastLogin': Timestamp.now()};
        
        // Only update name if a non-empty name is provided and it's different from stored one
        // Or if the stored name is null/empty and a new one is provided
        var storedName = (userDoc.data() as Map<String, dynamic>)['name'];
        if (name.isNotEmpty && name != storedName) {
          dataToUpdate['name'] = name;
        }

        // Similarly for email, though email usually doesn't change after creation via Auth
        var storedEmail = (userDoc.data() as Map<String, dynamic>)['email'];
        if (email.isNotEmpty && email != storedEmail) {
           dataToUpdate['email'] = email;
        }

        if (dataToUpdate.length > 1) { // If more than just lastLogin is being updated
            await userDocRef.update(dataToUpdate);
            print('User details updated in Firestore: $uid');
        } else {
            await userDocRef.update({'lastLogin': Timestamp.now()}); // Just update lastLogin
            print('User last login updated in Firestore: $uid');
        }
      }
    } catch (e) {
      print('Error saving/updating user to Firestore: $e');
      rethrow; // Rethrow to be caught by calling UI if needed
    }
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  // --- Booking Management (Placeholders - to be implemented later) ---
  Future<void> createBooking(Map<String, dynamic> bookingData) async {
    try {
      // Ensure bookingData includes the userId
      if (bookingData['userId'] == null) {
        print('Error: userId is required to create a booking.');
        return;
      }
      await _db.collection('bookings').add({
        ...bookingData,
        'createdAt': Timestamp.now(),
      });
      print('Booking created successfully.');
    } catch (e) {
      print('Error creating booking: $e');
      rethrow;
    }
  }

  Future<void> updateSeatStatus(String eventId, String seatId, String status, String? userId) async {
    // This structure is more complex. You'd likely have a subcollection for seats under an event,
    // or a dedicated 'seat_status' collection.
    // For now, this is a placeholder.
    print('Updating seat $seatId for event $eventId to $status by user $userId (Firestore logic to be implemented)');
    // Example: await _db.collection('events').doc(eventId).collection('seats').doc(seatId).update({'status': status, 'bookedBy': userId});
    return Future.value();
  }
}