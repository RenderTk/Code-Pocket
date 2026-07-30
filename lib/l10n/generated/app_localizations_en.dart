// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Code Pocket';

  @override
  String get appLogoSemantics => 'Code Pocket logo';

  @override
  String get createTab => 'Create';

  @override
  String get scanTab => 'Scan';

  @override
  String get libraryTab => 'Library';

  @override
  String get libraryCleared => 'Library cleared';

  @override
  String get libraryClearFailed => 'Could not clear the library';

  @override
  String get libraryOptions => 'Library options';

  @override
  String get deleteAll => 'Delete all';

  @override
  String get deleteAllTitle => 'Delete every saved code?';

  @override
  String get deleteAllMessage =>
      'This removes all QR codes and barcodes from this device. This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get qrCode => 'QR Code';

  @override
  String get barcode => 'Barcode';

  @override
  String get qrCodes => 'QR codes';

  @override
  String get barcodes => 'Barcodes';

  @override
  String get all => 'All';

  @override
  String get qrTitleHint => 'Example: Event invitation';

  @override
  String get barcodeTitleHint => 'Example: Inventory label';

  @override
  String get qrDataHint => 'Paste a link, message, or any text';

  @override
  String get barcodeDataHint => 'Enter the value to encode';

  @override
  String get generateQrCode => 'Generate QR code';

  @override
  String get generateBarcode => 'Generate barcode';

  @override
  String get qrNameRequired => 'Enter a name for this QR Code.';

  @override
  String get barcodeNameRequired => 'Enter a name for this Barcode.';

  @override
  String get duplicateName => 'A saved code already uses this name.';

  @override
  String get contentRequired => 'Enter the value you want to encode.';

  @override
  String qrTooLong(int maxLength) {
    return 'QR Codes support up to $maxLength characters.';
  }

  @override
  String barcodeTooLong(int maxLength) {
    return 'Barcodes support up to $maxLength characters.';
  }

  @override
  String get createCodeTitle => 'Create a code';

  @override
  String get createCodeDescription =>
      'Turn a link, message, or identifier into a code you can save and share.';

  @override
  String get formatLabel => 'Format';

  @override
  String get formatHelper => 'Choose how the value should be encoded.';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHelper =>
      'Use a name that will be easy to find in your library.';

  @override
  String get contentLabel => 'Content';

  @override
  String get qrContentHelper =>
      'QR codes can store links, messages, and longer text.';

  @override
  String get barcodeContentHelper =>
      'Code 128 barcodes work best with short identifiers.';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get shareFailed => 'Could not share the code';

  @override
  String get savedToLibrary => 'Saved to your library';

  @override
  String get saveFailed => 'Could not save the code';

  @override
  String get savedCodeTitle => 'Saved code';

  @override
  String get previewTitle => 'Preview';

  @override
  String get previewReady => 'Ready to scan, save, or share.';

  @override
  String get saving => 'Saving';

  @override
  String get saveToLibrary => 'Save to library';

  @override
  String get copy => 'Copy';

  @override
  String get sharing => 'Sharing';

  @override
  String get share => 'Share';

  @override
  String get createAnother => 'Create another';

  @override
  String get whiteCanvasNote =>
      'The code image uses a white canvas for reliable scanning.';

  @override
  String get encodedContent => 'Encoded content';

  @override
  String codeSemantics(String codeType, String data) {
    return '$codeType containing $data';
  }

  @override
  String get scanCodeTitle => 'Scan a code';

  @override
  String get scanCodeDescription =>
      'Align any QR code or barcode inside the frame. Detection is automatic.';

  @override
  String get scannerPaused => 'Scanner paused';

  @override
  String get holdSteady => 'Hold steady';

  @override
  String get turnFlashlightOff => 'Turn flashlight off';

  @override
  String get turnFlashlightOn => 'Turn flashlight on';

  @override
  String get resumeScanner => 'Resume scanner';

  @override
  String get pauseScanner => 'Pause scanner';

  @override
  String get switchCamera => 'Switch camera';

  @override
  String get startingCamera => 'Starting camera';

  @override
  String get cameraAccessOff => 'Camera access is off';

  @override
  String get cameraUnavailable => 'Camera unavailable';

  @override
  String get cameraPermissionHelp =>
      'Allow camera access in device settings, then try again.';

  @override
  String get cameraUnavailableHelp =>
      'Check that a camera is available, then try again.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get scanResultTitle => 'Scan result';

  @override
  String get scanSaveTitle => 'Save to your library';

  @override
  String get scanSaveHelper => 'A name is required only when saving this code.';

  @override
  String get scanNameRequired => 'Enter a name before saving.';

  @override
  String get scanAnother => 'Scan another';

  @override
  String get codeCaptured => 'Code captured';

  @override
  String get qrDetected => 'QR Code detected successfully.';

  @override
  String get barcodeDetected => 'Barcode detected successfully.';

  @override
  String get scannedQrShareTitle => 'Scanned QR Code';

  @override
  String get scannedBarcodeShareTitle => 'Scanned Barcode';

  @override
  String get codeDeleted => 'Code deleted';

  @override
  String get codeDeleteFailed => 'Could not delete the code';

  @override
  String get libraryTitle => 'Your library';

  @override
  String get libraryDescription =>
      'Find every code you have saved on this device.';

  @override
  String get searchHint => 'Search names or content';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get emptyLibraryTitle => 'Your library is empty';

  @override
  String get emptyLibraryMessage =>
      'Create a code, then save it here for quick access.';

  @override
  String get noMatchesTitle => 'No matching codes';

  @override
  String get noMatchesMessage =>
      'Try another search or choose a different filter.';

  @override
  String get libraryUnavailableTitle => 'Library unavailable';

  @override
  String get libraryUnavailableMessage =>
      'The saved codes could not be loaded from this device.';

  @override
  String get codeOptions => 'Code options';

  @override
  String get open => 'Open';

  @override
  String get delete => 'Delete';

  @override
  String get saved => 'Saved';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count min ago',
      one: '$count min ago',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hr ago',
      one: '$count hr ago',
    );
    return '$_temp0';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '$count day ago',
    );
    return '$_temp0';
  }

  @override
  String codeMetadata(String codeType, String date) {
    return '$codeType  •  $date';
  }

  @override
  String get deleteCodeTitle => 'Delete this code?';

  @override
  String deleteCodeMessage(String title) {
    return '“$title” will be removed from this device. This action cannot be undone.';
  }
}
