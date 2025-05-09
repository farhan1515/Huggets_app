import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huggets_app/models/attendence.dart';
import '../models/customer.dart';
import '../models/plan.dart';
import '../models/notification.dart' as app;
import 'dart:developer' as developer;

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Customer operations
  Future<void> addCustomer(Customer customer) async {
    try {
      developer.log('Adding customer: ${customer.toMap()}');
      await _firestore
          .collection('customers')
          .doc(customer.id)
          .set(customer.toMap());
      developer.log('Customer added successfully');
    } catch (e, stackTrace) {
      developer.log('Error adding customer: $e',
          error: e, stackTrace: stackTrace);
      throw Exception('Failed to add customer: $e');
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    await _firestore
        .collection('customers')
        .doc(customer.id)
        .update(customer.toMap());
  }

  Future<void> deleteCustomer(String id) async {
    await _firestore.collection('customers').doc(id).delete();
  }

  Stream<List<Customer>> getCustomers() {
    return _firestore.collection('customers').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Customer.fromMap(doc.data())).toList());
  }

  // Plan operations
  Future<void> addPlan(Plan plan) async {
    await _firestore.collection('plans').doc(plan.id).set(plan.toMap());
  }

  Stream<List<Plan>> getPlans() {
    return _firestore.collection('plans').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Plan.fromMap(doc.data())).toList());
  }

  // Attendance operations
  Future<void> addAttendance(Attendance attendance) async {
    await _firestore
        .collection('attendance')
        .doc(attendance.id)
        .set(attendance.toMap());
  }

  Future<bool> hasCheckedInToday(String customerId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    final snapshot = await _firestore
        .collection('attendance')
        .where('customerId', isEqualTo: customerId)
        .where('timestamp',
            isGreaterThanOrEqualTo: startOfDay.toIso8601String())
        .where('timestamp', isLessThan: endOfDay.toIso8601String())
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Stream<List<Attendance>> getAttendanceForCustomer(String customerId) {
    return _firestore
        .collection('attendance')
        .where('customerId', isEqualTo: customerId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Attendance.fromMap(doc.data()))
            .toList());
  }

  Future<DateTime?> getLastAttendance(String customerId) async {
    final snapshot = await _firestore
        .collection('attendance')
        .where('customerId', isEqualTo: customerId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return DateTime.parse(snapshot.docs.first.data()['timestamp']);
  }

  // Notification operations
  Future<void> addNotification(app.Notification notification) async {
    await _firestore
        .collection('notifications')
        .doc(notification.id)
        .set(notification.toMap());
  }

  Stream<List<app.Notification>> getNotifications() {
    return _firestore.collection('notifications').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => app.Notification.fromMap(doc.data()))
            .toList());
  }

  // Birthday check
  Future<List<Customer>> getBirthdayCustomers() async {
    final today = DateTime.now();
    final customers = await _firestore.collection('customers').get();

    return customers.docs
        .map((doc) => Customer.fromMap(doc.data()))
        .where((customer) {
      final dob = customer.dateOfBirth;
      return dob.month == today.month && dob.day == today.day;
    }).toList();
  }
}
