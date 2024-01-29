import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewDetails extends StatefulWidget {
  final String url;
  final String title;
  const NewDetails({super.key, required this.url, required this.title});

  @override
  State<NewDetails> createState() => _NewDetailsState();
}

class _NewDetailsState extends State<NewDetails> {
  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..loadRequest(Uri.parse(widget.url));
    return Scaffold(
      appBar: AppBar(
          titleTextStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
          backgroundColor: Colors.white,
          leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.black,)),
          title: Text(widget.title)
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
