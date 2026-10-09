import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

class QRCrypto {
  QRCrypto._internal();
  static QRCrypto instance = QRCrypto._internal();
  QRCrypto factory() {
    return instance;
  }

  static const int ivSize = 12;
  static const int tagSize = 16;

  /// MUST be exactly the same 32-byte key used by Java encryption.
  static const String secretKey = "POMPOMPAYVERSIONTWOENCRYPTIONKEY";

  Future<String> decrypt(String encryptedBase64) async {
    try {
      // Base64 decode
      final Uint8List decoded = base64.decode(encryptedBase64);

      // Minimum:
      // 12 bytes IV + 16 bytes authentication tag
      if (decoded.length < ivSize + tagSize) {
        throw Exception('Invalid encrypted QR data');
      }

      // ------------------------------------------
      // 1. Extract IV
      // ------------------------------------------
      final Uint8List iv = decoded.sublist(0, ivSize);

      // ------------------------------------------
      // 2. Extract encrypted data + GCM tag
      // ------------------------------------------
      final Uint8List encryptedWithTag = decoded.sublist(ivSize);

      // Java Cipher.doFinal() returns:
      //
      // ciphertext + 16-byte GCM authentication tag
      //
      final Uint8List ciphertext = encryptedWithTag.sublist(
        0,
        encryptedWithTag.length - tagSize,
      );

      final Uint8List tag = encryptedWithTag.sublist(
        encryptedWithTag.length - tagSize,
      );

      // ------------------------------------------
      // 3. Create AES-256-GCM
      // ------------------------------------------
      final algorithm = AesGcm.with256bits();

      // Secret key must be exactly 32 bytes
      final keyBytes = utf8.encode(secretKey);

      if (keyBytes.length != 32) {
        throw Exception('AES-256 key must be exactly 32 bytes');
      }

      final secretKeyObject = SecretKey(keyBytes);

      // ------------------------------------------
      // 4. Create SecretBox
      // ------------------------------------------
      final secretBox = SecretBox(ciphertext, nonce: iv, mac: Mac(tag));

      // ------------------------------------------
      // 5. Decrypt
      // ------------------------------------------
      final decryptedBytes = await algorithm.decrypt(
        secretBox,
        secretKey: secretKeyObject,
      );

      return utf8.decode(decryptedBytes);
    } catch (e) {
      throw Exception('QR decryption failed');
    }
  }
}
