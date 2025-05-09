import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:huggets_app/providers/customer_provider.dart';
import '../models/notification.dart';

final notificationProvider = StreamProvider<List<Notification>>((ref) {
  return ref.watch(firebaseServiceProvider).getNotifications();
});