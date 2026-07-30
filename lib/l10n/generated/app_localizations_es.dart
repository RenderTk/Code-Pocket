// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Code Pocket';

  @override
  String get appLogoSemantics => 'Logotipo de Code Pocket';

  @override
  String get createTab => 'Crear';

  @override
  String get scanTab => 'Escanear';

  @override
  String get libraryTab => 'Biblioteca';

  @override
  String get libraryCleared => 'Biblioteca vaciada';

  @override
  String get libraryClearFailed => 'No se pudo vaciar la biblioteca';

  @override
  String get libraryOptions => 'Opciones de la biblioteca';

  @override
  String get deleteAll => 'Eliminar todo';

  @override
  String get deleteAllTitle => '¿Eliminar todos los códigos guardados?';

  @override
  String get deleteAllMessage =>
      'Esto elimina de este dispositivo todos los códigos QR y de barras. Esta acción no se puede deshacer.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get qrCode => 'Código QR';

  @override
  String get barcode => 'Código de barras';

  @override
  String get qrCodes => 'Códigos QR';

  @override
  String get barcodes => 'Códigos de barras';

  @override
  String get all => 'Todos';

  @override
  String get qrTitleHint => 'Ejemplo: Invitación al evento';

  @override
  String get barcodeTitleHint => 'Ejemplo: Etiqueta de inventario';

  @override
  String get qrDataHint => 'Pega un enlace, mensaje o cualquier texto';

  @override
  String get barcodeDataHint => 'Escribe el valor que deseas codificar';

  @override
  String get generateQrCode => 'Generar código QR';

  @override
  String get generateBarcode => 'Generar código de barras';

  @override
  String get qrNameRequired => 'Escribe un nombre para este código QR.';

  @override
  String get barcodeNameRequired =>
      'Escribe un nombre para este código de barras.';

  @override
  String get duplicateName => 'Ya existe un código guardado con este nombre.';

  @override
  String get contentRequired => 'Escribe el valor que deseas codificar.';

  @override
  String qrTooLong(int maxLength) {
    return 'Los códigos QR admiten hasta $maxLength caracteres.';
  }

  @override
  String barcodeTooLong(int maxLength) {
    return 'Los códigos de barras admiten hasta $maxLength caracteres.';
  }

  @override
  String get createCodeTitle => 'Crear un código';

  @override
  String get createCodeDescription =>
      'Convierte un enlace, mensaje o identificador en un código que puedes guardar y compartir.';

  @override
  String get formatLabel => 'Formato';

  @override
  String get formatHelper => 'Elige cómo se debe codificar el valor.';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get nameHelper =>
      'Usa un nombre que sea fácil de encontrar en tu biblioteca.';

  @override
  String get contentLabel => 'Contenido';

  @override
  String get qrContentHelper =>
      'Los códigos QR pueden guardar enlaces, mensajes y textos más largos.';

  @override
  String get barcodeContentHelper =>
      'Los códigos de barras Code 128 funcionan mejor con identificadores cortos.';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get shareFailed => 'No se pudo compartir el código';

  @override
  String get savedToLibrary => 'Guardado en tu biblioteca';

  @override
  String get saveFailed => 'No se pudo guardar el código';

  @override
  String get savedCodeTitle => 'Código guardado';

  @override
  String get previewTitle => 'Vista previa';

  @override
  String get previewReady => 'Listo para escanear, guardar o compartir.';

  @override
  String get saving => 'Guardando';

  @override
  String get saveToLibrary => 'Guardar en la biblioteca';

  @override
  String get copy => 'Copiar';

  @override
  String get sharing => 'Compartiendo';

  @override
  String get share => 'Compartir';

  @override
  String get createAnother => 'Crear otro';

  @override
  String get whiteCanvasNote =>
      'La imagen usa un fondo blanco para garantizar un escaneo confiable.';

  @override
  String get encodedContent => 'Contenido codificado';

  @override
  String codeSemantics(String codeType, String data) {
    return '$codeType que contiene $data';
  }

  @override
  String get scanCodeTitle => 'Escanear un código';

  @override
  String get scanCodeDescription =>
      'Alinea cualquier código QR o de barras dentro del marco. La detección es automática.';

  @override
  String get scannerPaused => 'Escáner en pausa';

  @override
  String get holdSteady => 'Mantén el dispositivo estable';

  @override
  String get turnFlashlightOff => 'Apagar la linterna';

  @override
  String get turnFlashlightOn => 'Encender la linterna';

  @override
  String get resumeScanner => 'Reanudar el escáner';

  @override
  String get pauseScanner => 'Pausar el escáner';

  @override
  String get switchCamera => 'Cambiar cámara';

  @override
  String get startingCamera => 'Iniciando cámara';

  @override
  String get cameraAccessOff => 'El acceso a la cámara está desactivado';

  @override
  String get cameraUnavailable => 'Cámara no disponible';

  @override
  String get cameraPermissionHelp =>
      'Permite el acceso a la cámara en los ajustes del dispositivo y vuelve a intentarlo.';

  @override
  String get cameraUnavailableHelp =>
      'Comprueba que haya una cámara disponible y vuelve a intentarlo.';

  @override
  String get tryAgain => 'Volver a intentar';

  @override
  String get scanResultTitle => 'Resultado del escaneo';

  @override
  String get scanSaveTitle => 'Guardar en tu biblioteca';

  @override
  String get scanSaveHelper =>
      'Solo necesitas un nombre para guardar este código.';

  @override
  String get scanNameRequired => 'Escribe un nombre antes de guardar.';

  @override
  String get scanAnother => 'Escanear otro';

  @override
  String get codeCaptured => 'Código capturado';

  @override
  String get qrDetected => 'Código QR detectado correctamente.';

  @override
  String get barcodeDetected => 'Código de barras detectado correctamente.';

  @override
  String get scannedQrShareTitle => 'Código QR escaneado';

  @override
  String get scannedBarcodeShareTitle => 'Código de barras escaneado';

  @override
  String get codeDeleted => 'Código eliminado';

  @override
  String get codeDeleteFailed => 'No se pudo eliminar el código';

  @override
  String get libraryTitle => 'Tu biblioteca';

  @override
  String get libraryDescription =>
      'Encuentra todos los códigos que has guardado en este dispositivo.';

  @override
  String get searchHint => 'Buscar por nombre o contenido';

  @override
  String get clearSearch => 'Borrar búsqueda';

  @override
  String get emptyLibraryTitle => 'Tu biblioteca está vacía';

  @override
  String get emptyLibraryMessage =>
      'Crea un código y guárdalo aquí para acceder rápidamente.';

  @override
  String get noMatchesTitle => 'No hay códigos coincidentes';

  @override
  String get noMatchesMessage =>
      'Prueba otra búsqueda o elige un filtro diferente.';

  @override
  String get libraryUnavailableTitle => 'Biblioteca no disponible';

  @override
  String get libraryUnavailableMessage =>
      'No se pudieron cargar los códigos guardados en este dispositivo.';

  @override
  String get codeOptions => 'Opciones del código';

  @override
  String get open => 'Abrir';

  @override
  String get delete => 'Eliminar';

  @override
  String get saved => 'Guardado';

  @override
  String get justNow => 'Ahora mismo';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count min',
      one: 'Hace $count min',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count h',
      one: 'Hace $count h',
    );
    return '$_temp0';
  }

  @override
  String get yesterday => 'Ayer';

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count días',
      one: 'Hace $count día',
    );
    return '$_temp0';
  }

  @override
  String codeMetadata(String codeType, String date) {
    return '$codeType  •  $date';
  }

  @override
  String get deleteCodeTitle => '¿Eliminar este código?';

  @override
  String deleteCodeMessage(String title) {
    return '“$title” se eliminará de este dispositivo. Esta acción no se puede deshacer.';
  }
}
