import 'dart:io';

import 'package:image/image.dart' as img;

void main() {
  const iconPath = 'assets/icon/app_icon.png';

  final iconFile = File(iconPath);
  final iconBytes = iconFile.readAsBytesSync();
  final decodedImage = img.decodeImage(iconBytes);

  if (decodedImage == null) {
    throw StateError('Could not decode $iconPath.');
  }

  final normalizedImage = img
      .copyResize(
        decodedImage,
        width: 1024,
        height: 1024,
        interpolation: img.Interpolation.cubic,
      )
      .convert(numChannels: 4, withPalette: false);

  iconFile.writeAsBytesSync(img.encodePng(normalizedImage));
  stdout.writeln('Normalized $iconPath to a 1024x1024 PNG.');
}
