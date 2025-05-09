import 'package:local_auth/local_auth.dart';
import 'package:biometric_storage/biometric_storage.dart';

class FingerprintService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final BiometricStorage _biometricStorage = BiometricStorage();

  Future<bool> checkBiometricsAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to mark your attendance',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  Future<void> registerFingerprint(String customerId) async {
    try {
      // Store customer ID in secure biometric storage
      await _biometricStorage.write(
        label: 'gym_attendance_$customerId',
        value: customerId,
        options: StorageFileInitOptions(
          androidBiometricOnly: true,
          androidPromptInfo: const AndroidPromptInfo(
            title: 'Register Fingerprint',
            subtitle: 'For secure attendance marking',
            description: 'Register your fingerprint for gym attendance',
            negativeButton: 'Cancel',
          ),
        ),
      );
    } catch (e) {
      throw Exception('Failed to register fingerprint: $e');
    }
  }

  Future<bool> verifyFingerprint(String customerId) async {
    try {
      // First verify biometric
      final authenticated = await authenticate();
      if (!authenticated) return false;

      // Then verify the stored customer ID matches
      final storedData = await _biometricStorage.read(
        label: 'gym_attendance_$customerId',
        options: const StorageFileReadOptions(
          androidPromptInfo: AndroidPromptInfo(
            title: 'Verify Fingerprint',
            subtitle: 'For attendance verification',
            description: 'Verify your fingerprint to mark attendance',
            negativeButton: 'Cancel',
          ),
        ),
      );

      return storedData?.value == customerId;
    } catch (e) {
      return false;
    }
  }
}