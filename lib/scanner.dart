import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


//import '../QRscannerOverlay.dart';
import '../foundScreen.dart';
import 'QRscannerOverlay.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;

  @override
  void initState() {
    this._screenWasClosed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Center(
          child: Text(
            "QR Code Scanner",
            style: GoogleFonts.ibmPlexSerif(),
          ),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            allowDuplicates: false,
            controller: cameraController,
            onDetect: _foundBarcode,
          ),
          QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.5))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickQRCodeImage,
        backgroundColor: Colors.pinkAccent,
        child: Icon(Icons.image),
      ),
    );
  }

  void _foundBarcode(Barcode barcode, MobileScannerArguments? args) {
    if (barcode != null && !_screenOpened) {
      final String code = barcode.rawValue ?? "___";
      _screenOpened = true;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FoundScreen(value: code, screenClose: _screenWasClosed),
        ),
      ).then((value) {
        print(value);
        _screenWasClosed();
      });
    }
  }

  Future<void> _pickQRCodeImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
  }

  void _screenWasClosed() {
    _screenOpened = false;
  }
}
