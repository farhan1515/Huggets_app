import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:huggets_app/models/attendence.dart';
import 'package:huggets_app/providers/customer_provider.dart';



final attendanceProvider = StreamProvider.family<List<Attendance>, String>((ref, customerId) {
  return ref.watch(firebaseServiceProvider).getAttendanceForCustomer(customerId);
});