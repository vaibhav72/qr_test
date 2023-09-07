// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _linkController = TextEditingController();
  String _generatedQrCode = '';

  void _generateQrCode() {
    setState(() {
      _generatedQrCode = _linkController.text;
    });
  }

  Future<void> _saveQrCode() async {
    if (_generatedQrCode.isNotEmpty) {
      try {
        final qrImageData = await QrPainter(
          data: _generatedQrCode,
          version: QrVersions.auto,
          gapless: true,
          color: Colors.black,
          emptyColor: Colors.white,
        ).toImageData(200);

        if (qrImageData != null) {
          final result = await ImageGallerySaver.saveImage(
            qrImageData.buffer.asUint8List(),
            quality: 80,
            name: "qr_code",
          );
          if (result['isSuccess']) {
            print('QR Code saved to gallery: ${result['filePath']}');
            _showSnackBar('QR Code saved successfully!');
          } else {
            print('Failed to save QR Code: ${result['errorMessage']}');
            _showSnackBar('Failed to save QR Code.');
          }
        } else {
          print('Error generating QR Code image data');
          _showSnackBar('Error generating QR Code.');
        }
      } catch (e) {
        print('Error saving QR Code: $e');
        _showSnackBar('Error saving QR Code: $e');
      }
    } else {
      print('No QR Code to save.');
      _showSnackBar('No QR Code to save.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        elevation: 6.0, // You can adjust the elevation as needed
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'QR Code Generator',
          style: GoogleFonts.ibmPlexSerif(),
        )),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage(
                'assets/images.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: QrImageView(
                  data: _generatedQrCode,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _linkController,
                decoration: InputDecoration(
                  labelText: 'Enter Link',
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateQrCode,
              child: Text(
                'Generate QR Code',
                style: GoogleFonts.noticiaText(),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: _saveQrCode,
              child: Text(
                'Save QR Code',
                style: GoogleFonts.noticiaText(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
