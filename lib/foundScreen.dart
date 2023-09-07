import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class FoundScreen extends StatefulWidget {
  final String value; // Assuming value is the URL
  final Function() screenClose;

  const FoundScreen({Key? key, required this.value, required this.screenClose})
      : super(key: key);

  @override
  State<FoundScreen> createState() => _FoundScreenState();
}

class _FoundScreenState extends State<FoundScreen> {
  // Implement the function to open the URL
  void _openUrl(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      // Handle if the URL can't be opened
      print("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return RotatedBox(
                quarterTurns: 0,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context, false);
                    widget.screenClose(); // Call screenClose function here
                  },
                ),
              );
            },
          ),
          title: Text(
            "Result",
            style: GoogleFonts.ibmPlexSerif(),
          )),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage(
                'assets/blur-background-abstract-8k-95.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              _openUrl(widget.value); // Open the URL when button is pressed
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue, // Text color
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              textStyle: TextStyle(fontSize: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              animationDuration: Duration(milliseconds: 300),
              shadowColor: Colors.blue.withOpacity(0.6),
              side: BorderSide(color: Colors.blue, width: 2),
            ),
            child: Text("Open URL"),
          ),
        ),
      ),
    );
  }
}
