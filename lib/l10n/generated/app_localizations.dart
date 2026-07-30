import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Code Pocket'**
  String get appName;

  /// No description provided for @appLogoSemantics.
  ///
  /// In en, this message translates to:
  /// **'Code Pocket logo'**
  String get appLogoSemantics;

  /// No description provided for @createTab.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createTab;

  /// No description provided for @scanTab.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scanTab;

  /// No description provided for @libraryTab.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get libraryTab;

  /// No description provided for @libraryCleared.
  ///
  /// In en, this message translates to:
  /// **'Library cleared'**
  String get libraryCleared;

  /// No description provided for @libraryClearFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not clear the library'**
  String get libraryClearFailed;

  /// No description provided for @libraryOptions.
  ///
  /// In en, this message translates to:
  /// **'Library options'**
  String get libraryOptions;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get deleteAll;

  /// No description provided for @deleteAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete every saved code?'**
  String get deleteAllTitle;

  /// No description provided for @deleteAllMessage.
  ///
  /// In en, this message translates to:
  /// **'This removes all QR codes and barcodes from this device. This action cannot be undone.'**
  String get deleteAllMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @qrCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCode;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @qrCodes.
  ///
  /// In en, this message translates to:
  /// **'QR codes'**
  String get qrCodes;

  /// No description provided for @barcodes.
  ///
  /// In en, this message translates to:
  /// **'Barcodes'**
  String get barcodes;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @qrTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Event invitation'**
  String get qrTitleHint;

  /// No description provided for @barcodeTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Inventory label'**
  String get barcodeTitleHint;

  /// No description provided for @qrDataHint.
  ///
  /// In en, this message translates to:
  /// **'Paste a link, message, or any text'**
  String get qrDataHint;

  /// No description provided for @barcodeDataHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the value to encode'**
  String get barcodeDataHint;

  /// No description provided for @generateQrCode.
  ///
  /// In en, this message translates to:
  /// **'Generate QR code'**
  String get generateQrCode;

  /// No description provided for @generateBarcode.
  ///
  /// In en, this message translates to:
  /// **'Generate barcode'**
  String get generateBarcode;

  /// No description provided for @qrNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name for this QR Code.'**
  String get qrNameRequired;

  /// No description provided for @barcodeNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name for this Barcode.'**
  String get barcodeNameRequired;

  /// No description provided for @duplicateName.
  ///
  /// In en, this message translates to:
  /// **'A saved code already uses this name.'**
  String get duplicateName;

  /// No description provided for @contentRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the value you want to encode.'**
  String get contentRequired;

  /// No description provided for @qrTooLong.
  ///
  /// In en, this message translates to:
  /// **'QR Codes support up to {maxLength} characters.'**
  String qrTooLong(int maxLength);

  /// No description provided for @barcodeTooLong.
  ///
  /// In en, this message translates to:
  /// **'Barcodes support up to {maxLength} characters.'**
  String barcodeTooLong(int maxLength);

  /// No description provided for @createCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a code'**
  String get createCodeTitle;

  /// No description provided for @createCodeDescription.
  ///
  /// In en, this message translates to:
  /// **'Turn a link, message, or identifier into a code you can save and share.'**
  String get createCodeDescription;

  /// No description provided for @formatLabel.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get formatLabel;

  /// No description provided for @formatHelper.
  ///
  /// In en, this message translates to:
  /// **'Choose how the value should be encoded.'**
  String get formatHelper;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @nameHelper.
  ///
  /// In en, this message translates to:
  /// **'Use a name that will be easy to find in your library.'**
  String get nameHelper;

  /// No description provided for @contentLabel.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get contentLabel;

  /// No description provided for @qrContentHelper.
  ///
  /// In en, this message translates to:
  /// **'QR codes can store links, messages, and longer text.'**
  String get qrContentHelper;

  /// No description provided for @barcodeContentHelper.
  ///
  /// In en, this message translates to:
  /// **'Code 128 barcodes work best with short identifiers.'**
  String get barcodeContentHelper;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @shareFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not share the code'**
  String get shareFailed;

  /// No description provided for @savedToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Saved to your library'**
  String get savedToLibrary;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the code'**
  String get saveFailed;

  /// No description provided for @savedCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved code'**
  String get savedCodeTitle;

  /// No description provided for @previewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewTitle;

  /// No description provided for @previewReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to scan, save, or share.'**
  String get previewReady;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving'**
  String get saving;

  /// No description provided for @saveToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Save to library'**
  String get saveToLibrary;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @sharing.
  ///
  /// In en, this message translates to:
  /// **'Sharing'**
  String get sharing;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @createAnother.
  ///
  /// In en, this message translates to:
  /// **'Create another'**
  String get createAnother;

  /// No description provided for @whiteCanvasNote.
  ///
  /// In en, this message translates to:
  /// **'The code image uses a white canvas for reliable scanning.'**
  String get whiteCanvasNote;

  /// No description provided for @encodedContent.
  ///
  /// In en, this message translates to:
  /// **'Encoded content'**
  String get encodedContent;

  /// No description provided for @codeSemantics.
  ///
  /// In en, this message translates to:
  /// **'{codeType} containing {data}'**
  String codeSemantics(String codeType, String data);

  /// No description provided for @scanCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan a code'**
  String get scanCodeTitle;

  /// No description provided for @scanCodeDescription.
  ///
  /// In en, this message translates to:
  /// **'Align any QR code or barcode inside the frame. Detection is automatic.'**
  String get scanCodeDescription;

  /// No description provided for @scannerPaused.
  ///
  /// In en, this message translates to:
  /// **'Scanner paused'**
  String get scannerPaused;

  /// No description provided for @holdSteady.
  ///
  /// In en, this message translates to:
  /// **'Hold steady'**
  String get holdSteady;

  /// No description provided for @turnFlashlightOff.
  ///
  /// In en, this message translates to:
  /// **'Turn flashlight off'**
  String get turnFlashlightOff;

  /// No description provided for @turnFlashlightOn.
  ///
  /// In en, this message translates to:
  /// **'Turn flashlight on'**
  String get turnFlashlightOn;

  /// No description provided for @resumeScanner.
  ///
  /// In en, this message translates to:
  /// **'Resume scanner'**
  String get resumeScanner;

  /// No description provided for @pauseScanner.
  ///
  /// In en, this message translates to:
  /// **'Pause scanner'**
  String get pauseScanner;

  /// No description provided for @switchCamera.
  ///
  /// In en, this message translates to:
  /// **'Switch camera'**
  String get switchCamera;

  /// No description provided for @startingCamera.
  ///
  /// In en, this message translates to:
  /// **'Starting camera'**
  String get startingCamera;

  /// No description provided for @cameraAccessOff.
  ///
  /// In en, this message translates to:
  /// **'Camera access is off'**
  String get cameraAccessOff;

  /// No description provided for @cameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera unavailable'**
  String get cameraUnavailable;

  /// No description provided for @cameraPermissionHelp.
  ///
  /// In en, this message translates to:
  /// **'Allow camera access in device settings, then try again.'**
  String get cameraPermissionHelp;

  /// No description provided for @cameraUnavailableHelp.
  ///
  /// In en, this message translates to:
  /// **'Check that a camera is available, then try again.'**
  String get cameraUnavailableHelp;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @scanResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan result'**
  String get scanResultTitle;

  /// No description provided for @scanSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Save to your library'**
  String get scanSaveTitle;

  /// No description provided for @scanSaveHelper.
  ///
  /// In en, this message translates to:
  /// **'A name is required only when saving this code.'**
  String get scanSaveHelper;

  /// No description provided for @scanNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name before saving.'**
  String get scanNameRequired;

  /// No description provided for @scanAnother.
  ///
  /// In en, this message translates to:
  /// **'Scan another'**
  String get scanAnother;

  /// No description provided for @codeCaptured.
  ///
  /// In en, this message translates to:
  /// **'Code captured'**
  String get codeCaptured;

  /// No description provided for @qrDetected.
  ///
  /// In en, this message translates to:
  /// **'QR Code detected successfully.'**
  String get qrDetected;

  /// No description provided for @barcodeDetected.
  ///
  /// In en, this message translates to:
  /// **'Barcode detected successfully.'**
  String get barcodeDetected;

  /// No description provided for @scannedQrShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Scanned QR Code'**
  String get scannedQrShareTitle;

  /// No description provided for @scannedBarcodeShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Scanned Barcode'**
  String get scannedBarcodeShareTitle;

  /// No description provided for @codeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Code deleted'**
  String get codeDeleted;

  /// No description provided for @codeDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the code'**
  String get codeDeleteFailed;

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your library'**
  String get libraryTitle;

  /// No description provided for @libraryDescription.
  ///
  /// In en, this message translates to:
  /// **'Find every code you have saved on this device.'**
  String get libraryDescription;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search names or content'**
  String get searchHint;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @emptyLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your library is empty'**
  String get emptyLibraryTitle;

  /// No description provided for @emptyLibraryMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a code, then save it here for quick access.'**
  String get emptyLibraryMessage;

  /// No description provided for @noMatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching codes'**
  String get noMatchesTitle;

  /// No description provided for @noMatchesMessage.
  ///
  /// In en, this message translates to:
  /// **'Try another search or choose a different filter.'**
  String get noMatchesMessage;

  /// No description provided for @libraryUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Library unavailable'**
  String get libraryUnavailableTitle;

  /// No description provided for @libraryUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'The saved codes could not be loaded from this device.'**
  String get libraryUnavailableMessage;

  /// No description provided for @codeOptions.
  ///
  /// In en, this message translates to:
  /// **'Code options'**
  String get codeOptions;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} min ago} other{{count} min ago}}'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} hr ago} other{{count} hr ago}}'**
  String hoursAgo(int count);

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} day ago} other{{count} days ago}}'**
  String daysAgo(int count);

  /// No description provided for @codeMetadata.
  ///
  /// In en, this message translates to:
  /// **'{codeType}  •  {date}'**
  String codeMetadata(String codeType, String date);

  /// No description provided for @deleteCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this code?'**
  String get deleteCodeTitle;

  /// No description provided for @deleteCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'“{title}” will be removed from this device. This action cannot be undone.'**
  String deleteCodeMessage(String title);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
